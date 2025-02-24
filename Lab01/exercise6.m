% A 3x5 matrix of random variables
A = rand(3,5);

% Find minimum and maximum values in each column
column_min = min(A);
column_max = max(A);

% Initialize row_min and row_max with zeros
% row min: [0 0 0]
% row max: [0 0 0]
row_min = zeros(1,size(A,1));
row_max = zeros(1,size(A,1));

% Find minimum and maximum values in each row
for row = 1:size(A, 1)
    row_min(row) = min(A(row , :));
    row_max(row) = max(A(row , :));
end

% Find minimum and maximum values in the entire matrix
matrix_min = min(column_min);
matrix_max = max(column_max);

% Display the results
disp(A);
fprintf('Min in each column: [%s] \n', num2str(column_min, '%.4f '));
fprintf('Max in each column: [%s] \n', num2str(column_max, '%.4f '));
fprintf('Min in each row: [%s] \n', num2str(row_min, '%.4f '));
fprintf('Max in each row: [%s] \n', num2str(row_max, '%.4f '));
fprintf('Min in the matrix: %.4f \n', matrix_min);
fprintf('Max in the matrix: %.4f \n', matrix_max);
