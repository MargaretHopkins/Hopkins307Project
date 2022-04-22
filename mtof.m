function[freq] = mtof(midi)
freq = 440*2^((midi-69)/12);