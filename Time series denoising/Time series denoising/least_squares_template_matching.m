%% Remove artifact via least squares template matching
% Find pattern in the data channel that looks like artifact and remove from
% data channel. This method is same as linear regression models. 
% Beta = (X^T*X)^-1 * X^T * y
% r = y - X * Beta
% beta is regression weight, X is design matrix, y is data, r is residual,
% X * Beta is predicted data
% X column for one artifact is two columns - one all ones, one containing
% artifact

%% 

% want to remove extraneous data that comes from eye movements so we are
% left with signal from the brain
load templateProjection.mat

% Initialize residual data
resdat = zeros(size(EEGdat));

for triali=1:size(resdat,2)
    % Build least squares model as intercept and EOG from this trial
    X = [ones(npnts,1) eyedat(:,triali)];
    
    % Compute regression coefficientgs for EEG channel
    b = (X'*X) \ (X'*EEGdat(:,triali));
    
    % Predicted data
    yHat = X*b;
    
    % New data are the residuals after projecting out the best EKG fit
    resdat(:,triali) = (EEGdat(:,triali) - yHat)';
end

%% Plotting

% trial averages
figure(1), clf
plot(timevec,mean(eyedat,2), timevec,mean(EEGdat,2), timevec,mean(resdat,2),'linew',2)
legend({'EOG';'EEG';'Residual'})
xlabel('Time (ms)')


% show all trials in a map
clim = [-1 1]*20;

figure(2), clf
subplot(131)
imagesc(timevec,[],eyedat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('EOG')


subplot(132)
imagesc(timevec,[],EEGdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('Uncorrected EEG')


subplot(133)
imagesc(timevec,[],resdat')
set(gca,'clim',clim)
xlabel('Time (ms)'), ylabel('Trials')
title('Cleaned EEG')