clc;
clear;
close all;

%% Parameters
Subcarriers = 64;                % Total number of subcarriers
numOfSym = 10^4;                 % Number of OFDM symbols
GI = 1/4;                        % Guard Interval (Cyclic Prefix)
snrVec = -20:2:20;               % SNR values from -20dB to +20dB
ber = zeros(4, length(snrVec));  % BER for 4 users
ber_theo = zeros(4, length(snrVec)); % Theoretical BER for 4 users

% Modulation schemes for each user
modulation_orders = [4, 16, 64, 256]; % 4-QAM, 16-QAM, 64-QAM, 256-QAM
k = log2(modulation_orders);          % Bits per symbol for each modulation

% Subcarrier allocation for each user
user_subcarriers = {
    1:16,   % User 1
    17:32,  % User 2
    33:48,  % User 3
    49:64   % User 4
};

%% Generate Data for Each User
TxData = cell(1, 4);
for user = 1:4
    TxData{user} = randi([0, modulation_orders(user)-1], length(user_subcarriers{user}), numOfSym);
end

%% Transmitter
TxData_Modulated = cell(1, 4);
for user = 1:4
    TxData_Modulated{user} = qammod(TxData{user}, modulation_orders(user), 'UnitAveragePower', true);
end

% Combine all users' data into 64 subcarriers
TxData_Combined = zeros(Subcarriers, numOfSym);
for user = 1:4
    TxData_Combined(user_subcarriers{user}, :) = TxData_Modulated{user};
end

% Perform IFFT
TxData_IFFT = ifft(TxData_Combined);

% Add Cyclic Prefix
TxData_GI = [TxData_IFFT((1-GI)*Subcarriers+1:end, :); TxData_IFFT];

%% Channel and Receiver
for i = 1:length(snrVec)
    snr = snrVec(i); % Current SNR value
    
    % Add AWGN noise
    rx_signal = awgn(TxData_GI, snr, 'measured');
    
    % Remove Cyclic Prefix
    Recieve_GIremoved = rx_signal(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    
    % Perform FFT
    RecieveData_FFT = fft(Recieve_GIremoved);
    
    % Demodulate and calculate BER for each user
    for user = 1:4
        RecieveData_User = RecieveData_FFT(user_subcarriers{user}, :);
        RecieveData_Demod = qamdemod(RecieveData_User, modulation_orders(user), 'UnitAveragePower', true);
        
        % Calculate BER
        [~, BER] = biterr(TxData{user}, RecieveData_Demod);
        ber(user, i) = BER;
        
        % Calculate Theoretical BER
        EbNoVec = snr - 10*log10(k(user)); % Convert SNR to Eb/No
        ber_theo(user, i) = berawgn(EbNoVec, 'qam', modulation_orders(user));
    end
end

%% Plot BER Curves for Each User
figure;
for user = 1:4
    semilogy(snrVec, ber(user, :), '-o', 'DisplayName', ['User ', num2str(user), ' (Simulated)']);
    hold on;
    semilogy(snrVec, ber_theo(user, :), '--', 'DisplayName', ['User ', num2str(user), ' (Theoretical)']);
end
grid on;
xlabel('SNR [dB]');
ylabel('BER');
title('BER vs. SNR for Different Users');
legend('Location', 'southwest');

%% Compare Users in Terms of BER
figure;
for user = 1:4
    semilogy(snrVec, ber(user, :), '-o', 'DisplayName', ['User ', num2str(user)]);
    hold on;
end
grid on;
xlabel('SNR [dB]');
ylabel('BER');
title('Comparison of BER for Different Users');
legend('Location', 'southwest');