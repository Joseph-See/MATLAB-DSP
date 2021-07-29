%% Time domain denoising: mean-smooth a time series

%% 

% Create a signal
srate = 1000; %Hz
time = 0:1/srate:3;
n = length(time);
p = 15; % poles for random interpolation

% Noise level measured as standard deviations
noiseamp = 5;

% Amplitude modulation and noise level
amp1 = interp1(rand(p,1)*30,linspace(1,p,n));
noise = noiseamp * randn(size(time));
signal = amp1 + noise;

% Initialize filtered signal vector
% Note edge effect differences between these two initialization methods
%filtsig = zeros(size(signal));
filtsig = signal;

% Implement running mean filter
k = 100; % Filter window is actually k*2+1
for i=k+1:n-k-1
   % Each point is the average of k surrounding points
   filtsig(i) = mean(signal(i-k:i+k));
end

% Compute window size in ms
windowsize = 1000*(k*2+1) / srate;

% Plot noisy and filtered signal
figure(1), clf, hold on
plot(time, signal, time, filtsig, 'linew', 2)

% Draw a patch to indicate the window size
tidx = dsearchn(time', 1);
ylim = get(gca, 'ylim');
patch(time([ tidx-k tidx-k tidx+k tidx+k ]),ylim([ 1 2 2 1 ]),'k','facealpha',.25,'linestyle','none')
plot(time([tidx tidx]), ylim, 'k--')

xlabel('Time (sec.)'), ylabel('Amplitude')
title([ 'Running-mean filter with a k=' num2str(round(windowsize)) '-ms filter' ])
legend({'Signal';'Filtered';'Window';'window center'})

zoom on