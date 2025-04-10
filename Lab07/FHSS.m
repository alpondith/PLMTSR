s=round(rand(1,25));
signal=[];
carrier=[];
T= 120;
t= [ 0:2*pi/ (T-1):2*pi];
for k=1:25
    if s(1,k)==0
        sig = -ones(1,T);
    else
        sig= ones (1,T);
    end 
    c=cos(t);
    carrier=[carrier c];
    signal=[signal sig];
end

figure (1);
plot(signal);
axis([-100 3000 -1.5 1.5]);
title('\bf\it Original Bit Sequence');


bpsk_sig= signal.*carrier;
figure(2);
plot (bpsk_sig);
axis([-100 3000 -1.5 1.5]);
title ('\bf\it BPSK Modulated Signal');

t1=[0:2*pi/9:2*pi];
t2=[0:2*pi/19:2*pi];
t3=[0:2*pi/29:2*pi];
t4=[0:2*pi/39:2*pi];
t5=[0:2*pi/59:2*pi];
t6=[0:2*pi/119:2*pi];
c1=cos(t1);
c1=[c1 c1 c1 c1 c1 c1 c1 c1 c1 c1 c1 c1];
c2=cos(t2);
c2=[c2 c2 c2 c2 c2 c2];
c3=cos(t3);
c3=[c3 c3 c3 c3];
c4=cos(t4);
c4=[c4 c4 c4];
c5=cos(t5);
c5=[c5 c5];
c6=cos(t6);

spread_signal=[];
for n=1:25
c=randi([1 6],1,1);
switch(c)
    case(1)
        spread_signal = [spread_signal c1];
    case(2)
        spread_signal = [spread_signal c2];
    case(3)
        spread_signal = [spread_signal c3];
    case(4)
        spread_signal = [spread_signal c4];
    case(5)
        spread_signal = [spread_signal c5];
    case(6)
        spread_signal = [spread_signal c6];
end
end
spread_signal = [];
codes = {c1, c2, c3, c4, c5, c6};

for n = 1:25
c = mod(n-1, 6) + 1;
spread_signal = [spread_signal, codes{c}];
end

figure (3);
plot(spread_signal);
axis([-100 3000 -1.5 1.5]);
title('Spread Signal Using Manually Selected Codes');

freq_hopped_sig = bpsk_sig .* spread_signal;

figure (4);
plot(freq_hopped_sig);
axis([-100 3000 -1.5 1.5]);
title('Frequency Hopped Signal (bpsk_sig * spread_signal)');

demod_psk=freq_hopped_sig.*spread_signal;

figure(5)
plot (demod_psk);
axis([-100 3000 -1.5 1.5]);
title('demod_psk=freq_hopped_sig.*spread_signal');