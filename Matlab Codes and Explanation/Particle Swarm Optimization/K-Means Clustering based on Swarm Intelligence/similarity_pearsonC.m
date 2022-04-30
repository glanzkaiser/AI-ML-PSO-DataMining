function R = similarity_pearsonC(data, C)
[nrow,ncol] = size(data);
dm = mean(data);
data = data-repmat(dm,nrow,1);
C = C-mean(C);
R = ones(1,ncol);

 X = sqrt(C'*C);
 for j = 1:ncol
   y = data(:,j);
   xy = C'*y;
   Y = sqrt(y'*y);
   S = X*Y;
  % if S == 0      S = NaN;   end
   R(j) = xy/S;
 end

% Pearson similarity [-1,1] is normalized to Pearson distance [0,1]
R = 1-(1+R)*0.5;