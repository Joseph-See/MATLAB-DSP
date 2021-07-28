%% Using a median filter to remove spike noise
% NOTE: median filter is non-linear! Should only be applied to selected
% data points, not all data points

%%

% Create signal
n = 2000;
signal = cumsum(randn(n,1));

% Proportion of time points to be replaced with noise
propnoise = 0.05;

% Find noise points
noisepnts = randperm(n);
noisepnts = noisepnts(1:round(n*propnoise));

% Generate signal and replace points with noise
signal(noisepnts) = 50+rand(size(noisepnts))*100;

% Use hist to pick threshold
figure(1), clf
histogram(signal, 100)
zoom on

% Visually chosen threshold
threshold = 1;

% Find data values above threshold
suprathresh = find(signal>threshold);

% initialize filtered signal
filtsig = signal;

% Loop through suprathreshold points and set to median of k
k = 20; 
for ti=1:length(suprathresh)
    % lower bound
    lowbnd = max(1, suprathresh(ti)-k);
    uppbnd = min(suprathresh(ti)+k,n);
    
    % Compute median of surrounding points
    filtsig(suprathresh(ti)) = median(signal(lowbnd:uppbnd));
end

figure(2), clf
plot(1:n, signal, 1:n,filtsig, 'linew', 2)
zoom on