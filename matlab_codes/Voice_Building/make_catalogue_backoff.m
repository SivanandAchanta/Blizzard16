function [] = make_catalogue_backoff(lab_path,ctl_file,bss)

% Purpose: To prepare catalogue file for dumping units

% Inputs:
% lab_path     - path for EHMM label files
% ctl_file     - path for catelogue file to be written
% bss          - backoffstage string

% Outputs:
% Output Catalougue File Description
% Catelogue file has 5 fields :
% Field 1 : backoff-phone context (each phone seperated by '-' symbol ) (pp - p - c - n - nn)


fid         = fopen(strcat(ctl_file,'_',bss,'.txt'),'w');
files       = dir(strcat(lab_path,'*.lab'));

for i = 1:length(files)
    
    [fname,tok] = strtok(files(i).name,'.');
    fprintf('Processing %s for catalogue file ...\n',fname);
    
    fidr    = fopen(strcat(lab_path,files(i).name),'r');
    fgetl(fidr);
    M       = textscan(fidr,'%f %d %s \n');
    phns    = M{3};
    fclose(fidr);
    
    
    for j = 1:length(phns)
        
        
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
        
        if strcmp(bss,'bs1')
            pentaphn = [ p1 '-' p2 '-' p3 '-' p4 ];   
        elseif strcmp(bss,'bs2')
            pentaphn = [ p2 '-' p3 '-' p4 '-' p5 ];   
        elseif strcmp(bss,'bs3')
            pentaphn = [ p2 '-' p3 '-' p4 ];   
        elseif strcmp(bss,'bs4')
            pentaphn = [ p1 '-'  p2 '-' p3 ];   
        elseif strcmp(bss,'bs5')
            pentaphn = [ p3 '-' p4 '-' p5 ];   
        elseif strcmp(bss,'bs6')
            pentaphn = [ p2 '-' p3 ];   
        elseif strcmp(bss,'bs7')
            pentaphn = [ p3 '-' p4 ];   
        elseif strcmp(bss,'bs8')
            pentaphn = [ p3 ];   
        end
        
        fprintf(fid,'%s \n',pentaphn);
        
    end
    
end

fclose(fid);
