1;

autoload("compressWav", "compression.m");
autoload("loadWav", "wav_loader.m");
autoload("writeWav", "wav_loader.m");

function processWav(name, L)
    [Y, fs, bps] = loadWav(name);
    X = compressWav(Y, L);
    X = addFrequencies(X);
    X = ifft(X);
    writeWav(X, name);
end

function X = addFrequencies(X)
    vectorHalf = flipud(X(1:end-1));
    X = [X; vectorHalf];
end
