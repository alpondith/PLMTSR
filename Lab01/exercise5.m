% Generate a vector of random floating numbers between 0 and 1
x = rand(1,10);

% functions myMin which returns the minimum value and its index
function [minimum, index_min] = myMin(x)
    minimum = x(1);
    index_min = 1;
    for i = 2:length(x)
        if x(i) < minimum
            minimum = x(i);
            index_min = i;
        end
    end
end

% function myMax which returns the maximum value and its index
function [maximum, index_max] = myMax(x)
    maximum = x(1);
    index_max = 1;
    for i = 2:length(x)
        if x(i) > maximum
            maximum = x(i);
            index_max = i;
        end
    end
end

% Find the maximum and minimum values and the corresponding indexes
[minimum, index_min] = myMin(x);
[maximum, index_max] = myMax(x);

% Display the results
fprintf('Minimum value: %f at index %d\n', minimum, index_min);
fprintf('Maximum value: %f at index %d\n', maximum, index_max);
