function [peak_amplitudes, quefreq_differences, ep1, ep2, cepstrum_energy] = compute_cepstral_peaks(features)
    [peak_amplitudes, peak_locs] = findpeaks(features); % peaks and places
    quefreq_differences = diff(peak_locs); % diff between first 2 peaks
    ep1 = features(peak_locs(1));
    ep2 = features(peak_locs(2));
    cepstrum_energy = sum(features(peak_locs(1):peak_locs(2)).^2); % energy between peaks
end
