% Calculate all the different combinations
values = [1, 2, 3, 4, 5, 6, 5, 4, 3, 2];   % All probabilities on the wheel
table = [];
for i = 1:numel(values)
    for j = 1:numel(values)
        table = [table, values(i) + values(j)];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Population mean and variance
pop_mean = mean(table);  % Calculate the population mean of the outputs
pop_variance = var(table, 1);   % Calculates the population variance of the outputs

z_probability = 1 - cdf('normal', (7.5 - pop_mean) / sqrt(pop_variance), 0, 1);  % Calculate the z score

pop_prob_over_7 = z_probability * 100
pop_prob_under_7 = z_probability * 100
pop_prob_7 = 100 - prob_over_7 - prob_under_7


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample mean and variance
rolls = [11, 4, 5, 7, 8, 6, 7, 9, 3, 6];

sample_mean = mean(rolls);  % Calculate the sample mean of the outputs
sample_variance = var(rolls);    % Calculates the sample variance of the outputs

t_prob_over7 = 1 - cdf('t', (7.5 - sample_mean) / sqrt(sample_variance), 9);
t_prob_under7 = cdf('t', (6.5 - sample_mean) / sqrt(sample_variance), 9);

samp_prob_over_7 = t_prob_over7 * 100
samp_prob_under_7 = t_prob_under7 * 100
samp_prob_7 = 100 - prob_over_7 - prob_under_7
