function [pre_selunits_list] = pre_selection(lab_path,fname,ctl_file)

% Purpose : To select units from the data base given the new test sequence
% of units

% Inputs :
% lab_path     - path for EHMM label files
% fnmae        - name of the test file
% ctl_file     - path for catelogue file to be written

% Outputs :
% pre_selunits_list   - list of selected units for each target unit

% clear all; close all; clc;



%lab_path = '../../../Blizzard_Test/Hindi/data/test/lab/';
%fname    = 'text_01009';

%tic
%ctl_file = '../../etc/ctl.txt';


fidr        = fopen(ctl_file,'r');
M           = textscan(fidr,'%s %s %f %f %s \n');
% fname_ctl   = M{1};
% units_ctl   = M{2};
% st_ctl      = M{3};
% et_ctl      = M{4};
pphns_ctl   = M{5};
fclose(fidr);
%toc

%tic
backoff_files
%toc

fidr    = fopen(strcat(lab_path,fname,'.lab'),'r');
fgetl(fidr);
M       = textscan(fidr,'%f %d %s \n');
et_vec  = M{1};
phns    = M{3};
fclose(fidr);

verbose_flag = 0;
st           = 0;

for j = 1:length(phns)
    et = et_vec(j);
    
    if j == 1
        p1 = 'SIL'; p2 = 'SIL';
        p3 = phns{j};
        p4 = phns{j+1}; p5 = phns{j+2};
    elseif j == 2
        p1 = 'SIL'; p2 = phns{j-1};
        p3 = phns{j};
        p4 = phns{j+1}; p5 = phns{j+2};
    elseif j == length(phns)-1
        p1 = phns{j-2};p2 = phns{j-1};
        p3 = phns{j};
        p4 = phns{j+1}; p5 = 'SIL';
    elseif j == length(phns)
        p1 = phns{j-2};p2 = phns{j-1};
        p3 = phns{j};
        p4 = 'SIL'; p5 = 'SIL';
    else
        p1 = phns{j-2};p2 = phns{j-1};
        p3 = phns{j};
        p4 = phns{j+1};p5 = phns{j+2};
    end
    
    pentaphn = [ p1 '-' p2 '-' p3 '-' p4 '-' p5];
    
    u_idx = strcmp(pentaphn,pphns_ctl);
    u_idx = find(u_idx);
    
    if isempty(u_idx)
        pentaphn = [ p1 '-' p2 '-' p3 '-' p4 ];
        if verbose_flag; fprintf('Back-off to stage 1 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs1);
        u_idx = find(u_idx);
    end
   
    if isempty(u_idx)
        pentaphn = [ p2 '-' p3 '-' p4 '-' p5];
        if verbose_flag; fprintf('Back-off to stage 2 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs2);
        u_idx = find(u_idx);
    end
    
    if isempty(u_idx)
        pentaphn = [ p2 '-' p3 '-' p4];
        if verbose_flag; fprintf('Back-off to stage 3 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs3);
        u_idx = find(u_idx);
    end

    if isempty(u_idx)
        pentaphn = [p2 '-' p3];
        if verbose_flag; fprintf('Back-off to stage 6 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs6);
        u_idx = find(u_idx);
    end
    
    if isempty(u_idx)
        pentaphn = [p3 '-' p4];
        if verbose_flag; fprintf('Back-off to stage 7 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs7);
        u_idx = find(u_idx);
    end
    
    if isempty(u_idx)
        pentaphn = [p3];
        if verbose_flag; fprintf('Back-off to stage 8 ... \n'); end;
        u_idx = strcmp(pentaphn,pphns_ctl_bs8);
        u_idx = find(u_idx);
    end
    
    if isempty(u_idx)
        fprintf('Phone not found in any backoff !!! Check the pentaphone sequence ... \n');
        return
    end
    
    pre_selunits_list{j} = u_idx;
end




