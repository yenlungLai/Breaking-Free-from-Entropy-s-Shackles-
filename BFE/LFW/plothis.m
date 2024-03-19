function plothis(client, imposter, flag, bitlength, gen2, imp2)
% Plot histogram based on input data and flag

% Check if bitlength argument is provided
if nargin < 4
    bitlength = 0;
end

% Check if gen2 and imp2 arguments are provided
if nargin < 6
    gen2 = [];
    imp2 = [];
end

% Assign input data to variables
collection_dist_correct = client;
collection_dist_incorrect = imposter;

% Handle different flags
if strcmp(flag, 'fm')
    % Implementation for 'fm' flag
    % Normalize distance histograms for 'fm' flag
elseif strcmp(flag, 'bit')
    % Implementation for 'bit' flag
    % Set X axis values for 'bit' flag
    X_vect = 0:0.005:bitlength;
else
    % Display error message for invalid flag
    disp('Error! Only "fm" or "bit" flags are allowed');
    return;
end

% Calculate histogram values for original and additional data
collection_dist_correct_hist = hist(collection_dist_correct, X_vect);
collection_dist_incorrect_hist = hist(collection_dist_incorrect, X_vect);
gen2_hist = hist(gen2, X_vect);  % Calculate histogram for gen2 data
imp2_hist = hist(imp2, X_vect);  % Calculate histogram for imp2 data

% Normalize the height of histograms
collection_dist_correct_hist = collection_dist_correct_hist / max(collection_dist_correct_hist);
collection_dist_incorrect_hist = collection_dist_incorrect_hist / max(collection_dist_incorrect_hist);
gen2_hist = gen2_hist / max(gen2_hist);
imp2_hist = imp2_hist / max(imp2_hist);

% Plot histograms
plot(X_vect, collection_dist_correct_hist, 'r-', X_vect, collection_dist_incorrect_hist, 'k-*', X_vect, gen2_hist, 'g--', X_vect, imp2_hist, 'b-.', 'LineWidth', 2);
title('comparison before and after encoding in terms of their intra and inter class distribution')
% Set labels and title
xlabel('$\varepsilon$', 'interpreter', 'latex');
ylabel('Frequency', 'interpreter', 'latex');

% Calculate mean and variance for the histograms
mean_correct = mean(collection_dist_correct);
mean_incorrect = mean(collection_dist_incorrect);
var_correct = var(collection_dist_correct);
var_incorrect = var(collection_dist_incorrect);
mean_gen2 = mean(gen2);
mean_imp2 = mean(imp2);
var_gen2 = var(gen2);
var_imp2 = var(imp2);

% Set legend including mean and variance
legend({['$\frac{\arccos(w\cdot{w''})}{\pi}$ (Intra-class) (mean: ', num2str(mean_correct), ', var: ', num2str(var_correct), ')'], ['$\frac{\arccos(w\cdot{w''})}{\pi}$ (Inter-class)  (mean: ', num2str(mean_incorrect), ', var: ', num2str(var_incorrect), ')'], ['$t/n$ (Intra-class)  (mean: ', num2str(mean_gen2), ', var: ', num2str(var_gen2), ')'], ['$t/n$ (Inter-class)  (mean: ', num2str(mean_imp2), ', var: ', num2str(var_imp2), ')']}, 'interpreter', 'latex');

% Set axis limits
axis([0, 0.5, 0, 1.4]);

% Set figure background color
set(gcf, 'color', [1 1 1]);

end
