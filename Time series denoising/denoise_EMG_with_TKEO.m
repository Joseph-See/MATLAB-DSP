%% Denoising a electromyorgam signal with TKEO
%Teager-Keiser energy-tracking operator (TKEO)
% y_t = (x_t)^2 - x_(t-1) * x_(t+1)
% Square current time point and remove product of previous and following
% time point
%%

load emg4TKEO.mat

% Initialize filtered signal
emgf = emg;

% Loop version
for i=2:length(emgf)-1
    emgf(i) = emg(i)^2 - emg(i-1)*emg(i+1);
end

% Vectorized version
emgf2 = emg;
emgf2(2:end-1) = emg(2:end-1).^2 - emg(1:end-2).*emg(3:end);

%% Convert both signals to zscore
% Using pre-zero time period as a baseline and finding Z score 

% Find zero timepoint
time0 = dsearchn(emgtime', 0);

% Convert original EMG to z-score from time zero
emgZ = (emg-mean(emg(1:time0))) / std(emg(1:time0));

% Perform same for filtered EMG energy
emgZf = (emgf-mean(emgf(1:time0))) / std(emgf(1:time0));

%% Plot

figure(1), clf

% plot "raw" (normalized to max-1)
subplot(211), hold on
plot(emgtime,emg./max(emg),'b','linew',2)
plot(emgtime,emgf./max(emgf),'m','linew',2)

xlabel('Time (ms)'), ylabel('Amplitude or energy')
legend({'EMG';'EMG energy (TKEO)'})


% plot zscored
subplot(212), hold on
plot(emgtime,emgZ,'b','linew',2)
plot(emgtime,emgZf,'m','linew',2)

xlabel('Time (ms)'), ylabel('Zscore relative to pre-stimulus')
legend({'EMG';'EMG energy (TKEO)'})