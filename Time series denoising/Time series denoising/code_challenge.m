%% Code challenge: filter origSignal to appear similar to cleanedSignal

load denoising_codeChallenge.mat

n = 4000;
t = 1:length(origSignal);

figure(1), clf
histogram(origSignal, 100)
zoom on

threshold = 5;
suprathresh = find(abs(origSignal)>threshold);

filtsig = origSignal;

k = 20; 
for ti=1:length(suprathresh)
    % lower bound
    lowbnd = max(1, suprathresh(ti)-k);
    uppbnd = min(suprathresh(ti)+k,n);
    
    % Compute median of surrounding points
    filtsig(suprathresh(ti)) = median(origSignal(lowbnd:uppbnd));
end

figure(2), clf
plot(t, cleanedSignal, t,filtsig, 'linew', 2)
zoom on

filtsig1 = filtsig;
k = 100; % Filter window is actually k*2+1
for i=k+1:n-k-1
   % Each point is the average of k surrounding points
   filtsig1(i) = mean(filtsig(i-k:i+k));
end

figure(3), clf, hold on
plot(t, cleanedSignal, t, filtsig1, 'linew', 2)