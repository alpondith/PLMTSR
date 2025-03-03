% 16-QAM: Quadrature Amplitude Modulation, a type of digital modulation where
% 16 different phases and amplitudes are used to represent 4-bit symbols.

% number of bits to transmit
n = 6000;
% signal to noise ratio
SNR = 14;
% BPSK modulation order (number of symbols)
modulation_order = 16; 
% generate random bit stream
bit_stream = randi([0, modulation_order-1],1,n);

% calculate and display bits per symbol based on modulation order
bits_per_symbol = log2(modulation_order);
disp(['Bits per Symbol: ', num2str(bits_per_symbol)]);

% modulate the bit stream
modulated_signal = qammod(bit_stream,modulation_order);
% scatter plot the modulated signal
scatterplot(modulated_signal), title('Transmitted Signal');

% received signal with AWGN noise
received_signal = awgn(modulated_signal, SNR); 
% scatter plot the received signal
scatterplot(received_signal), title('Received Signal');

% demodulation of the received signal 
demodulated_bit_stream = pskdemod(received_signal, modulation_order); 

% Calculate and display the number of bit errors
error_bits = sum(demodulated_bit_stream ~= bit_stream);
disp(['Error Bits: ', num2str(error_bits)]);
