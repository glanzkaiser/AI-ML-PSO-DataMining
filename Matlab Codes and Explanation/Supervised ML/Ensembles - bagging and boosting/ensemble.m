% Ensemble Average
%
K = 50;
m = 0:K-1;
s = 2*m.*(0.9.^m); % Generate the uncorrupted signal
d = rand(K,1)-0.5; % Generate the random noise
x1 = s+d';
figure(), subplot(221), stem(m,s);
xlabel('Index waktu n');ylabel('Amplitude'); title('Uncorrupted data');
subplot(222),stem(m,d);
xlabel('Index waktu n');ylabel('Amplitude'); title('Noise');
subplot(223),stem(m,x1);
xlabel('Index waktu n');ylabel('Amplitude'); title('Noise corrupted data');
x = zeros(K,length(s));
x(1,:) = x1;
for n = 2:K
    d = rand(K,1)-0.5;
    x(n,:) = s + d';
end
x2 = sum(x)/K;
subplot(224),stem(m,x2);
xlabel('Time index n');ylabel('Amplitude'); title('Ensemble average');
Rel_err = norm(x2)/norm(x); % Bagaimana bisa menghapus noise