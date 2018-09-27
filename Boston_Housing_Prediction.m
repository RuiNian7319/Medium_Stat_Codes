% Clear previous variables
clear; clc;

% Load all the Boston housing data
data = xlsread('train.xls');





%%%%%%%%%%%%%%%%%%%   Separate the data into labels and features   %%%%%%%%%%%%%%%%%%%%%

labels = data(:, 1);

% Add the intercept vector

features = data(:, 2:end);
theta_0 = ones(size(features, 1), 1); 
features = [theta_0, data(:, 2:end)];   % Added theta_0 to features to obtain the intercept





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Regression     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameters = (features'*features)\features'*labels;

% Predicted median housing prices
y_hat = parameters' * features';






%%%%%%%%%%%%%%%%%%%%%%%%%%     Significance Calc     %%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(data, 1);
p = size(parameters, 1);
k = size(parameters, 1) - 1;

% Sum of squares residual, measures the amount of variance explained
error = y_hat - mean(labels);
SSR = error * error';
MSR = SSR / (k);

% Sum of squares error, measures the amount of variance not explained
% Calculates the amount of prediction error
error = labels - y_hat';
SSE = error' * error;
MSE = SSE / (n - p);

% Test for significance using F0 at a 95% confidence
F0 = MSR/MSE;
f_value = icdf('f', 1-0.05, k, n - p);
if F0 > f_value
    fprintf('Regression is significant \n');
else
    fprintf('Regression is insignificant \n');
end





%%%%%%%%%%%%%%%%%%%%%%%%  Coefficient of Determination  %%%%%%%%%%%%%%%%%%%%%
% Total variability within the data
error = labels - mean(labels);
Syy = error' * error;

% Coefficient of Determination
R2 = 1 - (SSE / Syy);
R2_adjusted = 1 - ((SSE / Syy) * ((n - 1) / (n - p)));
fprintf('The R2 and R2_adjusted are:')
disp([R2, R2_adjusted]);

variance = SSE / (n - p);
covariance = variance * inv(features' * features);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Confidence Intervals %%%%%%%%%%%%%%%%%%%%%%%%
alpha = 0.05 / 2;      % Alpha for a 2 tailed test.
z_scores = icdf('normal',[alpha (1 - alpha)], 0, 1);

confidence_intervals = zeros([size(parameters, 1), 2]);
for i = 1:size(parameters, 1)
    confidence_intervals(i, :) = [ 
        parameters(i, 1) + sqrt(covariance(i, i)) / sqrt(size(data, 1)) * z_scores(1), ...
        parameters(i, 1) + sqrt(covariance(i, i)) / sqrt(size(data, 1)) * z_scores(2) ...
        ];
end


% Plot the predicted and actual data
y_hat_plot = scatter(1:n, y_hat, 'b');
hold on
labels_plot = scatter(1:n, labels, 'r');
% upper_confidence = features * confidence_intervals(:, 1);
% lower_confidence = features * confidence_intervals(:, 2);
% plot_upper = plot(upper_confidence, 'g--');
% plot_lower = plot(lower_confidence, 'r--');
ylim([-10 80])
hold off

legend('Predicted Median Housing Price, $1000s', 'Real Median Housing Price, $1000s')





%%%%%%%%%%%%%%%%%%%%%%%     Validating our model  %%%%%%%%%%%%%%%%%%%%%%

% Load the data
validation = xlsread('test.xls');
n = numel(validation_labels);  % Amount of data in validation labels

% Split the labels and features
validation_labels = validation(:, 1);

theta_0 = ones(size(validation, 1), 1);
validation_features = [theta_0, validation(:, 2:end)];

% Make the predictions
validation_yhat = validation_features * parameters;

% Plot the predictions
figure()
scatter(1:n, validation_yhat, 'b')
hold on
scatter(1:n, validation_labels, 'r')
ylim([-15, 40])
