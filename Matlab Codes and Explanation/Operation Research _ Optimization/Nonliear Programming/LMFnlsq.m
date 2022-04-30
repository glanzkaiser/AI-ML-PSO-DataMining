function [xf, SS, cnt, res, XY] = LMFnlsq(varargin)
if nargin==0 && nargout==0, help LMFnlsq, return, end     %   Display help

%   Options = LMFnlsq;
%   Options = LMFnlsq('default');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Default Options
if nargin==0 || (nargin==1 && strcmpi('default',varargin(1)))
   xf.Display  = 0;         %   no print of iterations
   xf.Jacobian = 'finjac';  %   finite difference Jacobian approximation
   xf.MaxIter  = 0;         %   maximum number of iterations allowed
   xf.ScaleD   = [];        %   automatic scaling by D = diag(diag(J'*J))
   xf.FunTol   = 1e-7;      %   tolerace for final function value
   xf.XTol     = 1e-7;      %   tolerance on difference of x-solutions
   xf.Printf   = 'printit'; %   disply intermediate results
   xf.Trace    = 0;         %   don't save  intermediate results
   xf.Lambda   = 0;         %   start with Newton iteration
   return

%   Options = LMFnlsq(Options,name,value,...);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Updating Options
elseif isstruct(varargin{1}) % Options=LMFnlsq(Options,'Name','Value',...)
    if ~isfield(varargin{1},'Jacobian')
        error('Options Structure not Correct for LMFnlsq.')
    end
    xf=varargin{1};          %   Options
    for i=2:2:nargin-1
        name=varargin{i};    %   option to be updated
        if ~ischar(name)
            error('Parameter Names Must be Strings.')
        end
        name=lower(name(isletter(name)));
        value=varargin{i+1}; %   value of the option
        if strncmp(name,'d',1), xf.Display  = value;
        elseif strncmp(name,'f',1), xf.FunTol   = value;
        elseif strncmp(name,'x',1), xf.XTol     = value;
        elseif strncmp(name,'j',1), xf.Jacobian = value;
        elseif strncmp(name,'m',1), xf.MaxIter  = value;
        elseif strncmp(name,'s',1), xf.ScaleD   = value;
        elseif strncmp(name,'p',1), xf.Printf   = value;
        elseif strncmp(name,'t',1), xf.Trace    = value;
        elseif strncmp(name,'l',1), xf.Lambda   = value;
        else   disp(['Unknown Parameter Name --> ' name])
        end
    end
    return

%   Options = LMFnlsq(name,value,...);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Pairs of Options
elseif ischar(varargin{1})  % check for Options=LMFnlsq('Name',Value,...)
   Pnames=char('display','funtol','xtol','jacobian','maxiter','scaled',...
               'printf','trace','lambda');
   if strncmpi(varargin{1},Pnames,length(varargin{1}))
      xf=LMFnlsq('default');  % get default values
      xf=LMFnlsq(xf,varargin{:});
      return
   end
end

%   [Xf,Ssq,CNT,Res,XY] = LMFnlsq(FUN,Xo,Options);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%               OPTIONS
%               *******
FUN=varargin{1};            %   function handle
if ~(isvarname(FUN) || isa(FUN,'function_handle'))
   error('FUN Must be a Function Handle or M-file Name.')
end
xc=varargin{2};             %   Xo
if ~exist('options','var')
    options = LMFnlsq('default');
end
if nargin>2                 %   OPTIONS
    if isstruct(varargin{3})
        options=varargin{3};
    else
        for i=3:2:size(varargin,2)-1
            options=LMFnlsq(options, varargin{i},varargin{i+1});
        end
    end
else
    if ~exist('options','var')
        options = LMFnlsq('default');
    end
end




%               INITIATION OF SOLUTION
%               **********************
x = xc(:);
n = length(x);
epsx = options.XTol(:);
le = length(epsx);
if le==1
    epsx=epsx*ones(n,1);
elseif le~=n
    error(['Dimensions of vector epsx ',num2str(le),'~=',num2str(lx)]);
end
epsf  = options.FunTol(:);
ipr   = options.Display;
JAC   = options.Jacobian;
maxit = options.MaxIter;    %   maximum permitted number of iterations
if maxit==0, maxit=100*n; end
printf= options.Printf;

r = feval(FUN,x);
[A,v] = getAv(FUN,JAC,x,r,epsx);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SS = r'*r;
res= 1;
cnt=0;
trcXY = options.Trace;      %   iteration tracing
if trcXY
    XY = zeros(n,maxit);
    XY(:,1) = x;
else
    XY = [];
end

D = options.ScaleD(:);      %   CONSTANT SCALE CONTROL D
if isempty(D)
    D=diag(A);              %   automatic scaling
else
    ld=length(D);
    if ld==1
        D=abs(D)*ones(n,1); %   scalar of unique scaling
    elseif ld~=n
        error(['wrong number of scales D, lD = ',num2str(ld)])
    end
end
D(D<=0)=1;
T = sqrt(D);

Rlo=0.25;
Rhi=0.75;
l=options.Lambda;       lc=1;
feval(printf,ipr,-1);       %   Table header
dx = zeros(n,1);

%               SOLUTION
%               ********    MAIN ITERATION CYCLE
while 1 %                   ********************
    feval(printf,ipr,cnt,res,SS,x,dx,l,lc)
    cnt = cnt+1;
    if trcXY, XY(:,cnt+1)=x; end
    d = diag(A);
    s = zeros(n,1);
%                           INTERNAL CYCLE
    while 1 %               ~~~~~~~~~~~~~~
        while 1
            UA = triu(A,1);
            A = UA'+UA+diag(d+l*D);
            [U,p] = chol(A);%UA,A,U,p,D,d,l, pause   Choleski decomposition
            %~~~~~~~~~~~~~~~
            if p==0, break, end
            l = 2*l;
            if l==0, l=1; end
        end
        dx = U\(U'\v);
        vw = dx'*v;
        fin = -1;
        if vw<=0, break, end        %   The END

        for i=1:n
            z = d(i)*dx(i);
            if i>1, z=A(i,1:i-1)*dx(1:i-1)+z; end
            if i<n, z=A(i+1:n,i)'*dx(i+1:n)+z; end
            s(i) = 2*v(i)-z;
        end
        dq = s'*dx;
        s  = x-dx;
        rd = feval(FUN,s);
%            ~~~~~~~~~~~~
        res = res+1;
        SSP = rd'*rd;
        dS  = SS-SSP;
        fin = 1;
        if all((abs(dx)-epsx)<=0) || res>=maxit || abs(dS)<=epsf
            break                   %   The END
        end
        fin=0;
        if dS>=Rlo*dq, break, end
        A = U;
        y = .5;
        z = 2*vw-dS;
        if z>0, y=vw/z; end
        if y>.5, y=.5; end
        if y<.1, y=.1; end
        if l==0
            y = 2*y;
            for i = 1:n
                A(i,i) = 1/A(i,i);
            end
            for i = 2:n
                ii = i-1;
                for j= 1:ii
                    A(j,i) = -A(j,j:ii)*A(j:ii,i).*A(i,i);
                end
            end
            for i = 1:n
                for j= i:n
                    A(i,j) = abs(A(i,j:n)*A(j,j:n)');
                end
            end
            l  = 0;
            tr = diag(A)'*D;
            for i = 1:n
                z = A(1:i,i)'*T(1:i)+z;
                if i<n
                    ii = i+1;
                    z  = A(i,ii:n)*T(ii:n)+z;
                end
                z = z*T(i);
                if z>l, l=z; end
            end
            if tr<l, l=tr; end
            l  = 1/l;
            lc = l;
        end
        l = l/y;
        if dS>0, dS=-1e300; break, end
    end %  while            INTERNAL CYCLE LOOP
%                           ~~~~~~~~~~~~~~~~~~~

    if fin, break, end
    if dS>Rhi*dq
        l=l/2;
        if l<lc, l=0; end
    end
    SS=SSP;  x=s;  r=rd;
    [A,v] = getAv(FUN,JAC,x,r,epsx);
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end % while                 MAIN ITERATION CYCLE LOOP
%                           *************************

if fin>0
    if dS>0
        SS = SSP;
        x  = s;
    end
end
if ipr~=0
    disp(' ');
    feval(printf,sign(ipr),cnt,res,SS,x,dx,l,lc)
end
xf = x;
if trcXY, XY(:,cnt+2)=x; end
XY(:,cnt+3:end) = [];
if res>=maxit, cnt=-maxit; end
return
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,v] = getAv(FUN,JAC,x,r,epsx)
%        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  Calculate A, v, r
if isa(JAC,'function_handle')
    J = JAC(x);
else
    J = feval(JAC,FUN,r,x,epsx);
end
A = J'*J;
v = J'*r;
%end % getAv
% --------------------------------------------------------------------

function J = finjac(FUN,r,x,epsx)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  numerical approximation to Jacobi matrix
rc = r(:);
lx = length(x);
J  = zeros(length(r),lx);
for k = 1:lx
    dx = .25*epsx(k);
    if dx==0, dx=eps; end
    xd = x;
    xd(k) = xd(k)+dx;
    rd = feval(FUN,xd);
%   ~~~~~~~~~~~~~~~~~~~
    J(:,k)=((rd(:)-rc)/dx);
end
%end % finjac
% --------------------------------------------------------------------

function printit(ipr,cnt,res,SS,x,dx,l,lc)
%        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  Printing of intermediate results
%  ipr <  0  do not print lambda columns
%      =  0  do not print at all
%      >  0  print every (ipr)th iteration
%  cnt = -1  print out the header
%         0  print out second row of results
%        >0  print out first row of results
if ipr~=0
   if cnt<0                 %   table header
      disp('')
      nch = 50+(ipr>0)*25;
      disp(char('*'*ones(1,nch)))
      fprintf('  itr  nfJ   SUM(r^2)        x           dx');
      if ipr>0
          fprintf('           l           lc');
      end
      fprintf('\n');
      disp(char('*'*ones(1,nch)))
      disp('')
   else                     %   iteration output
      if rem(cnt,ipr)==0
          f='%12.4e ';
          if ipr>0
             fprintf(['%4.0f %4.0f ' f f f f f '\n'],...
                 cnt,res,SS, x(1),dx(1),l,lc);
          else
             fprintf(['%4.0f %4.0f ' f f f '\n'],...
                 cnt,res,SS, x(1),dx(1));
          end
          for k=2:length(x)
             fprintf([blanks(23) f f '\n'],x(k),dx(k));
          end
      end
   end
end
%end % printit
%end % LMFnlsq