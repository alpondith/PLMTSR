% Plot the functions x0(t)= t exp(-|t|), xe(t)= t exp(-|t|), and x(t)= 0.5 ( x0(t) +xe(t) ) 
% For -10<=t<=10 with a step size of 0.1

% t is the time variable, sampled from -10 to 10 with a step size of 0.1
t = -10:0.1:10;

% x0 is the function t * exp(-|t|) evaluated at each t
x0 = t.*exp(-abs(t));

% xe is the function |t| * exp(-|t|) evaluated at each t
xe = abs(t).*exp(-abs(t));

% x is the average of x0 and xe
x = 0.5*(x0 + xe);

% Plot x0, xe, and x
plot(t, x0, t, xe, t, x);
