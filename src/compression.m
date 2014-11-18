1;

autoload("fastFourierTransformDivAndConq", "FFT.m");


function X = compressWav(Y, L=16, E=0.1)
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
    for j = 1:length(X)
        # Cuantización de la parte real e imaginaria.
        binarySearchQuantization(realPart, C, j);
        binarySearchQuantization(imgDone, C, j);
    end
    compressed = realPart + i * imgPart;
end

function binarySearchQuantization(arr, C, j)
    upper = length(C);
    lower = 1;
    index = getIndex(upper, lower);
    num = arr(j);
    while true
        if (index == 1 || (num <= C(index) && C(index - 1) < num))
            arr(j) = C(index);
            break;
        elseif (C(index) > num)
            upper = index;
        else
            lower = index;
        end
        index = getIndex(upper, lower);
    end
end

function index = getIndex(upper, lower)
    index = ceil((upper + lower) / 2)
end
