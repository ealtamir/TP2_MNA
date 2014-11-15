1;

function result = fastFourierTransformDivAndConq(Y)
    result = [];
    X = addPadding(Y);
    N = size(X)(1);

    even = @(x) 2 * x;
    odd = @(x) 2 * x + 1;

    for k = 0:N-1
        m = e^(-i*2*pi*k/N);
        range = N / 2;
        coefficient = divide(X, k, range, even) + m * divide(X, k, range, odd);
        result = [result; coefficient];
    end
end

function val = divide(X, k, N, step)
    if (N == 2)
        # Sum by 1 because octave indexes start in 1, not 0.
        val = X(step(0) + 1) + X(step(1) + 1) * e^(-i*pi*k);
    else
        # Keep dividing
        even = @(x) step(2 * x);
        odd = @(x) step(2 * x + 1);
        m = e^(-i*2*pi*k/N);
        range = N / 2;
        val = divide(X, k, range, even) + m * divide(X, k, range, odd);
    end
end

function X = addPadding(Y)
    N = size(Y);
    if isPowerOf2(N)
        X = Y;
    else
        n = closestPowerOf2(N);
        paddingSize = n - N;
        X = [Y; zeros(paddingSize, 1)];
    end
end

function result = isPowerOf2(n)
    result = n != 0 && bitand(n, n - 1) == 0;
end

function p = closestPowerOf2(n)
    p = 1;
    for i = 1:64
        p = p * 2;
        if (p >= n)
            break;
        end
    end
end
