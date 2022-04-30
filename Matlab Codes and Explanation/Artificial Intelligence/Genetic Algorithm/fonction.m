function  [xz,y,z] = fonction(arg1,arg2);
%PEAKS  fungsi dengan 2 variabel 
%   PEAKS dengan fungsi berisi penerjemah dan scaling Gaussian distributions,
%yang cocok utk demonstrasikan
%   MESH, SURF, PCOLOR, CONTOUR
%   ada beberapa urutan :
%
%       Z = PEAKS;
%       Z = PEAKS(N);
%       Z = PEAKS(V);
%       Z = PEAKS(X,Y);
%
%       PEAKS;
%       PEAKS(N);
%       PEAKS(V);
%       PEAKS(X,Y);
%
%       [X,Y,Z] = PEAKS;
%       [X,Y,Z] = PEAKS(N);
%       [X,Y,Z] = PEAKS(V);
%
%   varian 1 menghasilkan 49-by-49 matrix.
%  varian 2 menghasilkan N-by-N matrix.
%   varian 3 menghasilkan N-by-N matrix where N = length(V).
%   varian 4 mengevaluasi  function di X dan Y
% yg sama ukurannya. hasil Z juga sm ukuranny
%
%   variant ke 4 denga no output arguments, buat SURF
%   plot sbagai hasilnya
%
%   varian 3 terakhir jg menghasilkan 2 matriks X and Y
%   utk digunkan di comman spti PCOLOR(X,Y,Z) atau SURF(X,Y,Z,DEL2(Z)).
%
%   jika tdk diberikan sbgai input matriks X dan Y
%       [X,Y] = MESHGRID(V,V) 
%   dimana V adalah vektor, atau V sebuah vektor dengan N 
%   elements = dari -3 to 3.  jika argument tdk ada = diberikan
%    default N adalah 49.

if nargin == 0
    dx = 1/8;
    [x,y] = meshgrid(-3:dx:3);
elseif nargin == 1
    if length(arg1) == 1
        [x,y] = meshgrid(-3:6/(arg1-1):3);
    else
        [x,y] = meshgrid(arg1,arg1);     
    end
else
    x = arg1; y = arg2;
end

z =  exp(-(x-0.5).^2)+exp(-(y-0.7).^2)+(1/25)*exp(-(x+0.2).^2)+(1/25)*exp(-(x-0.2).^2)+(1/25)*exp(-(y+1).^2)+(1/25)*exp(-(y-1).^2);

if nargout > 1
    xz = x;
elseif nargout == 1
    xz = z;
else
    % Self demonstration
  
    surf(x,y,z)
    axis([min(min(x)) max(max(x)) min(min(y)) max(max(y)) ...
          min(min(z)) max(max(z))])
    xlabel('x'), ylabel('y'), title('L a fonction à maximiser')
end
