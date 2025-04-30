% filepath: /home/alpondith/projects/PLMTSR/Lab09/task01_multiple_threshold.m
% ----------------------------------------------------------------------- % 
clc 
clear all 
close all 

%% Load the OFDM signal (at the secondary user side) 
load('rxOFDM_signal.mat'); 

%% Define an array of subcarriers and thresholds
subcarriers = [1, 2, 3, 4, 5, 6]; % Subcarriers to analyze
thresholds = [0.1, 0.5, 1, 2, 5, 10]; % Threshold values

%% Loop through each subcarrier
for s = 1:length(subcarriers)
    subcarrier_index = subcarriers(s);
    signal = rxOFDM_signal(subcarrier_index, :); % Extract the subcarrier

    %% Calculate the energy of each OFDM symbol
    for i = 1:size(signal, 2)
        energy(1, i) = (abs(signal(1, i))).^2;
    end

    %% Loop through each threshold and plot the results
    figure('Name', ['Subcarrier ', num2str(subcarrier_index)]);
    for t = 1:length(thresholds)
        threshold = thresholds(t);

        % Compare with the threshold
        for j = 1:size(energy, 2)
            if energy(1, j) >= threshold
                PU(1, j) = 1;
            else
                PU(1, j) = 0;
            end
        end

        % Plot the signal and the output of the Energy Detector
        subplot(length(thresholds), 2, 2*t-1);
        plot(real(signal));
        title(['Received Signal (Threshold = ', num2str(threshold), ')']);
        xlabel('OFDM symbols');
        ylabel('Amplitude');

        subplot(length(thresholds), 2, 2*t);
        plot(PU, 'LineWidth', 2);
        title(['PU Presence (1) / Absence (0) (Threshold = ', num2str(threshold), ')']);
        xlabel('OFDM symbols');
    end
end
% ----------------------------------------------------------------------- %