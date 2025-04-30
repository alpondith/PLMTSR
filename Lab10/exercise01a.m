% Configuration Parameters

%% Setting Parameters
Subcarriers = 64;                            % total number of subcarrier (IFFT length equal to Subcarriers)
M = 16;                                      % number of constellations
k = log2(M);                                 % number of bits per constellation
numOfSym = 10^3;                             % number of OFDM Symbols
GI = 1/4;                                    % Guard Interval or Cyclic Prefix, normaly 25 of the entire OFDM symbols
snr = 15;                                    % Signal to noise ratio in dB


%% --------------------- TRANSMITER --------------------------------------
%%------------------------------------------------------------------------
%% Generate Data to be modulated on the subcarriers
TxData = randi([0,M-1], Subcarriers, numOfSym);                             
 
%% Implement QAM modulation
TxData_Modulated = qammod(TxData,M);
 
%% Perform IFFT
TxData_IFFT = ifft(TxData_Modulated);
 
%% Adding cyclic Prefix
TxData_GI = [TxData_IFFT((1-GI)*...
    Subcarriers+1:end,:);TxData_IFFT];
 
%% Plotting OFDM signal in time domain 
[row , col] = size(TxData_GI);
len = row*col;
ofdm_signal = reshape(TxData_GI, 1, len);
figure(1);
plot(real(ofdm_signal)); 
xlabel('Time'); 
ylabel('Amplitude');
title('OFDM Signal');
grid on;

%% Channel

rx_signal = awgn(TxData_GI ,snr,'measured');


%% --------------------- RECEIVER ----------------------------------------
%%------------------------------------------------------------------------

%% CP  removal
Recieve_GIremoved  =  rx_signal(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :); 
 
%% FFT operation
RecieveData_FFT = fft(Recieve_GIremoved);
Signal_Magnitude = real(RecieveData_FFT);
Signal_Phase = imag(RecieveData_FFT);
 
%% plot the received constellations for a specific subcarrier
n = 4; % selected subcarrier
scatterplot(RecieveData_FFT(n,:));
title('FFT Output 16-QAM');
 
%% Demodulation
RecieveData = qamdemod(RecieveData_FFT,M);
 
%% Number of Bit Errors and Bit Error Rate computation
[num , BER] = biterr(TxData, RecieveData);



