% THE NEURAL NETWORK %

%INPUT NEURAL (AND gate example== 2 inputs && 4 samples)
inputs = [0 0;0 1;1 0;1 1]';

% targets for the neural net
targets = [0;0;0;1]';

% JUMLAH NEURON
n = 4;

% BUAT NEURAL NETWORK
net = feedforwardnet(n);

% KONFIGURASIKAN NEURAL NETWORK DATASET
net = configure(net, inputs, targets);

% BOBOT NN NORMAL
getwb(net)

% ERROR MSE normal NN
error = targets - net(inputs);
calc = mean(error.^2)/mean(var(targets',1))

% create handle to the MSE_TEST function, YANG MENGHITUNG MSE
% 
h = @(x) NMSE(x, net, inputs, targets);

% PLEASE NOTE: For a feed-forward network
% dengan n neurons yang tak terlihat, 3n+n+1 quantities dibutuhkan
% dalam pembobotan dan pembiasan vektor kolom
% a. n for the input weights=(features*n)=2*n
% b. n for the input biases=(n bias)=n
% c. n for the output weights=(n weights)=n
% d. 1 for the output bias=(1 bias)=1

% jalankan pembelajaran dg algoritma optimasi
[x, err_ga] = tlbo(h, 2*n+n+n+1)
net = setwb(net, x');

% dapatkan TLBO optimasi dg bobot NN dan bias
getwb(net)

% error MSE TLBO optimized NN
error = targets - net(inputs);
calc = mean(error.^2)/mean(var(targets',1))
