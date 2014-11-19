1;

function [Y, fileSize] = loadWav(name)
    name = ["./wav/" name ".wav"];
    [Y, fs, bps] = wavread(name);
    [info, err, msg] = lstat(name);
    fileSize = info.size * 8;
end

function writeWav(Y, name)
    wavwrite(Y, ["./wav/" name "_COMPRESSED.wav"]);
    ["Wav file written with name: " name "_COMPRESSED.wav"]
end
