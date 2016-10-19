function [] = chunk_params(ctl_file,param_inpath,param_name,param_outpath)

% Purpose : To chunk into units for later processing in USS

% Inputs
% ctl_file      - path for catalogue file
% param_inpath  - path for the parameters to be sliced
% param_name    - name of the acoustic parameter to be sliced (mgc/f0/lf0)
% param_outpath - path for the sliced parameters/segments to be dumped

% clear all; close all; clc;

% ctl_file          = '../../etc/ctl.txt';
% param_inpath      = '../../../Blizzard_Test/Hindi/data/train/comp_feats/';
% param_outpath     = '../../units/f0/';
mkdir(param_outpath);

mgcdim    = 50;
bapdim    = 26;
cmpdim    = 3*(mgcdim + 1 + bapdim);
fs        = 48000;
frShiftms = 5;
frShift   = (fs)*(frShiftms/1000);

fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s %s %f %f %s \n');
fclose(fidr);

fname   = M{1};
units   = M{2};
st      = M{3};
et      = M{4};

switch param_name
    case 'mgc'
        out_vec = [1:150];
    case 'lf0'
        out_vec = [151:153];
    case 'bap'
        out_vec = [154:231];
    case 'f0'
        out_vec = 151;
end

s = gcp('nocreate');
if isempty(s)
    parpool
end

parfor i = 1:length(units)
    
    fprintf('Processing %s file for chunking to units ...\n',fname{i});
    
    fid1      = fopen(strcat(param_inpath,fname{i},'.cmp'),'r','ieee-le');
    cmp       = fread(fid1,'float');
    fclose(fid1);
    
    nfr_cmp   = length(cmp(4:end))/cmpdim;
    A         = reshape(cmp(4:end),cmpdim,nfr_cmp);
    A         = A';
    
    bf        = floor((st(i)*fs)/frShift) + 1; % begin frame
    ef        = ceil((et(i)*fs)/frShift); % end frame
    
    %     bf
    %     ef
    
    T = A(bf:ef,out_vec);
    
    if strcmp(param_name,'f0')
        T  = exp(T);
    end
    
    if ef - bf == 0
        fprintf('There are zero frames in this unit %s \n',fname{i});
        T = zeros(1,length(out_vec));
    end
    
    
    
    
    %     plot(f0)
    %     pause
    
    dlmwrite(strcat(param_outpath,units{i},'.',param_name),T','delimiter',' ');
    
end

delete(gcp('nocreate'))