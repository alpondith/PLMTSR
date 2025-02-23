%  the column arrays
a = [1; 2; 3];
b = [4; 5; 6];
%  the row arrays
c = [7, 8, 9];

% Transpose of array 'a'
transpose_a = a';

% Matrix multiplication of 'a' and 'b'
matrix_multiplication = a * c ;

% Dot product of 'a' and 'b'
dot_product = a' * b;

% Element-wise multiplication of 'a' and 'b'
elementwise_multiplication_ab = a .* b ;

% Element-wise multiplication of scalar 3 with each element of 'b'
elementwise_multiplication_3b = 3 .* b ;


% What do each of these three operators ('  *  .*) do ?
% ' ç ' is the transpose operator
% * : matrix multiplication
% .* : element-wise multiplication
