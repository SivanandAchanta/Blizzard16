function [] = chunk_units(ctl_file,param_inpath,param_outpath)

% Purpose : To chunk into units for later processing in USS

% Inputs
% ctl_file      - path for catalogue file
% param_inpath  - path for the parameters to be sliced
% param_outpath - path for the sliced parameters/segments to be dumped

% clear all; close all; clc;

%ctl_file          = '../../etc/ctl.txt';
%param_inpath      = '../../../Blizzard_Test/Hindi/wav/';
%param_outpath     = '../../units/wav_segs/';

mkdir(param_outpath);

fs      = 48000;
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s %s %f %f %s \n');
fname   = M{1};
units   = M{2};
st      = M{3};
et      = M{4};
fclose(fidr);

s = gcp('nocreate');
if isempty(s)
    parpool
end

parfor i = 1:length(units)
    
    fprintf('Processing %s file for chunking to units ...\n',fname{i});
    
    [y] = audioread(strcat(param_inpath,fname{i},'.wav'),[floor(st(i)*fs+1) floor(et(i)*fs)]);
    
    %     soundsc(y,fs)
    %     pause
    
    
    wavname = strcat(param_outpath,units{i},'.wav');
    audiowrite(wavname,y,fs);
    
end

delete(gcp('nocreate'))



