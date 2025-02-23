
% Equations to solve
% 3x1-3x2+6x3-2x4+x5=14
% 3x1-6x2+x3-x4+x5=25
% 2x1-4x2+4x3-4x4+3x5=5
% 3x1-6x2+5x3-x4+2x5=30
% 2x1-4x2+9x3+x4+x5=30

% matrix of coefficients
A = [3, -3, 6, -2, 1; 
     3, -6, 1, -1, 1; 
     2, -4, 4, -4, 3; 
     3, -6, 5, -1, 2; 
     2, -4, 9, 1, 1];

% right hand side of the equations
b = [14; 25; 5; 30; 30];

% solution of the system
x = A^(-1) * b;

disp(x);
