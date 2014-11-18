1;

autoload("compressWav", "compression.m");
autoload("loadWav", "wav_loader.m");
autoload("writeWav", "wav_loader.m");

function X = processWav(name, L, E)
    [Y, fs, bps] = loadWav(name);
    X = compressWav(Y, L, E);
    X = addSecondHalfFrequencies(X);
    X = ifft(X);
    writeWav(X, name);
end

function X = addSecondHalfFrequencies(X)
    N = length(X);
    for j = 1:N
        X(2*(N-1) - j) = conj(X(j));
    end
end
