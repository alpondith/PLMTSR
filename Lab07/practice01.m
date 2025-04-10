% DSSS_model 
b = round(rand(1,60)); % Generate 60 bits
pattern=[]; 
for k=1:60 
    if b(1,k)==0 
        sig= -ones(1,40);   % Each bit is 40 samples long
    else
        sig=ones(1,40);            
    end
    pattern=[pattern sig];
end

figure (1); 
plot (pattern); 
axis([-1 2400 -1.5 1.5]); % Adjust axis for 60 bits * 40 samples
title('\bf\it Original Bit Sequence');

d = round(rand(1,480)); 
pn_seq = []; 
carrier=[]; 
t=0:2*pi/4:2*pi; 
% note: carrier and t will be used to modulate the signal 
for k=1:480 
    if d(1,k)==0 
        sig = -ones(1,5); 
    else 
        sig = ones(1,5); 
    end 
    pn_seq= [pn_seq sig]; 
    c=cos(t); 
    carrier=[carrier c]; 
end

spread_sig = pattern.*pn_seq;
figure (2);
plot(spread_sig);
axis([-1 2400 -1.5 1.5]); % Adjust axis for spread signal
title('Spreaded Signal');
pattern = pattern(1:length(pn_seq)); % To prevent error

bpsk_sig = spread_sig.*carrier;
figure (3);
plot (bpsk_sig);
axis([-1 2400 -1.5 1.5]); % Adjust axis for BPSK signal
title('BPSK Modulated Signal');

rxsig=bpsk_sig.*carrier; 
demod_sig=[]; 
for i=1:2400 % Adjust for 60 bits * 40 samples
    if rxsig(i)>=0 
        rxs =1; 
    else 
        rxs =-1; 
    end 
    demod_sig=[demod_sig rxs]; 
end

figure (4);
plot (demod_sig);
axis([-1 2400 -1.5 1.5]); % Adjust axis for demodulated signal
title('Demodulated Signal');

despread_sig=demod_sig.*pn_seq;  
figure (5); 
plot (despread_sig); 
axis([-1 2400 -1.5 1.5]); % Adjust axis for despreaded signal
title('Despreaded data');