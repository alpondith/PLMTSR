% filepath: /home/alpondith/projects/PLMTSR/Lab11/OFDM_MultiModulation.m
clc;
clear;
close all;

%% Setting Parameters
Subcarriers = 128;                % Total number of subcarriers
M1 = 16;                          % 16-QAM
M2 = 32;                          % 32-QAM
M3 = 64;                          % 64-QAM
M4 = 256;                         % 256-QAM
numOfSym = 21600;                 % Base number of OFDM symbols
numOfSym1 = numOfSym * 2;         % Symbols for 16-QAM
numOfSym2 = numOfSym * 2.5;       % Symbols for 32-QAM
numOfSym3 = numOfSym * 3;         % Symbols for 64-QAM
numOfSym4 = numOfSym * 4;         % Symbols for 256-QAM
GI = 1/4;                         % Guard Interval (Cyclic Prefix)
snrV = -20:2:30;                  % SNR values from -20dB to +30dB
fs = 3.84e6;                      % Sampling frequency (Hz)
pathDelays = [0 200 800 1200 2300 3700]*1e-9; % Path delays (sec)
avgPathGains = [0 -0.9 -4.9 -8 -7.8 -23.9];   % Average path gains (dB)
fD = 50;                          % Maximum Doppler shift (Hz)

% Initialize BER arrays
BER1 = zeros(1, length(snrV));
BER2 = zeros(1, length(snrV));
BER3 = zeros(1, length(snrV));
BER4 = zeros(1, length(snrV));
BER_AWGN1 = zeros(1, length(snrV));
BER_AWGN2 = zeros(1, length(snrV));
BER_AWGN3 = zeros(1, length(snrV));
BER_AWGN4 = zeros(1, length(snrV));

%% Generate Data for Each Modulation Scheme
TxData1 = randi([0, 1], Subcarriers, numOfSym1 * log2(M1));
TxData2 = randi([0, 1], Subcarriers, numOfSym2 * log2(M2));
TxData3 = randi([0, 1], Subcarriers, numOfSym3 * log2(M3));
TxData4 = randi([0, 1], Subcarriers, numOfSym4 * log2(M4));

% QAM Modulation
TxData_Modulated1 = qammod(TxData1', M1, 'InputType', 'bit');
TxData_Modulated2 = qammod(TxData2', M2, 'InputType', 'bit');
TxData_Modulated3 = qammod(TxData3', M3, 'InputType', 'bit');
TxData_Modulated4 = qammod(TxData4', M4, 'InputType', 'bit');

% Perform IFFT
TxData_IFFT1 = ifft(TxData_Modulated1');
TxData_IFFT2 = ifft(TxData_Modulated2');
TxData_IFFT3 = ifft(TxData_Modulated3');
TxData_IFFT4 = ifft(TxData_Modulated4');

% Add Cyclic Prefix
TxData_GI1 = [TxData_IFFT1((1-GI)*Subcarriers+1:end, :); TxData_IFFT1];
TxData_GI2 = [TxData_IFFT2((1-GI)*Subcarriers+1:end, :); TxData_IFFT2];
TxData_GI3 = [TxData_IFFT3((1-GI)*Subcarriers+1:end, :); TxData_IFFT3];
TxData_GI4 = [TxData_IFFT4((1-GI)*Subcarriers+1:end, :); TxData_IFFT4];

% Reshape for Rayleigh Channel
tx1 = reshape(TxData_GI1, [], 1);
tx2 = reshape(TxData_GI2, [], 1);
tx3 = reshape(TxData_GI3, [], 1);
tx4 = reshape(TxData_GI4, [], 1);

% Rayleigh Channel
rayleighchan = comm.RayleighChannel('SampleRate', fs, ...
    'PathDelays', pathDelays, ...
    'AveragePathGains', avgPathGains, ...
    'MaximumDopplerShift', fD);

%% Channel and Receiver
for i = 1:length(snrV)
    snr = snrV(i);
    
    % Rayleigh Channel
    faded_signal1 = rayleighchan(tx1);
    faded_signal2 = rayleighchan(tx2);
    faded_signal3 = rayleighchan(tx3);
    faded_signal4 = rayleighchan(tx4);
    
    % Add AWGN
    faded_signal_plus_noise1 = awgn(faded_signal1, snr, 'measured');
    faded_signal_plus_noise2 = awgn(faded_signal2, snr, 'measured');
    faded_signal_plus_noise3 = awgn(faded_signal3, snr, 'measured');
    faded_signal_plus_noise4 = awgn(faded_signal4, snr, 'measured');
    
    % Reshape for Receiver
    Recieve_Channel1 = reshape(faded_signal_plus_noise1, [], numOfSym1);
    Recieve_Channel2 = reshape(faded_signal_plus_noise2, [], numOfSym2);
    Recieve_Channel3 = reshape(faded_signal_plus_noise3, [], numOfSym3);
    Recieve_Channel4 = reshape(faded_signal_plus_noise4, [], numOfSym4);
    
    % AWGN Channel
    Receive_Channel_awgn1 = awgn(tx1, snr, 'measured');
    Receive_Channel_awgn2 = awgn(tx2, snr, 'measured');
    Receive_Channel_awgn3 = awgn(tx3, snr, 'measured');
    Receive_Channel_awgn4 = awgn(tx4, snr, 'measured');
    
    % Remove Cyclic Prefix
    Recieve_GIremoved1 = Recieve_Channel1(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    Recieve_GIremoved2 = Recieve_Channel2(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    Recieve_GIremoved3 = Recieve_Channel3(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    Recieve_GIremoved4 = Recieve_Channel4(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    
    % FFT
    RecieveData_FFT1 = fft(Recieve_GIremoved1);
    RecieveData_FFT2 = fft(Recieve_GIremoved2);
    RecieveData_FFT3 = fft(Recieve_GIremoved3);
    RecieveData_FFT4 = fft(Recieve_GIremoved4);
    
    % Demodulation
    RecieveData1 = qamdemod(RecieveData_FFT1', M1, 'OutputType', 'bit');
    RecieveData2 = qamdemod(RecieveData_FFT2', M2, 'OutputType', 'bit');
    RecieveData3 = qamdemod(RecieveData_FFT3', M3, 'OutputType', 'bit');
    RecieveData4 = qamdemod(RecieveData_FFT4', M4, 'OutputType', 'bit');
    
    % BER Calculation
    [ BER1(i)] = biterr(TxData1, RecieveData1');
    [ BER2(i)] = biterr(TxData2, RecieveData2');
    [ BER3(i)] = biterr(TxData3, RecieveData3');
    [ BER4(i)] = biterr(TxData4, RecieveData4');
end

%% Plot Results
figure;
semilogy(snrV, BER1, '-o', 'DisplayName', '16-QAM');
hold on;
semilogy(snrV, BER2, '-x', 'DisplayName', '32-QAM');
semilogy(snrV, BER3, '-s', 'DisplayName', '64-QAM');
semilogy(snrV, BER4, '-d', 'DisplayName', '256-QAM');
grid on;
xlabel('SNR [dB]');
ylabel('BER');
title('BER vs. SNR for Different Modulation Schemes');
legend('Location', 'southwest');