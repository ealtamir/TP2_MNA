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

#function C = calculateQuantization(X, L)
#    minCoeff = min(X);
#    maxCoeff = max(X);
#    step = (maxCoeff - minCoeff) / L;
#    C = [minCoeff];
#    for i = 1:L-1
#        C(i+1) = C(i) + step;
#    end
#    abs(C)
#end
#
#function compressed = quantize(coefficients, C)
#    compressed = coefficients;
#    for j = 1:length(coefficients)
#        done = false;
#        for k = 1:length(C)
#            if (!done && compressed(j) <= C(k))
#                done = true;
#                compressed(j) = C(k);
#            elseif (done)
#                break;
#            end
#        end
#    end
#end
