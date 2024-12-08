function cepstrum = compute_real_cepstrum(signal)
    % Real cepstrum for a signal segment
    spectrum = fft(signal); % DTFT calc
    log_magnitude = log(abs(spectrum)); 
    cepstrum = ifft(log_magnitude, 'symmetric'); % IDTFT (real cepstrum)
end