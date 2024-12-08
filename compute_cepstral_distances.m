function distances = compute_cepstral_distances(c_i, c_j)
    num = min(length(c_i), length(c_j));
    distances = zeros(6, 1); % 6 distances
    
    
    sum_term = 0;
    sum_quefreq_n = 0;
    sum_quefreq_root = 0;
    sum_quefreq_pow = 0;
    for n = 2:num
        sum_term = sum_term + (c_i(n) - c_j(n))^2;
        sum_quefreq_n = sum_quefreq_n + n * (c_i(n) - c_j(n))^2;
        sum_quefreq_root = sum_quefreq_root + sqrt(n) * (c_i(n) - c_j(n))^2;
        sum_quefreq_pow = sum_quefreq_pow + n^2 * (c_i(n) - c_j(n))^2;
    end
    distances(1) = 4.3429 * sqrt((c_i(1) - c_j(1))^2 + 2 * sum_term); % NRMSCD
    distances(2) = 4.3429 * sqrt(2 * sum_term); % NRMSCD - without first
    distances(3) = sqrt(sum_term); % Euklidean
    distances(4) = sqrt(sum_quefreq_n); % Quefrequency Weighted
    distances(5) = sqrt(sum_quefreq_root); % Quefrequency Root Weighted
    distances(6) = sqrt(sum_quefreq_pow); % Quefrequency Square Weighted
             
end
