% ----------------------------------------------------------------------- % 
clc 
clear all 
close all 

%% Load the OFDM signal (at the secondary user side) 
load('rxOFDM_signal.mat'); 

%% Extract a specific sub-carrier to search the presence of the Primary User 

signal = rxOFDM_signal(2,:);  % 2 means that I am extracting the 2nd sub-carrier 
  

%% Calculate the energy of each OFDM symbol 

for i = 1:size(signal,2) 
    energy(1,i) = (abs(signal(1,i))).^2;  
end 
  
%% Compare with the threshold 

threshold = 1; 
for j = 1:size(energy,2) 
    if energy(1,j) >= threshold 
        PU(1,j) = 1; 
    else 
        PU(1,j) = 0; 
    end 
end 

%% Plot the signal and the output of the Energy Detector 

subplot(2,1,1); 
plot(real(signal)); 
title('received signal'); 
xlabel('OFDM symbols'); 
ylabel('Amplitude'); 
subplot(2,1,2) 
plot(PU, 'LineWidth',2); 
title('PU presence(1) / absence(0)'); 
xlabel('OFDM symbols'); 
% ----------------------------------------------------------------------- % 

 