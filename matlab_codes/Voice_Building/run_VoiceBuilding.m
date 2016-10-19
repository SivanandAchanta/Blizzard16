clear all; close all; clc;

% Purpose : Run script for Voice Building

%% Step - 1: Make Catalogue
lab_path    = '../../../data/train/text_feats_us/ehmm_phnlab/';
ctl_file    = '../../etc/ctl_bs1.txt';

make_catalogue(lab_path,ctl_file)

%% Step - 2: Chunk Wavs into wav segments
ctl_file          = '../../etc/ctl.txt';
wav_inpath      = '../../../data/full/wav/';
wavseg_outpath     = '../../units/wav_segs/';

chunk_units(ctl_file,wav_inpath,wavseg_outpath)


%% Step - 3: Chunk Params
ctl_file          = '../../etc/ctl.txt';
param_inpath      = '../../../data/train/audio_feats_48KHz/cmp/';
param_name        = 'mgc'; % three choices ('mgc','f0','lf0')
paramchunk_outpath     = strcat('../../units/',param_name,'/');

chunk_params(ctl_file,param_inpath,param_name,paramchunk_outpath)

%% Step - 4: Make Backoff files
lab_path    = '../../../data/train/text_feats_us/ehmm_phnlab/';
ctl_file    = '../../etc/ctl';
bss         = 'bs8'; 
make_catalogue_backoff(lab_path,ctl_file,bss)