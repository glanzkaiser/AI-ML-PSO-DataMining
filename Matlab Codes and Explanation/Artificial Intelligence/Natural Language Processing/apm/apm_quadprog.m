function y = apm_quadprog(H,f,A,b,Aeq,beq,lb,ub,x0)
% filename to write
filename = ['qp.apm'];

% extract H and f in sparse form
if ~isempty(H),
    [mH,nH] = size(H);
    if (mH~=nH),
        error('H must be a square matrix');
    end
    if isempty(f),
        f = zeros(mH,1);
        mf = mH;
    else
        if size(f,1)==1,
            f = f';
        end
        [mf,nf] = size(f);
    end
    if (mH~=mf),
        error('Rows of H and f must agree');
    end
    
    % convert to sparse form
    [hi,hj,hv] = find(sparse(H));
    h = [hi,hj,hv]';
    [fi,fj,fv] = find(sparse(f));
    f = [fi,fj,fv]';
    if(size(f,2)==0),
        f = [1,1,0]';
    end
    fr = [f(1,:); f(3,:)];
end

% extract A and b in sparse form
if ~isempty(A),
    [mA,nA] = size(A);
    if isempty(b),
        b = zeros(mA,1);
        mB = mA;
    else
        if size(b,1)==1,
            b = b';
        end
        [mB,nB] = size(b);
    end
    if (mA~=mB),
        error('Rows of A and b must agree');
    end
    
    % convert to sparse form
    [ai,aj,av] = find(sparse(A));
    if (mA==1),
        a = [ai;aj;av];
    else
        a = [ai,aj,av]';
    end
    [bi,bj,bv] = find(sparse(b));
    b = [bi,bj,bv]';
    if(size(b,2)==0),
        b = [1,1,0]';
    end
    br = [b(1,:); b(3,:)];
end

% extract Aeq and beq in sparse form
if ~isempty(Aeq),
    [mAeq,nAeq] = size(Aeq);
    if isempty(beq),
        beq = zeros(mAeq,1);
        mBeq = mAeq;
    else
        if size(beq,1)==1,
            beq = beq';
        end
        [mBeq,nBeq] = size(beq);
    end
    if (mAeq~=mBeq),
        error('Rows of Aeq and beq must agree');
    end
    
    % convert to sparse form
    [aeqi,aeqj,aeqv] = find(sparse(Aeq));
    if (mAeq==1),
        aeq = [aeqi;aeqj;aeqv];
    else
        aeq = [aeqi,aeqj,aeqv]';
    end
    [beqi,beqj,beqv] = find(sparse(beq));
    beq = [beqi,beqj,beqv]';
    if(size(beq,2)==0),
        beq = [1,1,0]';
    end
    beqr = [beq(1,:); beq(3,:)];
end

disp('Creating Quadratic Programming Model qp.apm');
fid = fopen(filename,'w');
fprintf( fid,'\n');
fprintf( fid,'Objects \n');
if ~isempty(H),
    fprintf( fid,[' h = qobj\n']);
end
if ~isempty(A),
    fprintf( fid,[' a = axb\n']);
end
if ~isempty(Aeq),
    fprintf( fid,[' aeq = axb\n']);
end
fprintf( fid,'End Objects \n');
fprintf( fid,'\n');
fprintf( fid,'Connections\n');
sz = -1;
if ~isempty(H),
    fprintf( fid,['  x[1:%d] = h.x[1:%d]\n'],nH,nH);
    sz = nH;
end
if ~isempty(A),
    fprintf( fid,['  x[1:%d] = a.x[1:%d]\n'],nA,nA);
    if (sz>=0),
        if (nA~=sz),
            error('Variables in Ax < b model must be consistent');
        end
    end
end
if ~isempty(Aeq),
    fprintf( fid,['  x[1:%d] = aeq.x[1:%d]\n'],nAeq,nAeq);
    if (sz>=0),
        if (nAeq~=sz),
            error('Variables in Ax = b model must be consistent');
        end
    end
