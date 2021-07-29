%% Averaging multiple repetitions AKA time-synchronous averaging

%% Simulate data

% Create event (derivative of Gaussian)
k = 100; % Event duration in time points
event = diff(exp(-linspace(-2,2,k+1).^2));
event = event./max(event); % Normalize t max=1

% Event onset times
Nevents = 30;
onsettimes = randperm(10000-k);
onsettimes = onsettimes(1:Nevents);

% Put event into data
data = zeros(1,10000);
for ei=1:Nevents
    data(onsettimes(ei):onsettimes(ei)+k-1) = event;
end

% Add noise
data = data + .5*randn(size(data));

% Plot
figure(1), clf
subplot(211)
plot(data)

% Plot one event
subplot(212)
plot(1:k, data(onsettimes(3):onsettimes(3)+k-1), 1:k, event, 'linew',3);

%% Extract all events into a matrix

datamatrix = zeros(Nevents, k);

for ei=1:Nevents
    datamatrix(ei,:) = data(onsettimes(ei):onsettimes(ei)+k-1);
end

figure(2), clf
subplot(4,1,1:3)
imagesc(datamatrix)
xlabel('Time'), ylabel('Event Number')
title('All events')

subplot(414)
plot(1:k,mean(datamatrix), 1:k,event,'linew',3)
xlabel('Time'), ylabel('Amplitude')
legend({'Averaged';'Ground-truth'})
title('Average events')
