
% Purpose : Script to synthesize for a given utterance (EHMM label)

clear all; close all; clc;

% Step - 0 : Load configuration variables
config

% Step - 1 : Select units from the database for each of the target units
ps_tic = tic;
[pre_selunits_list] = pre_selection(lab_path,fname,ctl_file);
fprintf('Time taken for Pre-selection algorithm %f seconds... \n',toc(ps_tic));

% Step - 2 : Viterbi for best unit selection
vit_tic = tic;
[final_units_list] = viterbi_uss(pre_selunits_list,param_path,ext,K); 
fprintf('Time taken for Viterbi algorithm %f seconds... \n',toc(vit_tic));


%% Step - 3 : WSOLA
%%% final_units_list = [1:88];
sola_tic = tic;
[y,y_psola] = sola(final_units_list,wav_segpath);
fprintf('Time taken for SOLA algorithm %f seconds... \n',toc(sola_tic));


%% Step - 4 : Parametric USS
% config
% puss_tic = tic;
% [y_puss,y_puss_mlpg] = parametric_uss(final_units_list,units_path,spssynthdir,fname);
% fprintf('Time taken for PUSS algorithm %f seconds... \n',toc(puss_tic));
% system(['rm', ' ', 'temp*'])

%ax1 = subplot(211); plot(y); axis tight;
%ax2 = subplot(212); plot(y_psola); axis tight;
%linkaxes([ax1 ax2], 'x');


% % Play wavefile
fprintf('Playing DUMB concatention... \n');
fs  = 48000; soundsc(y,fs); pause(ceil(length(y)/fs));

fprintf('Playing PSOLA concatention... \n');
fs  = 48000; soundsc(y_psola,fs); pause(ceil(length(y)/fs));

% % Play wavefile
% fprintf('Playing parametric synthesis concatention... \n');
% fs  = 48000; soundsc(y_puss,fs);pause(ceil(length(y_puss)/fs));
% 
% % Play wavefile
% fprintf('Playing MLPG parametric synthesis concatention... \n');
% fs  = 48000; soundsc(y_puss_mlpg,fs);



