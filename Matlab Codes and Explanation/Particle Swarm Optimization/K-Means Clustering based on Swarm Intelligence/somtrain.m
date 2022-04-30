function net = somtrain(net, options, x)
if (~options(14))
    options(14) = 100;
end
niters = options(14);

% Learning rate must be positive
if (options(18) > 0)
    alpha_first = options(18);
else
    alpha_first = 0.9;
end
% Final learning rate must be no greater than initial learning rate
if (options(16) > alpha_first | options(16) < 0)
    alpha_last = alpha_first;
else
    alpha_last = options(16);
end

% Neighbourhood size
if (options(17) >= 0)
    nsize_first = options(17);
else
    nsize_first = max(net.map_dim)/2;
end
% Final neighbourhood size must be no greater than initial size
if (options(15) > nsize_first | options(15) < 0)
    nsize_last = nsize_first;
else
    nsize_last = options(15);
end

[ndata, dim] = size(x);

if options(6)
    % Batch algorithm
    H = zeros(ndata, net.num_nodes);
end
% Put weights into matrix form
tempw = (reshape(net.map, net.nin, net.num_nodes))';

% Then carry out training
j = 1;
while j <= niters
    if options(6)
	% Batch version of algorithm
	alpha = 0.0;
	frac_done = (niters - j)/niters;
	% Compute neighbourhood
	nsize = round((nsize_first - nsize_last)*frac_done + nsize_last);
	
	% Find winning node: put weights back into net so that we can
	% call somunpak
	net.map = reshape(tempw', [net.nin net.map_size]);
	[temp, bnode] = somfwd(net, x);
	for k = 1:ndata
	    H(k, :) = reshape(net.inode_dist(:, :, bnode(k))<=nsize, ...
		1, net.num_nodes);
	end
	s = sum(H, 1);
	for k = 1:net.num_nodes
	    if s(k) > 0
		tempw(k, :) = sum((H(:, k)*ones(1, net.nin)).*x, 1)/s(k);
	    end
	end
    else
	% On-line version of algorithm
	if options(5)
	    % Randomise order of pattern presentation: with replacement
	    pnum = ceil(rand(ndata, 1).*ndata);
	else
	    pnum = 1:ndata;
	end
	% Cycle through dataset
	for k = 1:ndata
	    % Fraction done
	    frac_done = (((niters+1)*ndata)-(j*ndata + k))/((niters+1)*ndata);
	    % Compute learning rate
	    alpha = (alpha_first - alpha_last)*frac_done + alpha_last;
	    % Compute neighbourhood
	    nsize = round((nsize_first - nsize_last)*frac_done + nsize_last);
	    % Find best node
	    pat_diff = ones(net.num_nodes, 1)*x(pnum(k), :) - tempw;
	    [temp, bnode] = min(sum(abs(pat_diff), 2));
        %R = similarity_pearsonC(tempw', x(pnum(k), :)'); 
	    %[temp, bnode] = min(R); <==no need to adjust !
	    %tempw = tempw + ((alpha*(neighbourhood(:)))*ones(1, net.nin)).*repmat(R',1,dim);
        
	    % Now update neighbourhood
	    neighbourhood = (net.inode_dist(:, :, bnode) <= nsize);
	    tempw = tempw + ((alpha*(neighbourhood(:)))* ...
            ones(1, net.nin)).*pat_diff;
	end
    end
    if options(1)
	% Print iteration information
	fprintf(1, 'Iteration %d; alpha = %f, nsize = %f. ', j, alpha, ...
	nsize);
	% Print sum squared error to nearest node
	d2 = dist2(tempw, x);
	fprintf(1, 'Error = %f\n', sum(min(d2)));
    end
    j = j + 1;
end

net.map = reshape(tempw', [net.nin net.map_size]);
%options(8) = sum(min(dist2(tempw, x)));

function [d2, win_nodes] = somfwd(net, x)
% Turn nodes into matrix of centres
nodes = (reshape(net.map, net.nin, net.num_nodes))';
d2 = dist2(x, nodes);    % Compute squared distance matrix
[w, win_nodes] = min(d2, [], 2);  % winning node for each pattern

function n2 = dist2(x, c)
[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end
n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ones(ndata, 1) ...
    * sum((c.^2)',1) - 2.*(x*(c'));
% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end
