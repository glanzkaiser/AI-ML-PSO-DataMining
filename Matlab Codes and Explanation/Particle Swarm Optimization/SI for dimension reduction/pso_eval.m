%-------------------------------------------------------------------------%
%         P A R T I C L E    S W A R M    O P T I M I Z A T I O N         %
%-------------------------------------------------------------------------%
function [z, xy_lim, n] = pso_eval(n_fun)

    % Error detection
    if(nargin < 1), error('Not enough input parameters'); end
    
    % Selection of the desired function
    switch(n_fun)
        case 1  % Paraboloid
            z = @(x,y) x.^2 + y.^2;
            xy_lim = [-2*pi,2*pi];
            n      = 200;
        case 2  % Griewank
            z = @(x,y) ((x.^2+y.^2)/4000)-(cos(x).*cos(y./sqrt(2)))+1;
            xy_lim = [-2*pi,2*pi];
            n      = 100;
        case 3  % Rastrigin
            z = @(x,y) (x.^2-10*cos(2*pi.*x))+(y.^2-10*cos(2*pi.*y))+20;
            xy_lim = [-2*pi,2*pi];
            n      = 150;
        case 4  % Rosenbrock
            z = @(x,y) 100*(y-x.^2).^2+(x-1).^2;
            xy_lim = [-2*pi,2*pi];
            n      = 100;
        case 5  % Bukin
            z = @(x,y) 100.*sqrt(abs(y-0.05.*x.^2))+0.01.*abs(x+10);
            xy_lim = [-pi,pi];
            n      = 100;
        case 6  % Log-sumcan
            z = @(x,y) 1+log10(1./(10.^(-5)+abs(x)+abs(x+y)));
            xy_lim = [-1,1];
            n      = 200;
        case 7  % Ackley
            z = @(x,y) 22 + exp(1) - 20*exp(-0.2*sqrt(x.^2+y.^2/2)) - exp(cos(2*pi*x)+cos(2*pi*y)/2);
            xy_lim = [-2*pi,2*pi];
            n      = 150;
        case 8  % Drop-Wave
            z = @(x,y) 1-((1+cos(12.*sqrt(x.^2+y.^2)))/(0.5.*(x.^2+y.^2)+2));
            xy_lim = [-pi,pi];
            n      = 150;
        case 9  % Holder-Table
            z = @(x,y) 20-abs(sin(x).*cos(y).*exp(abs(1-((sqrt(x.^2+y.^2))/pi))));
            xy_lim = [-10,10];
            n      = 150;
        case 10 % Levy
            z = @(x,y) sin(3*pi.*x).^2+((x-1).^2).*(1+sin(3*pi.*y).^2)+((y-1).^2).*(1+sin(2*pi.*y).^2);
            xy_lim = [-10,10];
            n      = 150;
        case 11 % Michalewicz
            z = @(x,y) 2+sin(x).*(sin((x.^2)/pi)).^20+sin(y).*(sin(2.*(y.^2)/pi)).^20;
            xy_lim = [-pi,pi];
            n      = 150;
        case 12 % Styblinski-Tang
            z = @(x,y) 40+0.5.*((x.^4-16.*x.^2+5.*x)+(y.^4-16.*y.^2-5.*y));
            xy_lim = [-5,5];
            n      = 150;
        otherwise
            errordlg('Selected function is not on the list.','Function error');
    end
end