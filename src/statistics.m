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
    c = [real(X); imag(X)];
    symbols = unique(c);
    freq = hist(c, symbols);
    weights = freq / sum(freq);
    dictReal = huffmanEncoding(symbols(:, 1), weights(:, 1));
    dictImag = huffmanEncoding(symbols(:, 2), weights(:, 2));

    compressedSize = 0;

    # Sumo los diccionarios reales y complejos
    for k = 1:length(dict)
        compressedSize += length(dictReal{k}.bitstring);
        compressedSize += length(dictImag{k}.bitstring);
    end

    # Sumo los valores máximos y mínimos. Para reales
    # y complejos. Son 4 puntos flotantes.
    compressedSize += 2 * 2 * 64;

    # Longitud original de X. Un entero de 32 bits.
    compressedSize += length(X);

    # Longitud de L. Entero de 16 bits.
    compressedSize += 16;

    for k = 1:length{symbols}
        compressedSize += freq(k, 1) * length(dictReal{k});
        compressedSize += freq(k, 2) * length(dictImag{k});
    end
end
