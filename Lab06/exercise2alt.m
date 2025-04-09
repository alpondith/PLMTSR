clc; clear;

M = 15; % Number of multipaths
N = 10^5; % Number of samples to generate
fd = 100; % Maximum Doppler spread in Hertz
Ts = 0.0001; % Sampling period in seconds

% Generate Rayleigh fading samples
h = rayleighFading(M, N, fd, Ts);

h_re = real(h);
h_im = imag(h);

% Plot real and imaginary parts of the impulse response
figure;
subplot(2,1,1);
plot([0:N-1]*Ts, h_re);
title('Real part of impulse response of the Flat Fading channel');
xlabel('Time (s)'); ylabel('Amplitude |h(t)|');

subplot(2,1,2);
plot([0:N-1]*Ts, h_im);
title('Imaginary part of impulse response of the Flat Fading channel');
xlabel('Time (s)'); ylabel('Amplitude |h(t)|');

% Plot amplitude and phase responses
figure;
subplot(2,1,1);
plot([0:N-1]*Ts, 10*log10(abs(h)));
title('Amplitude Response of the Flat Fading Channel');
xlabel('Time (s)'); ylabel('Magnitude |h(t)|');

subplot(2,1,2);
plot([0:N-1]*Ts, angle(h));
title('Phase Response of the Flat Fading Channel');
xlabel('Time (s)'); ylabel('Phase angle (h(t))');

% Statistical properties
mean_re = mean(h_re);
mean_im = mean(h_im);
var_re = var(h_re);
var_im = var(h_im);

% Comparing the PDF of the real part of generated samples against the Gaussian PDF
[val, bin] = hist(h_re, 1000); % Compute histogram for real part

figure;
plot(bin, val/trapz(bin, val)); % Normalize the PDF to match the theoretical result
hold on;
x = -2:0.1:2;
y = normpdf(x, 0, sqrt(0.5)); % Theoretical Gaussian PDF
plot(x, y, 'r');
title('Probability Density Function');
legend('Simulated PDF', 'Theoretical Gaussian PDF');

% Comparing the PDF of the overall response of the channel against the Rayleigh PDF
[val, bin] = hist(abs(h), 1000); % Compute histogram for magnitude

figure;
plot(bin, val/trapz(bin, val)); % Normalize the PDF to match the theoretical result
hold on;
z = 0:0.1:3;
sigma = 1;
y = (z/(sigma^2)) .* exp(-z.^2 / (2 * sigma^2)); % Theoretical Rayleigh PDF
plot(z, y, 'r');
title('Probability Density Function');
legend('Simulated PDF', 'Theoretical Rayleigh PDF');

% ==========================
% Function to Generate Rayleigh Fading
% ==========================
function [h] = rayleighFading (M,N, fd,Ts)
a = 0;
b = 2*pi; 

alpha = a+(b-a) *rand (1,M); %uniformly distributed from 0 to 2 pi
beta = a+ (b-a) *rand(1,M); %uniformly distributed from 0 to 2 pi 
theta = a+(b-a)*rand(1,M); %uniformly distributed from 0 to 2 pi

m = 1:M;
for n = 1:N
    x = cos(((2.*m-1)*pi+theta)/(4*M));
    h_re(n) = 1/sqrt(M) *sum(cos(2*pi*fd*x*n'*Ts+alpha)); h_im(n) = 1/sqrt(M)*sum(sin(2*pi*fd*x*n'*Ts+beta));
    
end

h = h_re + 1j*h_im;

end


