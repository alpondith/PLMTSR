% ----------------------------------------------------------------------- % 
clc 
clear 
close all 

%% Functions 
function [Roc_f] = Roc_calculation(f,Ground_truth) %f is the signal, Ground_truth is the reference signal 

    save_TP_f = []; 
    save_FP_f = []; 
    condition_positive = sum(Ground_truth); 
    condition_negative = length(f) - condition_positive; 
    
    for i = 0:0.001:1 
        TP_f = 0; 
        FP_f = 0; 
        for j = 1 : length(f) 
            if f(j) > i 
                if Ground_truth(j) == 1 
                    TP_f = TP_f + 1; 
                else 
                    FP_f = FP_f + 1; 
                end 
            end 
        end 
        save_TP_f = [save_TP_f TP_f]; 
        save_FP_f = [save_FP_f FP_f]; 
    end 
    true_positive_f  = save_TP_f/condition_positive; 
    false_positive_f = save_FP_f/condition_negative; 
    Roc_f = [false_positive_f;true_positive_f]; 
end 


function [dataNorm] = normalize(energy_signal) 
    minEner = min(energy_signal(1, :)); 
    maxEner = max(energy_signal(1, :)); 
    dataNorm = (energy_signal(1, :)-minEner)./(maxEner-minEner); 
    
end 

%% Load the OFDM signal (at the secondary user side) 
load('rxOFDM_signal.mat'); 

%% Extract a specific sub-carrier to search the presence of the Primary User 

signal = rxOFDM_signal(6,:); 

%% Create the Ground Truth 

ground_truth = zeros(1, size(rxOFDM_signal,2)); 

threshold = 1; 
for i=1:size(signal,2) 
    if abs(signal(1,i)) >= threshold % if the amplitude of symbol i greater or equal to threshold -> the PU is present 
        ground_truth(1,i) = 1; % 1: PU is present /  0: PU is absent 
    end 
end 

  

%% Calculate the energy of each OFDM symbol 

for j=1:size(signal,2) 
    energy_signal(1,j) = (abs(signal(1,j))).^2; 
end 

%% Normalize the energy signal 

dataNorm = normalize(energy_signal); 

%% Calculate the ROC 

[Roc_f] = Roc_calculation(dataNorm, ground_truth); 

x = [0 1]; 
y = [1 0]; 
z = [0 1]; 
zz = [0 1]; 

figure; 
sm=0.8; 

plot(smooth(Roc_f(1,:),sm), smooth(Roc_f(2,:),sm), 'LineWidth',3); 
hold on; 
plot(x,y, '--', 'LineWidth',1.2); 
plot(z,zz,'--', 'LineWidth',1.2); 
title('ROC'); 
xlabel('Probability of False Alarm (Pfa)'); 
ylabel('Probability of Detection (Pd)'); 
grid on; 

% ----------------------------------------------------------------------- % 

 