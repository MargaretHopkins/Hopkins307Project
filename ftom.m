function [midi] = ftom(freq)
midi=12*log2(freq/440)+69;
