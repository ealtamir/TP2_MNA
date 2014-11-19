1;

source("/Users/Enzo/Documents/TP_MNA/src/compression.m");
source("/Users/Enzo/Documents/TP_MNA/src/wav_loader.m");
source("/Users/Enzo/Documents/TP_MNA/src/huffman.m");
source("/Users/Enzo/Documents/TP_MNA/src/statistics.m");


function [X, distortion, compressionFactor] = processWav(name, L=16, E=0.1, writeWav=true)
    Y = loadWav(name);
    X = compressWav(Y, L, E);
    X = uncompress(X);
    writeWav(X, name);
    distortion = 0;
    compressionFactor = 0;
    #if writeWav
    #    writeWav(X, name);
    #end
    #distortion = calculateDistortion(Y, X);
    #compressionFactor = calculateHuffmanCompressionFactor(X, L, fileSize);
end

function plotWithFixedBits(name)
    epsilon = 0.1;
    L = 4;
    distortion = [];
    compressionFactor = [];
    for j = 0:epsilon:epsilon * 10
        [_, distortion(j), compressionFactor(j)] = processWav(name, L, epsilon, false);
    end
end

function plotWithFixedEpsilon(name)
    maxL = 8;
    epsilon = 0.1;
    distortion = [];
    compressionFactor = [];
    for L = 1:maxL
        [_, distortion(j), compressionFactor(j)] = processWav(name, L, epsilon, false);
    end
end
