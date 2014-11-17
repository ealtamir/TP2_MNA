1;

autoload("fastFourierTransformDivAndConq", "FFT.m");


function X = compressWav(Y, L=16)
    X = fft(Y);
    X = compress(X, L);
end

function X = compress(X, L)
    coefficients = truncate(X);
    C = calculateQuantization(coefficients, L);
    X = quantize(coefficients, C);
end

function X = truncate(X)
    truncate_length = ceil(length(X) / 2) + 1;
    X = X(1:truncate_length);
end

function C = calculateQuantization(X, L)
    minCoeff = min(X);
    maxCoeff = max(X);
    step = (maxCoeff - minCoeff) / L;
    C = [minCoeff];
    for i = 1:L-1
        C(i+1) = C(i) + step;
    end
    abs(C)
end

function compressed = quantize(coefficients, C)
    compressed = coefficients;
    for j = 1:length(coefficients)
        done = false;
        for k = 1:length(C)
            if (!done && compressed(j) <= C(k))
                done = true;
                compressed(j) = C(k);
            elseif (done)
                break;
            end
        end
    end
end
