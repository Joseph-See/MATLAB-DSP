%% Result of this is basically a probability distribution for occurence of spikes

%% Generate time series of random spikes

% Number of spikes
n = 300;

% Inter-spike intervals
isi = round(exp(randn(n,1))*10);

% Generate spike time series
spikets = 0;
for i=1:n
    spikets(length(spikets)+isi(i)) = 1;
end

% Plot
figure(1), clf, hold on
h = plot(spikets);
set(gca,'ylim',[0 1.01],'xlim',[0 length(spikets)+1])
set(h,'color',[1 1 1]*.7)
xlabel('Time (a.u.)')

%% Create and implement Gaussian window

% FWHM - set using trial and error
fwhm = 15;

% Normalized time vector in indices
k = 100;
gtime = -k:k;

% Create Gaussian window
gauswin = exp(-(4*log(2)*gtime.^2) / fwhm^2);
gauswin = gauswin / sum(gauswin);

% Initialized filtered signal vector
filtsigG = zeros(size(spikets));

% implement the weighted running mean filter
for i=k+1:length(spikets)-k-1
    filtsigG(i) = sum(spikets(i-k:i+k).*gauswin);
end

% Plot
plot(filtsigG,'r','linew',2)
legend({'Spikes','Spike p.d.'})
title('Spikes and spike probability density')
zoom on