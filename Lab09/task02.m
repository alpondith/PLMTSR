% Energy_Detector_ROC.m
clc;
clear;
close all;

%% Load the OFDM signal (at the secondary user side)
load('rxOFDM_signal.mat');

%% Extract a specific sub-carrier to search the presence of the Primary User
subcarrier_index = 6; % Change subcarrier index here
signal = rxOFDM_signal(subcarrier_index, :);

%% Create the Ground Truth
threshold_values = [0.9, 0.7, 0.5, 0.3, 0.1]; % Threshold values to test
colors = ['r', 'g', 'b', 'm', 'c']; % Colors for plotting

% Initialize figures for combined plots
figure(1); % Ground Truth for All Thresholds
hold on;
legend_entries = {};

figure(2); % ROC Curves for All Thresholds
hold on;
legend_entries_roc = {};

figure(3); % Normalized Energy Signal
hold on;
legend_entries_energy = {};

for t_idx = 1:length(threshold_values)
    threshold = threshold_values(t_idx);
    ground_truth = zeros(1, size(rxOFDM_signal, 2));

    for i = 1:size(signal, 2)
        if abs(signal(1, i)) >= threshold % if amplitude >= threshold -> PU is present
            ground_truth(1, i) = 1; % 1: PU is present / 0: PU is absent
        end
    end

    %% Calculate the energy of each OFDM symbol
    energy_signal = (abs(signal)).^2;

    %% Normalize the energy signal
    dataNorm = normalize(energy_signal);

    %% Plot the ground truth in a single figure
    figure(1);
    plot(ground_truth, colors(t_idx), 'LineWidth', 1.5);
    legend_entries{end+1} = ['Threshold = ', num2str(threshold)];

    %% Plot the normalized energy signal in Figure 3
    figure(3);
    plot(dataNorm, colors(t_idx), 'LineWidth', 1.5);
    legend_entries_energy{end+1} = ['Threshold = ', num2str(threshold)];

    %% Calculate the ROC
    [Roc_f] = Roc_calculation(dataNorm, ground_truth);

    %% Plot the ROC in a single figure
    figure(2);
    sm = 0.8;
    plot(smooth(Roc_f(1, :), sm), smooth(Roc_f(2, :), sm), 'LineWidth', 1.5, 'Color', colors(t_idx));
    legend_entries_roc{end+1} = ['Threshold = ', num2str(threshold)];
end

%% Finalize Ground Truth Plot
figure(1);
title('Ground Truth for Different Thresholds');
xlabel('Sample Index');
ylabel('Ground Truth');
legend(legend_entries, 'Location', 'best');
grid on;

%% Finalize ROC Plot
figure(2);
title('ROC Curves for Different Thresholds');
xlabel('Probability of False Alarm (Pfa)');
ylabel('Probability of Detection (Pd)');
legend(legend_entries_roc, 'Location', 'best');
grid on;

%% Finalize Normalized Energy Signal Plot
figure(3);
title('Normalized Energy Signal for Different Thresholds');
xlabel('Sample Index');
ylabel('Normalized Energy');
legend(legend_entries_energy, 'Location', 'best');
grid on;

%% Functions
function [Roc_f] = Roc_calculation(f, Ground_truth)
    save_TP_f = [];
    save_FP_f = [];
    condition_positive = sum(Ground_truth);
    condition_negative = length(f) - condition_positive;

    for i = 0:0.001:1
        TP_f = 0;
        FP_f = 0;
        for j = 1:length(f)
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
    true_positive_f = save_TP_f / condition_positive;
    false_positive_f = save_FP_f / condition_negative;
    Roc_f = [false_positive_f; true_positive_f];
end

function [dataNorm] = normalize(energy_signal)
    minEner = min(energy_signal);
    maxEner = max(energy_signal);
    dataNorm = (energy_signal - minEner) / (maxEner - minEner);
end