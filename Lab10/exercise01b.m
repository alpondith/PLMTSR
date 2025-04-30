% filepath: /home/alpondith/projects/PLMTSR/Lab10/exercise01.m
% Configuration Parameters

%% Setting Parameters
Subcarriers = 64;                            % total number of subcarrier (IFFT length equal to Subcarriers)
M = 16;                                      % number of constellations
k = log2(M);                                 % number of bits per constellation
numOfSym = 10^3;                             % number of OFDM Symbols
GI = 1/4;                                    % Guard Interval or Cyclic Prefix, normally 25% of the entire OFDM symbols
snrVec = -20:2:20;                           % SNR values from -20dB to +20dB
ber = zeros(1, length(snrVec));              % Initialize BER array
ber_theo = zeros(1, length(snrVec));         % Initialize theoretical BER array

%% --------------------- TRANSMITTER --------------------------------------
%%------------------------------------------------------------------------
%% Generate Data to be modulated on the subcarriers
TxData = randi([0, M-1], Subcarriers, numOfSym);                             
 
%% Implement QAM modulation
TxData_Modulated = qammod(TxData, M);
 
%% Perform IFFT
TxData_IFFT = ifft(TxData_Modulated);
 
%% Adding cyclic Prefix
TxData_GI = [TxData_IFFT((1-GI)*Subcarriers+1:end, :); TxData_IFFT];
 
%% Plotting OFDM signal in time domain 
[row, col] = size(TxData_GI);
len = row * col;
ofdm_signal = reshape(TxData_GI, 1, len);
figure(1);
plot(real(ofdm_signal)); 
xlabel('Time'); 
ylabel('Amplitude');
title('OFDM Signal');
grid on;

%% --------------------- SIMULATION FOR DIFFERENT SNR VALUES --------------
for i = 1:length(snrVec)
    snr = snrVec(i); % Current SNR value
    
    %% Channel: Add AWGN noise
    rx_signal = awgn(TxData_GI, snr, 'measured');
    
    %% --------------------- RECEIVER ----------------------------------------
    %% CP removal
    Recieve_GIremoved = rx_signal(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :); 

    %% FFT operation
    RecieveData_FFT = fft(Recieve_GIremoved);

    %% Demodulation
    RecieveData = qamdemod(RecieveData_FFT, M);

    %% Number of Bit Errors and Bit Error Rate computation
    [~, BER] = biterr(TxData, RecieveData);
    ber(i) = BER; % Store simulated BER for current SNR

    %% Theoretical BER calculation
    EbNoVec = snr - 10*log10(k); % Convert SNR to Eb/No
    ber_theo(i) = berawgn(EbNoVec, 'qam', M); % Theoretical BER
end

%% --------------------- PLOT BER RESULTS ---------------------------------
figure 
semilogy(snrVec, ber,'-ok', snrVec, ber_theo); 
grid; 
ylabel('BER'); 
xlabel('SNR [dB]'); 
legend('AWGN-simulation', 'AWGN-theoretical'); 