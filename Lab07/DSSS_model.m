% DSSS_model 
b = round(rand(1,30)); % Generate 30 bits
pattern=[]; 
for k=1:30 
    if b(1,k)==0 
        sig= -ones(1,20);   
    else
        sig=ones(1,20);            
    end
    pattern=[pattern sig];
end

figure (1); 
plot (pattern); 
axis([-1 620 -1.5 1.5]); 
title('\bf\it Original Bit Sequence');

d = round(rand(1,120)); 
pn_seq = []; 
carrier=[]; 
t=0:2*pi/4:2*pi; 
% note: carrier and t will be used to modulate the signal 
for k=1:120 
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
plot (spread_sig);
axis([-1 620 -1.5 1.5]);
title('Spreaded Signal');


bpsk_sig = spread_sig.*carrier;
figure (3);
plot (bpsk_sig);
axis([-1 620 -1.5 1.5]);
title('BPSK Modulated Signal');

rxsig=bpsk_sig.*carrier; 
demod_sig=[]; 
for i=1:600 
    if rxsig(i)>=0 
        rxs =1; 
    else 
        rxs =-1; 
    end 
    demod_sig=[demod_sig rxs]; 
end

figure (4);
plot (demod_sig);
axis([-1 620 -1.5 1.5]);
title('Demodulated Signal');

despread_sig=demod_sig.*pn_seq;  
figure (5); 
plot (despread_sig); 
axis([-1 620 -1.5 1.5]); 
title('Despreaded data');