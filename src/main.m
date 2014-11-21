1;

source("./src/compression.m");
source("./src/wav_loader.m");
source("./src/huffman.m");
source("./src/statistics.m");



function [C, distortion, compressionFactor, compressedSize] = processWav(name, L=16, E=0.1, generateWav=true)
    [Y, fileSizeInBits] = loadWav(name);
    C = compressWav(Y, L, E);

    U = uncompress(C);
    if generateWav
        writeWav(U, name);
    end
    distortion = calculateDistortion(Y, U);
    [compressionFactor, compressedSize] = calculateHuffmanCompressionFactor(C, L, fileSizeInBits);
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
    print -dpng -color "./plots/distorcion_media_fixed_bits.png";
    plot(x, compressionFactor, "g");
    xlabel("epsilon");
    ylabel("Compresion (porcentaje del tamano original)");
    print -dpng -color "./plots/compresion_media_fixed_bits.png";
end

function plotWithFixedEpsilon(name, epsilon=0.1, maxL=8)
    distortion = [];
    compressionFactor = [];
    L = 2 * ones(maxL, 1);
    for j = 1:maxL
        L(j) = L(j) ^ j;
    end
    for j = 1:length(L)
        [_, distortion(j), compressionFactor(j)] = processWav(name, L(j), epsilon, false);
    end
    plot(L, distortion, "b");
    xlabel("Bits de Cuantificacion (L)");
    ylabel("Distorcion (mas chico mejor)");
    print -dpng -color "./plots/distorcion_media_fixed_epsilon.png";
    plot(L, compressionFactor, "g");
    xlabel("Bits de Cuantificacion (L)");
    ylabel("Compresion (porcentaje del tamano original)");
    print -dpng -color "./plots/compresion_media_fixed_epsilon.png";
end

function [info] = generateCompressedWavFiles()
    info = {};
    [_, a, b, c] = processWav("p1");
    info{1} = [a, b, c/8];
    [_, a, b, c] = processWav("p2");
    info{2} = [a, b, c/8];
    [_, a, b, c] = processWav("p3");
    info{3} = [a, b, c/8];
    [_, a, b, c] = processWav("p4");
    info{4} = [a, b, c/8];
    [_, a, b, c] = processWav("p5");
    info{5} = [a, b, c/8];
    [_, a, b, c] = processWav("p6");
    info{6} = [a, b, c/8];
    [_, a, b, c] = processWav("p7");
    info{7} = [a, b, c/8];
    [_, a, b, c] = processWav("p8");
    info{8} = [a, b, c/8];
    [_, a, b, c] = processWav("p9");
    info{9} = [a, b, c/8];
    [_, a, b, c] = processWav("p10");
    info{10} = [a, b, c/8];
end
