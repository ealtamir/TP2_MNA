1;

autoload("fastFourierTransformDivAndConq", "FFT.m");


function X = compressWav(Y, L=16)
    X = fft(Y);
    X = compress(X, L);
end

function X = compress(X, L)
    X = truncate(X);
    C = calculateQuantization(X, L);
    X = quantize(X, C);
end

function X = truncate(X)
    truncate_length = ceil(length(X) / 2) + 1;
    X = X(1:truncate_length);
end

function C = calculateQuantization(X, L)
    minRealFreq = min(real(X));
    maxRealFreq = max(real(X));
    realStep = (maxRealFreq - minRealFreq) / L;

    minImgFreq = min(imag(X));
    maxImgFreq = max(imag(X));
    imagStep = (maxImgFreq - minImgFreq) / L;
    C = [minRealFreq:realStep:maxRealFreq; minImgFreq:imagStep:maxImgFreq];
    C = transpose(C);
end

function compressed = quantize(X, C)
    realPart = real(X);
    imgPart = imag(X);
    for j = 1:length(X)
        # Cuantización de la parte real e imaginaria.
        realDone = false;
        imgDone = false;
        for k = 1:length(C)
            if (!realDone && realPart(j) <= C(k, 1))
                realPart(j) = C(k, 1);
                realDone = true;
            end
            if (!imgDone && imgPart(j) <= C(k, 2))
                imgPart(j) = C(k, 2);
                imgDone = true;
            end
            if (realDone && imgDone)
                break;
            end
        end
    end
    compressed = realPart + i * imgPart;
end
