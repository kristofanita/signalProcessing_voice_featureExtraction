FOLDER = 'C:\Users\Anita\ppkeMSc3_Erasmus\imageProcessing\Banco vozes_julho_18';
FILE_LIST = dir(fullfile(FOLDER, '**', '*.wav'));

WAVELET_TYPE = 'db1'; % wave function to use in DWT: Daubechies
DECOMPOSITION_LEVEL = 3;
NUM_FILTERS = 40; %filter bank size
OVERLAP_MS = 20;
SEGMENTS_DURATION_MS = 30;
NUM_MFCC = 13;

%prepare the segments:
STABLE_SEGMENT_MS = 2.2;
WINDOW_SIZE = 5; %in ms for Hamming window

for k = 1:length(FILE_LIST)
    %load in audio data
    path = strcat(FILE_LIST(k).folder, '\', FILE_LIST(k).name);
    [y,Fs] = audioread(path);
    disp(path)
    len_sig = length(y);
    disp(len_sig)
    
    if len_sig < Fs*2.2
        continue;
    end

    %disp(Fs*2.2)
    %disp(length(y))
    %disp(length(y)/Fs)
    
    %get artefact-free stable segments --> normalized
    audio = normalize_signal(y, STABLE_SEGMENT_MS, Fs);
    
    %get the 100ms long segments
    segments_100 = segment_signal(audio, Fs);

    %cepstral analysis
    [num_samples, num_segments] = size(segments_100);
    all_cepstra = cell(num_segments, DECOMPOSITION_LEVEL + 1);
    mfcc_features = zeros(num_segments, (DECOMPOSITION_LEVEL +1) * NUM_MFCC);

    for l = 1:num_segments
        segment = segments_100(:, l);
        
        % DWT and subbands for all segments
        subbands = compute_dwt_segments(segment, WAVELET_TYPE, DECOMPOSITION_LEVEL);
        
        % Real cepstrum and mfcc for all subbands
        for m = 1:(DECOMPOSITION_LEVEL + 1)
            cepstra_cells = compute_real_cepstrum(subbands{m});
            all_cepstra{l, m} = cepstra_cells;


            mfcc_features = mfcc(subbands{m}, Fs, ...
                             'OverlapLength', OVERLAP_MS * Fs / 1000, ...
                             'LogEnergy','ignore', ...
                             'Window', hamming(floor(SEGMENTS_DURATION_MS * Fs / 1000)), ...
                             'NumCoeffs', NUM_MFCC);
            
            mfcc_averaged = mean(mfcc_features, 1);
            start_col = (m - 1) * NUM_MFCC + 1;
            end_col = start_col + NUM_MFCC - 1;
            mfcc_features(m, start_col:end_col) = mfcc_averaged;
        end
    end

    % 5. Cepstral distance for all segments
all_distances = cell(num_segments, 1); 

for segment_idx = 1:num_segments
    cepstra = all_cepstra(segment_idx, :); % 1x4 cell array, m = {0, 1, 2, 3}
    
    num_subbands = length(cepstra);
    distances = zeros(num_subbands, 6); 
    
    % For all i, j paris calculate distances
    for i = 1:num_subbands
        for j = 1:num_subbands
            if i ~= j % where i != j
                c_i = cepstra{i};
                c_j = cepstra{j};
                
                % compute the real  cepsrtals distances
                distances(i, :) = compute_cepstral_distances(c_i, c_j);
            end
        end
    end
    
    % store distances
    all_distances{segment_idx} = distances;
end


    %cepstral peaks
    [amplitudes, quefreq_diff, qp1, qp2, energy] = compute_cepstral_peaks(audio);

end











