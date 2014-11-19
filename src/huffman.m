1;

function encoding = huffmanEncoding(symbols, weights)
    N = length(symbols);
    encoded = cell(N, 1);
    for i = 1:N
        encoded{i} = struct("symbol", symbols(i), "weight", weights(i), "isLeaf", true);
    end

    while length(encoded) > 2
        [j, k] = getTwoWithSmallestWeight(encoded);
        newWeight = encoded{j}.weight + encoded{k}.weight;
        encoded{j} = struct("weight", newWeight, "left", encoded{j}, "right", encoded{k});
        encoded(k, :) = [];
    end

    newWeight = encoded{1}.weight + encoded{2}.weight;
    encoded{1} = struct("weight", newWeight, "left", encoded(1), "right", encoded(2));

    encoding = parseEncodingFromTree(encoded{1}, N);
end

function sortedDict = parseEncodingFromTree(encoded, N)
    encoding = cell(N, 1);
    encoding = treeParser(encoding, encoded, [], 1);
    sortedIndexes = getSortedIndexes(encoding);
    sortedDict = sortDict(encoding, sortedIndexes);
end

function [encoding, next] = treeParser(encoding, tree, bitstring, next)
    if isfield(tree.left, "isLeaf")
        encoding{next} = [tree.left.symbol, [bitstring, 0]];
        next += 1;
    else
        [encoding, next] = treeParser(encoding, tree.left, [bitstring, 0], next);
    end

    if isfield(tree.right, "isLeaf")
        encoding{next} = [tree.right.symbol, [bitstring, 1]];
        next += 1;
    else
        [encoding, next] = treeParser(encoding, tree.right, [bitstring, 1], next);
    end
end

function [first, second] = getTwoWithSmallestWeight(encoded)
    first = 1;
    second = 2;
    for i = 3:length(encoded)
        if (encoded{i}.weight < encoded{first}.weight)
            if (encoded{first}.weight < encoded{second}.weight)
                [first, second] = swap(first, second);
            end
            first = i;
        elseif (encoded{i}.weight < encoded{second}.weight)
            second = i;
        end
    end
end

function [b, a] = swap(a, b)
    c = b;
    b = a;
    a = c;
end

function sortedIndexes = getSortedIndexes(cellArr)
    sortedIndexes = cellfun(@(x) x.symbol, cellArr);
    [_, sortedIndexes] = sort(sortedIndexes);
end

function sortedDict = sortDict(encoding, sortedIndexes)
    sortedDict = {};
    for j = 1:length(sortedIndexes)
        sortedDict{j} = encoding{sortedIndexes(j)}.bitstring;
    end
end
