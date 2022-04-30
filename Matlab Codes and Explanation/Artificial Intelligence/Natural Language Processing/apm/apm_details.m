
function y = apm_details(server,app,x,lam)

persistent sol_prev sol_count

% initialize sol_count
if (isempty(sol_count)),
    sol_count = 0;
end

% nama kondisi aplikasi
app = lower(deblank(app));

% toleransi utk check jika nilai tdk sama dg sebelumnnya
tol = 1e-10;

% pilihan load solution vector dari variables
if (nargin>=3),
    % buat 'warm' sbagai vektor kolom
    if (size(x,1)==1),
        warm = x';
    else
        warm = x;
    end
    
    % jika nilai = nilai sblmnya
    warm_sum = sum(warm);
    for i = 1:sol_count,
        % check nilai awal
        if (abs(sol_prev(i).y.sumx-warm_sum) <= tol),
            % check individual elements selanjutnya
            if (abs(sol_prev(i).y.var.val-warm) <= tol),
                % kembalikan solusi sblmnya jika nilai tdk berubah
                y = sol_prev(i).y;
                return
            end
        end
    end
    
    % load warm.t0 ke server
    fid = fopen('warm.t0','w');
    fprintf(fid,'%20.12e\n',warm);
    fclose(fid);
    
    t0_load(server,app,'warm.t0');
    delete('warm.t0');
end

% pilihan load lagrange multipliers ke server
if (nargin>=4),
    % create 'lam' as a column vector
    if (size(lam,1)==1),
        lam = lam';
    end
    
    fid = fopen('lam.t0','w');
    fprintf(fid,'%20.12e\n',lam);
    fclose(fid);
    
    t0_load(server,app,'lam.t0');
    delete('lam.t0');
end

% hitung details di server 
output = apm(server,app,'solve');

% mengambil nilai dan batasan
apm_get(server,app,'apm_var.txt');
load apm_var.txt
delete('apm_var.txt');
y.nvar = size(apm_var,1); % dapat jumlah dari variables
y.var.lb = apm_var(:,1);
y.var.val = apm_var(:,2);
y.var.ub = apm_var(:,3);

% ambil nilai fungsi objecktif 
apm_get(server,app,'apm_obj.txt');
load apm_obj.txt
delete('apm_obj.txt');
y.obj = apm_obj;

% ambil gradient objective
apm_get(server,app,'apm_obj_grad.txt');
load apm_obj_grad.txt
delete('apm_obj_grad.txt');
y.obj_grad = apm_obj_grad;

% ambil residual dan batasan
apm_get(server,app,'apm_eqn.txt');
load apm_eqn.txt
delete('apm_eqn.txt');
y.neqn = size(apm_eqn,1); % dapat nilai persamaan
y.eqn.lb = apm_eqn(:,1);
y.eqn.res = apm_eqn(:,2);
y.eqn.ub = apm_eqn(:,3);

% ambil jacobian
apm_get(server,app,'apm_jac.txt');
load apm_jac.txt
delete('apm_jac.txt');
jac = apm_jac;
y.jac = sparse(jac(:,1),jac(:,2),jac(:,3),y.neqn,y.nvar);

% ambil lagrange multipliers
apm_get(server,app,'apm_lam.txt');
load apm_lam.txt
delete('apm_lam.txt');
y.lam = apm_lam;

% ambil hessian hanya objective 
apm_get(server,app,'apm_hes_obj.txt');
load apm_hes_obj.txt
delete('apm_hes_obj.txt');
hs = apm_hes_obj;
y.hes_obj = sparse(hs(:,1),hs(:,2),hs(:,3),y.nvar,y.nvar);

% ambil hessian dari persamaan saja
apm_get(server,app,'apm_hes_eqn.txt');
load apm_hes_eqn.txt
delete('apm_hes_eqn.txt');
hs = apm_hes_eqn;
nhs = size(apm_hes_eqn,1);
i1(1:y.neqn)=0;
i2(1:y.neqn)=0;
% persamaan diurutkan 
for i = 1:nhs,
    if(i1(hs(i,1))==0),
        i1(hs(i,1)) = i;
    end
    i2(hs(i,1)) = i;
end
for i = 1:y.neqn,
    if (i1(i)==0),
        y.hes_eqn{i} = sparse(y.nvar,y.nvar);
    else
        y.hes_eqn{i} = sparse(hs(i1(i):i2(i),2),hs(i1(i):i2(i),3),hs(i1(i):i2(i),4),y.nvar,y.nvar);
    end
end

% bangun hessian dari obj, lam, dan eqn portions
y.hes = y.hes_obj;
for i = 1:y.neqn,
    y.hes = y.hes + y.lam(i) * y.hes_eqn{i};
end

% simpan nilai
sol_count = sol_count + 1;
sol_prev(sol_count).y = y;
sol_prev(sol_count).y.sumx = sum(y.var.val);