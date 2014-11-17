1;

function [Y, fs, bps] = loadWav(name)
    name = ["../wav/" name ".wav"];
    [Y, fs, bps] = wavread(name);
end

function writeWav(Y, name)
    wavwrite(Y, ["../wav/" name "_COMPRESSED.wav"]);
    ["Wav file written with name: " name "_COMPRESSED.wav"]
end
