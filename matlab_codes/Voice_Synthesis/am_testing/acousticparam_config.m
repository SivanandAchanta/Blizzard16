addpath('/Users/sivanandachanta/Desktop/Work/USS/Code/Voice_Synthesis/STRAIGHTV40/'); % STRAIGHT path
sptk_cmd % load sptk commands

%% synthesis params
%% STRAIGHT Params
fs          = 48000;
frshift_s   = round(0.005*fs) ; % frame shift in samples
UPPERF0     = 580;
LOWERF0     = 60;

frshiftms                   = round((frshift_s/fs)*1000); % frameshift in ms
prm.F0frameUpdateInterval   = frshiftms;
prm.spectralUpdateInterval  = frshiftms;
prm.F0searchUpperBound      = UPPERF0;
prm.F0searchLowerBound      = LOWERF0;

%% Speech Analysis conditions
SAMPFREQ    = fs;   % Sampling frequency (48kHz)
FRAMESHIFT  = round(0.005*SAMPFREQ); % Frame shift in point (240 = 48000 * 0.005)
FREQWARP    = 0.55;   % frequency warping factor
GAMMA       = 0;      % pole/zero weight for mel-generalized cepstral (MGC) analysis
MGCORDER    = 49;   % order of MGC analysis
LNGAIN      = 1;     % use logarithmic gain rather than linear gain
mgcdim      = MGCORDER+1;
bapdim      = 26;
lenfac      = 2048;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read test data
nfft    = 2048;
nfftby2 = round(nfft/2 + 1);

outvec  = [1:235];
invec   = [1:347];
mvnivec = [303:339 343:347];
din     = length(invec);

intmvnf     = 1;
intmmnf     = 0;
outtmvnf    = 1;
outtmmnf    = 0;

% load mvn of input
% load(strcat(datadir,'mvni.mat'))

% load maxmin of output
load(strcat(datadir,'mvno.mat'))
load(strcat(datadir,'mvno_voiced.mat')) % for voiced f0 variances
mn_bmlpg_flag = 0;
load(strcat(datadir,'maxmino.mat'))

% GV variables
gv_flag = 0;
if gv_flag
    load(strcat(datadir,'uv_msdv.mat'));
    mu_gv = uv_m(outvec);
    p_gv = 1./uv_sdv(outvec);
    mu_gv_sdv = sqrt(mu_gv);
end


outvec_bap = 151:228;