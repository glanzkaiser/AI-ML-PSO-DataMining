function [final_x, final_y] = randsrch(fcn, x, bound, max_eval_n, max_tran_n)
%RANDSRCH Random search method for minimizing a function.
%	[X, Y] = RANDSRCH(FCN, INIT_X, BOUND, MAX_EVAL_N, MAX_TRAN_N)
%	FCN: a string specifying the function to be minimized.
%	INIT_X: starting point of the randomized search.
%	BOUND: a two-column array specifying the bounds of input variables.
%	MAX_EVAL_N: max. number of function evaluation (50 by default). 
%	MAX_TRAN_N: max. number of actual parameter changes (20 by default). 
%
%	(For simplicity, INIT_X and X are assumed to be column vectors.)

% Roger Jang, March 24, 1997

if nargin < 2, error('RANDSRCH needs at least two inputs!'); end
if nargin < 3, bound = ones(length(x), 1)*[-inf inf]; end
if nargin < 4, max_eval_n = 50;	end
if nargin < 5, max_tran_n = 20;	end

eval_n = 0;
tran_n = 0;

x = x(:);

% initialization;
y = feval(fcn, x); eval_n = eval_n + 1;
bias = zeros(size(x));
%fprintf('y = %g\n', y);

while (eval_n < max_eval_n) & (tran_n < max_tran_n),
	if any(any(isinf(bound))),
		dx = randn(size(x))/25; % Assuming the bound is [-1, 1]
	else
		dx = randn(size(x)).*(bound(:,1)-bound(:,2))/50;
	end
	new_x = x + bias + dx; 
	% find a in-bound new_x
	while ~all(((new_x-bound(:,1))>=0).*((bound(:,2)-new_x)>=0)),
		if any(any(isinf(bound))),
			dx = randn(size(x))/25; % Assuming the bound is [-1, 1]
		else
			dx = randn(size(x)).*(bound(:,1)-bound(:,2))/50;
		end
		new_x = x + bias + dx; 
	end
	new_y = feval(fcn, new_x); eval_n = eval_n + 1;
	if new_y < y,
		x = new_x; tran_n = tran_n + 1;
		y = new_y;
		bias = 0.2*bias + 0.4*dx;
		%fprintf('y = %g\n', y);
	else
		new_x = x + bias - dx; 
		% check if new_x is in-bound
		if all(((new_x-bound(:,1))>=0).*((bound(:,2)-new_x)>=0)),
			new_y = feval(fcn, new_x); eval_n = eval_n + 1;
			if new_y < y,
				x = new_x; tran_n = tran_n + 1;
				y = new_y;
				bias = bias - 0.4*dx;
				%fprintf('y = %g\n', y);
			else
				bias = 0.5*bias;
			end
		end
	end
end
final_x = x;
final_y = y;
fprintf('No. of evaluations = %g, no. of transitions = %g\n', eval_n, tran_n);
