1;

source("/Users/Enzo/Documents/TP_MNA/src/compression.m");
source("/Users/Enzo/Documents/TP_MNA/src/wav_loader.m");
source("/Users/Enzo/Documents/TP_MNA/src/huffman.m");
source("/Users/Enzo/Documents/TP_MNA/src/statistics.m");


function [C, distortion, compressionFactor] = processWav(name, L=16, E=0.1, generateWav=true)
    [Y, fileSize] = loadWav(name);
    C = compressWav(Y, L, E);

    U = uncompress(C);
    if generateWav
        writeWav(U, name);
    end
    distortion = calculateDistortion(Y, U);
    compressionFactor = calculateHuffmanCompressionFactor(C, L, fileSize);
end

function plotWithFixedBits(name, epsilon=0.1, L=4)
    x = 0:epsilon:epsilon * 10;
    distortion = [];
    compressionFactor = [];
    for j = 1:length(x)
        [_, distortion(j), compressionFactor(j)] = processWav(name, L, x(j), false);
    end
    plot(x, distortion, "b");
    xlabel("epsilon");
    ylabel("Distorcion (mas chico mejor)");
    print -dpng -color "../plots/distorcion_media_fixed_bits.png";
    plot(x, compressionFactor, "g");
    xlabel("epsilon");
    ylabel("Compresion (porcentaje del tamano original)");
    print -dpng -color "../plots/compresion_media_fixed_bits.png";
end

function plotWithFixedEpsilon(name, epsilon=0.1, maxL=8)
    distortion = [];
    compressionFactor = [];
    L = [1:maxL].^2;
    for j = 1:length(L)
        [_, distortion(j), compressionFactor(j)] = processWav(name, L(j), epsilon, false);
    end
    plot(L, distortion, "b");
    xlabel("Bits de Cuantificacion (L)");
    ylabel("Distorcion (mas chico mejor)");
    print -dpng -color "../plots/distorcion_media_fixed_epsilon.png";
    plot(L, compressionFactor, "g");
    xlabel("Bits de Cuantificacion (L)");
    ylabel("Compresion (porcentaje del tamano original)");
    print -dpng -color "../plots/compresion_media_fixed_epsilon.png";
end
