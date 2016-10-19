addpath('featfrmZFR/')

% for pre_selection (Step - 1)
lab_path = '../../../data/test/text_feats_us/ehmm_phnlab/';
fname    = 'TheEnormousTurnip_005_000';
ctl_file = '../../etc/ctl.txt';

% for viterbi_uss (Step - 2)
param_path  = '../../units/f0/';
ext         = '.f0';
K           = 3;

% for SOLA (Step - 3)
wav_segpath = '../../units/wav_segs/';

 
% for Parmetric USS (Sep - 4)
units_path  = '../../units/';
spssynthdir = '../../synth/';
mkdir(spssynthdir);
