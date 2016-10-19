function [] = make_catalogue(lab_path,ctl_file)

% Purpose: To prepare catalogue file for dumping units

% Inputs:
% lab_path     - path for EHMM label files
% ctl_file     - path for catelogue file to be written

% Outputs:
% Output Catalougue File Description
% Catelogue file has 5 fields :
% Field 1 : Name of the utterance
% Field 2 : Unit ID (A unique identity for each unit in the trianing data)
% Field 3 : Start time of the unit (in seconds)
% Field 4 : End time of the unit (in seconds)
% Field 5 : Penta-phone context (each phone seperated by '-' symbol ) (pp - p - c - n - nn)

%clear all; close all; clc;

%lab_path    = '../../../Blizzard_Test/Hindi/data/train/lab/';
%ctl_file    = '../../etc/ctl_bs8.txt';

cnt         = 0;
zstr_full   = 'u_0000000';

fid         = fopen(ctl_file,'w');

files       = dir(strcat(lab_path,'*.lab'));

for i = 1:length(files)
    
    [fname,tok] = strtok(files(i).name,'.');
    fprintf('Processing %s for catalogue file ...\n',fname);
    
    fidr    = fopen(strcat(lab_path,files(i).name),'r');
    fgetl(fidr);
    M       = textscan(fidr,'%f %d %s \n');
    et_vec  = M{1};
    phns    = M{3};
    fclose(fidr);
    
    st = 0;
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
        
        cnt      = cnt + 1;
        zstr     = zstr_full(1:end-length(num2str(cnt)));
        uid      = strcat(zstr,num2str(cnt));
        
        fprintf(fid,'%s %s %f %f %s \n',fname,uid,st,et,pentaphn);
        st = et;
    end
    
end

fclose(fid);
