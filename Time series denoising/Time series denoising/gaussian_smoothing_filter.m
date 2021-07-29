%% Gaussian smoothing time series filter

%% Create a signal

srate = 1000; % Hz
time = 0:1/srate:3;
n = length(time);
p = 15; % Poles for random interpolation

% Noise level in standard deviations
noiseamp = 5;

%Amplitude modulation and noise level
amp1 = interp1(rand(p,1)*30, linspace(1,p,n));
noise = noiseamp * randn(size(time));
signal = amp1 + noise;

%% Create Gaussian kernel

% Full-width half-maximum: key parameter
fwhm = 25; % in ms

% Normalize time vector in ms
% Want k sufficiently long so that Gaussian distribution reaches zero
% either side. Also do not want tails too long due to edge effects
k = 40;
gtime = 1000*(-k:k)/srate;

% Create Gaussian window
gauswin = exp(-(4*log(2)*gtime.^2) / fwhm^2);

% Compute empirical FWHM
prePeakHalf = k + dsearchn(gauswin(k+1:end)', 0.5);
pstPeakHalf = dsearchn(gauswin(1:k)', 0.5);

empFWHM = gtime(prePeakHalf) - gtime(pstPeakHalf);

% Show the Gaussian
figure(1), clf, hold on
plot(gtime, gauswin, 'ko-', 'markerfacecolor', 'w', 'linew',2)
plot(gtime([prePeakHalf pstPeakHalf]),gauswin([prePeakHalf pstPeakHalf]),'m','linew',3)

% Normalize Gaussian to unit energy
gauswin = gauswin / sum(gauswin);
title([ 'Gaussian kernel with requeted FWHM ' num2str(fwhm) ' ms (' num2str(empFWHM) ' ms achieved)' ])
xlabel('Time (ms)'), ylabel('Gain')

%% Implementing the filter

% Initialize filtered signal vector
filtsigG = signal;

% Implement the running mean filter
for i=k+1:n-k-1
    % Each point is the weighted average of k surrounding points
    filtsigG(i) = sum(signal(i-k:i+k).*gauswin);
end

% Plot
figure(2), clf, hold on
plot(time, signal, 'r')
plot(time, filtsig, 'k', 'linew',3)

zoom on

xlabel('Time (s)'), ylabel('amp. (a.u.)')
legend({'Original signal';'Gaussian-filtered'})
title('Gaussian smoothing filter')