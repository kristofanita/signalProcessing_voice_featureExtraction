function segments = segment_signal(signal, fs)
    segment_length = round(0.1 * fs); % 100 ms 
    hamming_window = hamming(segment_length);
    num_segments = floor(length(signal) / segment_length);
    
    segments = zeros(segment_length, num_segments);
    for i = 1:num_segments
        start_idx = (i - 1) * segment_length + 1;
        end_idx = start_idx + segment_length - 1;
        segments(:, i) = signal(start_idx:end_idx) .* hamming_window;
    end
end