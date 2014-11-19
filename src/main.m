1;

source("/Users/Enzo/Documents/TP_MNA/src/compression.m");
source("/Users/Enzo/Documents/TP_MNA/src/wav_loader.m");
source("/Users/Enzo/Documents/TP_MNA/src/huffman.m");
source("/Users/Enzo/Documents/TP_MNA/src/statistics.m");

function plotWithFixedBits(name)
    epsilon = 0.1;
    L = 4;
    for j = 0:epsilon:epsilon * 10
        [_, distortion, compressionFactor] = processWav(name, L, epsilon, false);
    end
end

function plotWithFixedEpsilon(name)
    maxL = 8;
    epsilon = 0.1;
    for L = 1:maxL
        [_, distortion, compressionFactor] = processWav(name, L, epsilon, false);
    end
end

function X = processWav(name, L=16, E=0.1, writeWav=true)
    [Y, fileSize] = loadWav(name);
    X = compressWav(Y, L, E);
    X = uncompress(X);
    if writeWav
        writeWav(X, name);
    end
    #distortion = calculateDistortion(Y, X);
    #compressionFactor = calculateHuffmanCompressionFactor(X, L, fileSize);
end
