function [h] = rayleighFading (M, N, fd, Ts) 
    a = 0; 
    b = 2*pi; 
    alpha = a+(b-a)*rand (1,M); %uniformly distributed from 0 to 2 pi 
    beta = a+(b-a)*rand (1,M); %uniformly distributed from 0 to 2 pi 
    theta = a+(b-a)*rand (1,M); %uniformly distributed from 0 to 2 pi 
    m = 1:M; 
    h_re = zeros (1,N); 
    h_im = zeros (1,N); 
    for n = 1:N 
        x = cos(((2.*m-1)*pi+theta)/(4*M)); 
        h_re(n) = 1/sqrt(M)*sum(cos(2*pi*fd*x*n*Ts+alpha)); 
        h_im(n) = 1/sqrt(M)*sum(sin(2*pi*fd*x*n*Ts+beta)); 
    end
    h = h_re + 1j*h_im; 
end


M_mod = 2; % modulation order 
N = 10^5; % number of samples 

bitSequence = randi([0, 1], N, 1); 

x = pskmod(bitSequence, M_mod); 

refC = [-1, 1]; 

constDiag = comm.ConstellationDiagram('ReferenceConstellation', refC, 'XLimits',[-7 7],'YLimits',[-7 7]); 

% constDiag1(x) 

nois_var = 0.1; 

noise = (nois_var)*(randn(1,N) + 1i*randn(1,N)); % AWGN noise with mean=0 var=0.1 

M = 15; N = 10^5; fd = 100; Ts = 0.0001; sigma=1; 

h_ray = rayleighFading(M,N,fd,Ts); 

h_ric_s1 = ricianFading(s1, sigma, N); 

h_ric_s2 = ricianFading(s2, sigma, N); 

h_ric_s3 = ricianFading(s3, sigma, N); 

h_ric_s4 = ricianFading(s4, sigma, N); 