end
fprintf( fid,'End Connections\n');
fprintf( fid,'\n');
fprintf( fid,'Model \n');
fprintf( fid,'  Variables \n');
if (isempty(x0)&&isempty(lb)&&isempty(ub)),
    % default initial conditions
    fprintf( fid,'    x[1:%d] = 0\n',nH);
else
    % create default values
    if (isempty(x0)),
        x0 = zeros(nH,1);
    end
    if (isempty(lb)),
        lb = -1e10 * ones(nH,1);
    end
    if (isempty(ub)),
        ub = 1e10 * ones(nH,1);
    end
    % generate initial conditions and bounds
    for i = 1:nH,
        fprintf( fid,'    x[%i] > %d = %d < %d\n',i,lb(i),x0(i),ub(i));
    end
end
fprintf( fid,'  End Variables \n');
fprintf( fid,'\n');
fprintf( fid,'  Equations \n');
fprintf( fid,'    ! add any additional equations here \n');
fprintf( fid,'  End Equations \n');
fprintf( fid,'End Model \n');
fprintf( fid,'\n');

if ~isempty(H),
    fprintf( fid,'\n');
    fprintf( fid,['File h.txt\n']);
    fprintf( fid,['  sparse, minimize  ! dense or sparse, minimize or maximize\n']);
    fprintf( fid,'  %d      ! n=number of variables \n',mH);
    fprintf( fid,'End File\n');
    fprintf( fid,'\n');
    fprintf( fid,['File h.a.txt \n']);
    fprintf( fid,'   %d %d %f\n', h );
    fprintf( fid,'End File \n');
    fprintf( fid,'\n');
    fprintf( fid,['File h.b.txt \n']);
    fprintf( fid,'   %d %f\n', fr );
    fprintf( fid,'End File \n');
end

if ~isempty(A),
    fprintf( fid,'\n');
    fprintf( fid,['File a.txt\n']);
    fprintf( fid,['  sparse, Ax<b \n']);
    fprintf( fid,'  %d      ! m=number of rows in A and b \n',mA);
    fprintf( fid,'  %d      ! n=number of columns in A or variables x\n',nA);
    fprintf( fid,'End File\n');
    fprintf( fid,'\n');
    fprintf( fid,['File a.a.txt \n']);
    fprintf( fid,'   %d %d %f\n', a );
    fprintf( fid,'End File \n');
    fprintf( fid,'\n');
    fprintf( fid,['File a.b.txt \n']);
    fprintf( fid,'   %d %f\n', br );
    fprintf( fid,'End File \n');
end

if ~isempty(Aeq),
    fprintf( fid,'\n');
    fprintf( fid,['File aeq.txt\n']);
    fprintf( fid,['  sparse, Ax=b \n']);
    fprintf( fid,'  %d      ! m=number of rows in A and b \n',mAeq);
    fprintf( fid,'  %d      ! n=number of columns in A or variables x\n',nAeq);
    fprintf( fid,'End File\n');
    fprintf( fid,'\n');
    fprintf( fid,['File aeq.a.txt \n']);
    fprintf( fid,'   %d %d %f\n', aeq );
    fprintf( fid,'End File \n');
    fprintf( fid,'\n');
    fprintf( fid,['File aeq.b.txt \n']);
    fprintf( fid,'   %d %f\n', beqr );
    fprintf( fid,'End File \n');
end
fclose(fid);

disp('Solving Quadratic Programming Model qp.apm');
s = 'http://xps.apmonitor.com';
a = 'qp';
apm(s,a,'clear all');
apm_load(s,a,'qp.apm');
% select solver (1=APOPT,2=BPOPT,3=IPOPT)
apm_option(s,a,'nlc.solver',1);
output = apm(s,a,'solve');
disp(output);

% return solution
y = apm_sol(s,a);

end