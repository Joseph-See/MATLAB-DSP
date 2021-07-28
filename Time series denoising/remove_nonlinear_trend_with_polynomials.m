%% Removing non-linear trends with polynomials

%% Generate signal with slow polynomial artifact

n = 10000;
t = (1:n)';
k = 10; % Number of poles for random amplitudes
slowdrift = interp1(100*randn(k,1), linspace(1,k,n), 'pchip')';
signal = slowdrift + 20*randn(n,1);

figure(1), clf, hold on
h = plot(t, signal);
set(h, 'color', [1 1 1]*.6)
xlabel('Time (a.u.)'), ylabel('Amplitude')

%% Fit a 3-order polynomial
 
% Polynomial fit (returns coeffs)
p = polyfit(t, signal, 7);

% Evaluation of polynomial for data prediction
yHat = polyval(p,t);

% Compute residual (cleaned signal)
residual = signal - yHat;

% Plot the fit (function to be removed)
plot(t, yHat, 'r', 'linew', 4)
plot(t, residual, 'k', 'linew', 2)

legend({'Original';'Polyfit';'Filtered Signal'})

%% Using Bayes information criterion to find the optimal order
% b = n*ln(epsilon) + k*ln(n)
% epsilon = n^-1 * sum from 1 to n of (YHat_i - y_i)^2 i.e. mean squared
% error

% possible orders
orders = (5:40)';

% Sum of squared errors
sse1 = zeros(length(orders),1);

% loop through orders
for ri = 1:length(orders)
    
    % Compute polynomial
    yHat = polyval(polyfit(t, signal,orders(ri)),t);
    
    % Compute fit of model to data (sum of squared errors)
    sse1(ri) = sum((yHat - signal).^2) / n;
end

% Bayes Information Criterion
bic = n*log(sse1) + orders*log(n);

% Best parameter has lowest BIC
[bestP,idx] = min(bic);

% Plot the BIC
figure(3), clf, hold on
plot(orders,bic,'ks-','markerfacecolor','w','markersize',8)
plot(orders(idx),bestP,'ro','markersize',10,'markerfacecolor','r')
xlabel('Polynomial order'), ylabel('Bayes information criterion')
zoom on

%% Repeat filter for best (smallest) BIC

% Polynomial fit
polycoefs = polyfit(t, signal, orders(idx));

% Estimated data based on coeffs
yHat = polyval(polycoefs, t);

% Filtered signal is residual
filtsig = signal - yHat;

% Plot
figure(4), clf, hold on
h = plot(t, signal);
set(h, 'color',[1 1 1]*.6)
plot(t, yHat, 'r', 'linew', 2)
plot(t, filtsig, 'k')
set(gca, 'xlim', t([1 end]))

xlabel('Time (a.u.)'), ylabel('Amplitude')