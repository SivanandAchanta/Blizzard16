

close all;
clear all;

addpath('./featfrmZFR');
addpath('./featfrmHE');

wav = wavread('Spcm.wav');

[zfSig,vnv,vgci,vpc,st]=epochStrengthExtract(wav,fs);








