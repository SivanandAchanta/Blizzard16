function [y,y_psola] = sola(units_list,wav_segpath)

zstr_full   = 'u_0000000';

for j = 2:length(units_list)
    
    prev_uid = units_list(j-1);
    zstr     = zstr_full(1:end-length(num2str(prev_uid)));
    prev_uid = strcat(zstr,num2str(prev_uid));
    prev_seg = audioread(strcat(wav_segpath,prev_uid,'.wav'));
    
    curr_uid = units_list(j);
    zstr     = zstr_full(1:end-length(num2str(curr_uid)));
    curr_uid = strcat(zstr,num2str(curr_uid));
    [curr_seg,fs] = audioread(strcat(wav_segpath,curr_uid,'.wav'));
    
    if j == 2
        y = prev_seg;
    end
    
    y = [y(:);curr_seg(:)];
    
end


[zfSig, gci, winLength]=epochExtract(y,fs);

gci(gci<=(2*(fs/1000))) = [];

gcisig      = zeros(length(y),1);
gcisig(gci-(2*(fs/1000))) = 1;

% ax1 = subplot(311); plot(y); axis tight;
% ax2 = subplot(312); plot(zfSig); axis tight;
% ax3 = subplot(313); plot(gcisig); axis tight;
% linkaxes([ax1 ax2 ax3], 'x');
% pause
%y_psola = zeros(size(y));
y = [];

for j = 2:length(units_list)
    
    
    prev_uid = units_list(j-1);
    zstr     = zstr_full(1:end-length(num2str(prev_uid)));
    prev_uid = strcat(zstr,num2str(prev_uid));
    prev_seg = audioread(strcat(wav_segpath,prev_uid,'.wav'));
    
    curr_uid = units_list(j);
    zstr     = zstr_full(1:end-length(num2str(curr_uid)));
    curr_uid = strcat(zstr,num2str(curr_uid));
    [curr_seg,fs] = audioread(strcat(wav_segpath,curr_uid,'.wav'));
    
    if j == 2
        y = prev_seg;
        y_psola = prev_seg;
    end
    
    %     ax1 = subplot(321); plot(y); axis tight;
    %     ax2 = subplot(323); plot(zfSig(1:length(y))); axis tight;
    %     ax3 = subplot(325); plot(gcisig(1:length(y))); axis tight;
    %
    %     ax4 = subplot(322); plot(curr_seg); axis tight;
    %     ax5 = subplot(324); plot(zfSig(length(y)+1:length(y)+length(curr_seg))); axis tight;
    %     ax6 = subplot(326); plot(gcisig(length(y)+1:length(y)+length(curr_seg))); axis tight;
    %
    %     pause
    
    
    
    bix = find(gcisig(length(y)+1:length(y)+length(curr_seg)),1,'first');
    lix = find(gcisig(length(y)+1:length(y)+length(curr_seg)),1,'last');
    
    if isempty(bix)
        bix = 1;
    end
    
    if isempty(lix) || (bix == lix)
        lix = length(curr_seg);
    end
    
    y = [y(:);curr_seg(:)];
    y_psola = [y_psola;curr_seg(bix:lix)];
    
end

end