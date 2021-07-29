%% Removing a linear trend

%%

% Create signal with a linear trend imposed
n = 2000;
signal = cumsum(rand(1,n)) + linspace(-30,30,n);

% Linear detrending
detsignal = detrend(signal);

% Plot signal and detrended signal
figure(1), clf
plot(1:n, signal, 1:n,detsignal, 'linew',3)
legend({ ['Original (mean=' num2str(mean(signal)) ')' ];[ 'Detrended (mean=' num2str(mean(detsignal)) ')' ]})