clc
close all
clear all
 
%% Setting Parameters
Subcarriers = 64;                                                           % total number of subcarrier (IFFT length equal to Subcarriers)
M = 16;                                                                     % number of constellations
k = log2(M);                                                                % number of bits per constellation
numOfSym = 10^4;                                                            % number of OFDM Symbols
GI = 1/4;                                                                   % Guard Interval or Cyclic Prefix, normaly 25 of the entire OFDM symbols
snrV = -20:2:20;                                                                   % Signal to noise ratio in dB
variance = 0.5;                                                             % variance of the rayleigh distribution



%% --------------------- TRANSMITER --------------------------------------
%%------------------------------------------------------------------------
%% Generate Data to be modulated on the subcarriers
TxData = randi([0, 1], Subcarriers, numOfSym);
 
%% Implement QAM modulation
TxData_Modulated = qammod(TxData', M, 'InputType','bit');
 
%% Perform IFFT
TxData_IFFT = ifft(TxData_Modulated');
 
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


for i=1 : length(snrV)
    snr = snrV(i)
    %% ------------------------ CHANNEL ---------------------------------------
    %%-------------------------------------------------------------------------
    %% 1) using Rayleigh channel:
    N0 = 1/10^(snr/10);
    for ii = 1:size(TxData_GI,1)
        ray = sqrt((variance)*((randn(1,length(TxData_GI(ii,:)))).^2+(randn(1,length(TxData_GI(ii,:)))).^2));
        % include the fading
        rx = TxData_GI(ii,:).*ray;
        % fading + gaussian noise
        Receive_Channel_rayleigh(ii,:) = rx + sqrt(N0/2)*(randn(1,length(TxData_GI(ii,:)))+1i*randn(1,length(TxData_GI(ii,:))));
    end
    
    %% 2) using AWGN channel
    Receive_Channel_awgn = awgn(TxData_GI ,snr,'measured');
    
    
    %% --------------------- RECEIVER ----------------------------------------
    %%------------------------------------------------------------------------
     
    %% CP  removal
    Recieve_GIremoved  =  Receive_Channel_rayleigh(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    
    Receive_Channel_awgn = Receive_Channel_awgn(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
     
    %% FFT operation
    RecieveData_FFT = fft(Recieve_GIremoved);
    Signal_Magnitude = real(RecieveData_FFT);
    Signal_Phase = imag(RecieveData_FFT);
    
    RecieveData_FFT_AWAG = fft(Receive_Channel_awgn);
    Signal_Magnitude_AWAG = real(RecieveData_FFT_AWAG);
    Signal_Phase_AWAG = imag(RecieveData_FFT_AWAG);
     
    %% plot the received constellations for a specific subcarrier
    % % n = 4; % selected subcarrier
    % % scatterplot(RecieveData_FFT(n,:));
    % % title('FFT Output 16-QAM');
    % % 
    % % scatterplot(RecieveData_FFT_AWAG(n,:));
    % % title('FFT AWAG Output 16-QAM');
    
     
    %% Demodulation
    RecieveData = qamdemod(RecieveData_FFT',M, 'OutputType','bit');
    
    RecieveData_AWAG = qamdemod(RecieveData_FFT_AWAG',M, 'OutputType','bit');
     
    %% Number of Bit Errors and Bit Error Rate computation
    [num , BER(i)] = biterr(TxData, RecieveData');
    
    [num , BER_AWAG(i)] = biterr(TxData, RecieveData_AWAG');


end

figure;
semilogy(snrV, BER_AWAG,'-ok', snrV, BER, '-or');
grid;
ylabel('BER');
xlabel('SNR [dB]');
legend('AWGN', 'Rayleigh');

