function net = som(nin, map_size)
net.type = 'som';
net.nin = nin;

% Create Map of nodes
if round(map_size) ~= map_size | (map_size < 1)
    error('SOM specification must contain positive integers');
end

net.map_dim = length(map_size);
if net.map_dim ~= 2
    error('SOM is a 2 dimensional map');
end
net.num_nodes = prod(map_size);
% Centres are stored by column as first index of multi-dimensional array.
% This makes extracting them later more easy.
% Initialise with rand to create square grid
net.map = rand([nin, map_size]);
net.map_size = map_size;

% Crude function to compute inter-node distances
net.inode_dist = zeros([map_size, net.num_nodes]);
for m = 1:net.num_nodes
    node_loc = [1+fix((m-1)/map_size(2)), 1+rem((m-1),map_size(2))];
    for k = 1:map_size(1)
	for l = 1:map_size(2)
	    net.inode_dist(k, l, m) = round(max(abs([k l] - node_loc)));
	end
    end
end
