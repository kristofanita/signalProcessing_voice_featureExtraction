function normalized_signal = normalize_signal(x, segment_ms, fs)
    stable_samples = floor(segment_ms * fs);
    audio = x(1:stable_samples);
    normalized_signal = audio / sum(audio.^2);
end