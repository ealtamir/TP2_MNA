1;

function X = calculateDistortion(original, compressed)
    X = (real(original) - real(compressed)).^2;
    X = sum(X) / length(X);
end

function factor = calculateHuffmanCompressionFactor(X, L, fileSize)
    compressedSize = calculateCompressedSize(X, L);
    factor = compressedSize / fileSize;
end

function compressedSize = calculateCompressedSize(X, L)
    [dictReal, realFreq, realSymbols] = generateDictionary(real(X));
    [dictImag, imgFreq, imagSymbols] = generateDictionary(imag(X));

    compressedSize = 0;

    dictReal

    # Sumo los diccionarios reales y complejos
    for k = 1:length(dictReal)
        compressedSize += length(dictReal{k});
    end
    for k = 1:length(dictImag)
        compressedSize += length(dictImag{k});
    end

    # Sumo los valores máximos y mínimos. Para reales
    # y complejos. Son 4 puntos flotantes.
    compressedSize += 2 * 2 * 64;

    # Longitud original de X. Un entero de 32 bits.
    compressedSize += length(X);

    # Longitud de L. Entero de 16 bits.
    compressedSize += 16;

    for k = 1:length(realSymbols)
        compressedSize += realFreq(k) * length(dictReal{k});
    end
    for k = 1:length(imagSymbols)
        compressedSize += imgFreq(k) * length(dictImag{k});
    end
end

function [dict, freq, symbols] = generateDictionary(X)
    symbols = unique(X);
    freq = hist(X, symbols);
    weights = freq / sum(freq);
    dict = huffmanEncoding(symbols, weights);
end
