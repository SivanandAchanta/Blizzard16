function [y_puss,y_puss_mlpg] = parametric_uss(units_list,units_path,spssynthdir,fname)

% Purpose: Synthesize from parametric form of units

zstr_full   = 'u_000000';

mgc_path    = strcat(units_path,'mgc/');
lf0_path    = strcat(units_path,'lf0/');
bap_path    = strcat(units_path,'bap/');

Y_mgc       = [];
Y_lf0       = [];
Y_bap       = [];

for j = 1:length(units_list)
    
    
    curr_uid = units_list(j);
    zstr     = zstr_full(1:end-length(num2str(curr_uid)));
    curr_uid = strcat(zstr,num2str(curr_uid));
    
    mgc = dlmread(strcat(mgc_path,curr_uid,'.mgc'));
    lf0 = dlmread(strcat(lf0_path,curr_uid,'.lf0'));
    bap = dlmread(strcat(bap_path,curr_uid,'.bap'));
    
    
    Y_mgc = [Y_mgc mgc];
    Y_lf0 = [Y_lf0 lf0];
    Y_bap = [Y_bap bap];
    
    
end


% size(Y_mgc)
% size(Y_lf0)
% size(Y_bap)

Y_mgc = Y_mgc';
Y_lf0 = Y_lf0';
Y_bap = Y_bap';
vuv   = zeros(size(Y_lf0,1),1);
vuv(Y_lf0(:,1) > 0) = 1;

% plot(vuv);
% pause

addpath('am_testing/')
addpath('STRAIGHTV40/');
datadir = 'stats_am/';

acousticparam_config

[psp,psp_mlpg] = gen_sp(Y_mgc,mgcdim,vo,X2X,MGC2SP,FREQWARP,GAMMA,MGCORDER,lenfac,nfftby2,0);
[pap,pap_mlpg] = gen_ap(Y_bap,bapdim,nfftby2,vo,outvec_bap);
[plf0_mlpg]    = gen_lf0(Y_lf0,std_v,vuv);

f0             = exp(Y_lf0(:,1))';
%plot(f0)
%surf(10*log10(psp),'edgecolor','none'); view(0,90); axis tight;
%surf((pap),'edgecolor','none'); view(0,90); axis tight;
% fs

% size(f0)
% size(pap)
% size(psp)

y_puss = synth_st(f0',psp,pap,fs,prm,spssynthdir,fname,'_mgcf0bap.wav');

%pause

f0_mlpg             = exp(plf0_mlpg(:,1))';
f0_mlpg             = f0;
% plot(f0_mlpg);
% pause
% surf(10*log10(psp),'edgecolor','none'); view(0,90); axis tight;
% pause
% surf((pap),'edgecolor','none'); view(0,90); axis tight;
% pause

%size(f0_mlpg)
%size(pap_mlpg)
%size(psp_mlpg)
y_puss_mlpg = synth_st(f0_mlpg',psp_mlpg,pap_mlpg,fs,prm,spssynthdir,fname,'_mgcf0bap_mlpg.wav');

end