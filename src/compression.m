1;

autoload("fastFourierTransformDivAndConq", "FFT.m");


function X = compressWav(Y, L, E)
    X = fft(Y);
    X = compress(X, L, E);
end

function X = compress(X, L, E)
    coefficients = truncate(X, E);
    C = calculateQuantization(coefficients, L);
    X = quantize(coefficients, C);
end

function X = truncate(X, E)
    truncate_length = ceil(length(X) / 2) + 1;
    X = X(1:truncate_length);
    for i = 1:length(X)
        if (abs(X(i)) < E)
            X(i) = 0;
        end
    end
end

function C = calculateQuantization(X, L)
    realPart = real(X);
    imgPart = imag(X);

    minRealFreq = min(realPart);
    maxRealFreq = max(realPart);
    realStep = (maxRealFreq - minRealFreq) / L;
    minImgFreq = min(imgPart);
    maxImgFreq = max(imgPart);
    imagStep = (maxImgFreq - minImgFreq) / L;

    C = [minRealFreq:realStep:maxRealFreq; minImgFreq:imagStep:maxImgFreq];
    C = transpose(C);
end

function compressed = quantize(X, C)
    realPart = real(X);
    imgPart = imag(X);
    realQuantLevels = C(:, 1);
    imgQuantLevels = C(:, 2);
    for j = 1:length(X)
        # Cuantización de la parte real e imaginaria.
        realPart(j) = binarySearchQuantization(realQuantLevels, realPart(j));
        imgPart(j) = binarySearchQuantization(imgQuantLevels, imgPart(j));
    end
    compressed = realPart + i * imgPart;
end

function level = binarySearchQuantization(C, num)
    upper = length(C);
    lower = 1;
    index = getIndex(upper, lower);
    while true
        if (index == 1 || index == upper || (num <= C(index) && C(index - 1) < num))
            level = C(index);
            break;
        elseif (num > C(index))
            lower = index;
        else
            upper = index;
        end
        index = getIndex(upper, lower);
    end
end

function index = getIndex(upper, lower)
    index = ceil((upper + lower) / 2);
end

function X = uncompress(X)
    #X = addSecondHalfFrequencies(X);
    X = ifft(X);
    plot(abs(X))
end

function X = addSecondHalfFrequencies(X)
    N = length(X);
    doubleN = 2*(N-1);
    for j = 1:N
        X(doubleN - j) = conj(X(j));
    end
    # Correción para que coincidan los tamaños de la
    # señal de entrada y salida.
    #X = [X; 0];
end

