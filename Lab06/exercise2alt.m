% Comparing the PDF of the real part of generated samples against the Gaussian PDF
[val, bin] = hist(h_re, 1000); % Compute histogram for real part
normalized_val = val / trapz(bin, val); % Normalize the PDF

figure;
plot(bin, normalized_val); % Plot normalized simulated PDF
hold on;
x = -2:0.1:2;
sigma_re = sqrt(var(h_re)); % Compute standard deviation dynamically
y = normpdf(x, 0, sigma_re); % Theoretical Gaussian PDF
plot(x, y, 'r');
title('Probability Density Function (Real Part)');
legend('Simulated PDF', 'Theoretical Gaussian PDF');

% Comparing the PDF of the overall response of the channel against the Rayleigh PDF
[val, bin] = hist(abs(h), 1000); % Compute histogram for magnitude
normalized_val = val / trapz(bin, val); % Normalize the PDF

figure;
plot(bin, normalized_val); % Plot normalized simulated PDF
hold on;
z = 0:0.1:3;
sigma_mag = sqrt(var(h_re)); % Use the same sigma for magnitude
y = (z/(sigma_mag^2)) .* exp(-z.^2 / (2 * sigma_mag^2)); % Theoretical Rayleigh PDF
plot(z, y, 'r');
title('Probability Density Function (Magnitude)');
legend('Simulated PDF', 'Theoretical Rayleigh PDF');