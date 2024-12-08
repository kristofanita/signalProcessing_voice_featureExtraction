function subbands = compute_dwt_segments(segment, wavelet_type, decomposition_level)
    [c, l] = wavedec(segment, decomposition_level, wavelet_type);
    
    for m = 0:decomposition_level
        subbands{m+1} = wrcoef('a', c, l, wavelet_type, m);
    end
end