% Print a triangle of asterisks
%
% * 
% * * 
% * * *

% Set the number of rows in the triangle
n = 3;
% Loop through each row
for row = 1:n
    % Loop through each column
    for column = 1:row
        % Print an asterisk
        fprintf('* ');
    end
    % Move to the next line
    fprintf('\n');
end
