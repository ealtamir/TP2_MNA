1;

autoload("compressWav", "compression.m");
autoload("loadWav", "wav_loader.m");
autoload("writeWav", "wav_loader.m");

function X = processWav(name, L)
    [Y, fs, bps] = loadWav(name);
    X = compressWav(Y, L);
    X = addFrequencies(X);
    X = ifft(X);
    writeWav(X, name);
end

function X = addFrequencies(X)
    N = length(X);
    for j = 1:N
        X(N + j) = conj(X(j));
    end
end
