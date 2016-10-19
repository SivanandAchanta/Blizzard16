ctl_file = '../../etc/ctl_bs1.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs1   = M{1};
fclose(fidr);

ctl_file = '../../etc/ctl_bs2.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs2   = M{1};
fclose(fidr);

ctl_file = '../../etc/ctl_bs3.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs3   = M{1};
fclose(fidr);


ctl_file = '../../etc/ctl_bs6.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs6   = M{1};
fclose(fidr);


ctl_file = '../../etc/ctl_bs7.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs7   = M{1};
fclose(fidr);

ctl_file = '../../etc/ctl_bs8.txt';
fidr    = fopen(ctl_file,'r');
M       = textscan(fidr,'%s \n');
pphns_ctl_bs8   = M{1};
fclose(fidr);
