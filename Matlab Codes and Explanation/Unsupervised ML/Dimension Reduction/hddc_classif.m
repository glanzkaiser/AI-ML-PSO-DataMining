function [cls,P] = hdda_classif2_faster(prms,Y,varargin);
% High Dimensionality Reduction Analysis (classification)
%
% Input: 
%       - prms: kelas parameter
%       - Y: data utk klasifikasi
%
% Output:
%       - cls: label test data Y.data,
%       - P: a posteriori probabilitas
%
% Initialization %%
if isstruct(Y), 
	data = Y.data; 
	if isfield(Y,'cls'), 
        class = Y.cls; 
    else class = [];
    end
else data = Y; class = []; 
end

[nt,pt] = size(data);
model = prms.model;
k = prms.k; p = prms.p;
a = prms.a; b = prms.b;
d = prms.d; prop = prms.prop; 
m = prms.m; Q = prms.Q; 

% Fungsi harga%%
for i=1:k
    % proyeksi of test data ke eigenspace Ei
    Pa = ((data - repmat(m(i,:),nt,1)) * Q{i}) * Q{i}';
    Pb = Pa + repmat(m(i,:),nt,1) - data;

    % komputasi fungsi harga K_i(x)
    switch model
        case {'AijBiQiDi','AijBiQiD','AijBQiDi','AijBQiD','AjBiQiD','AjBQiD','AjBQD'}
            ai = a(1:d(i),i)';
            K(:,i) = diag(Pa * Q{i} * diag(1./ai) * Q{i}' * Pa') ...
                + (1/b(i) * sum(Pb.^2,2)) + sum(log(ai)) ...
                + (p-d(i)) * log(b(i)) - 2 * log(prop(i)) + p * log(2*pi);

        otherwise
            K(:,i) = 1/a(i) * sum(Pa.^2,2) + (1/b(i) * sum(Pb.^2,2)) + d(i) * log(a(i)) ...
                + (p-d(i)) * log(b(i)) - 2 * log(prop(i)) + p * log(2*pi);
    end
end

% a posteriori rprobabilitas %%%%
P = exp(-0.5*K) ./ repmat(sum(exp(-0.5*K),2),1,k);

if length(find(isnan(P)))~=0 | length(find(isinf(P)))~=0
  fprintf('--> overflow switching to O(k*k) mode\n');
  clear P;
  eksp = zeros(nt,k);
  for i=1:k
    for l=1:k
      eksps(:,l) = exp(0.5*(K(:,i) - K(:,l)));
    end
    P(:,i) = 1./sum(eksps,2);
  end
end

%Klasifikasi%
[val,cls] = max(P,[],2);

% Hasil Klasifikasi %%%
if ~isempty(class),
	tx = sum(cls == class) / length(cls);
	fprintf('-->  rate klasifikasi yang benar: %g \n',tx);
end 