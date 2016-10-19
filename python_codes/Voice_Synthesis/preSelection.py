# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 12:51:18 2016

@author: Sivanand Achanta
"""

import readFile

etc_path        = '../../etc/';
ctl_fname       = 'ctl.txt';
ctl_bs1_fname   = 'ctl_bs1.txt';
ctl_bs2_fname   = 'ctl_bs2.txt';
ctl_bs3_fname   = 'ctl_bs3.txt';
ctl_bs6_fname   = 'ctl_bs6.txt';
ctl_bs7_fname   = 'ctl_bs7.txt';
ctl_bs8_fname   = 'ctl_bs8.txt';

# Read Catalogue File
all_phns =  readFile.CTLFile(etc_path,ctl_fname,4)

# Read BackOFF Files
all_phns_bs1 = readFile.BOFile(etc_path,ctl_bs1_fname,0)
all_phns_bs2 = readFile.BOFile(etc_path,ctl_bs2_fname,0)
all_phns_bs3 = readFile.BOFile(etc_path,ctl_bs3_fname,0)
all_phns_bs6 = readFile.BOFile(etc_path,ctl_bs6_fname,0)
all_phns_bs7 = readFile.BOFile(etc_path,ctl_bs7_fname,0)
all_phns_bs8 = readFile.BOFile(etc_path,ctl_bs8_fname,0)


# Match Target Unit in Catalogue
def match_TGT2CTL(all_units,tgt_unit):
    ix = [];
    for i, j in enumerate(all_units):
        if j == tgt_unit:
            ix.append(i+1)

    return(ix)


def select_Units(phns_list, parser):

    minnp = parser['ints'].getint('minnp') # minimum number of phones to match
    maxnp = parser['ints'].getint('maxnp') # maximum number of phones to match
    verbose_flag = parser['flags'].getboolean('verbose_flag')

    l = [];

    # Match the Penta-Phones and Get the List of Matched Catalougue Units
    for i in range(2,len(phns_list)-2):
        pphn = phns_list[i-2] + '-' + phns_list[i-1] + '-' + phns_list[i] + '-' + phns_list[i+1] + '-' + phns_list[i+2];
        ix = match_TGT2CTL(all_phns,pphn)

        if len(ix) < minnp:
            if verbose_flag: print('Backoff to stage - 1')
            pphn = phns_list[i-2] + '-' + phns_list[i-1] + '-' + phns_list[i] + '-' + phns_list[i+1];
            ix = match_TGT2CTL(all_phns_bs1,pphn)

            if len(ix) < minnp:
                if verbose_flag: print('Backoff to stage - 2')
                pphn = phns_list[i-1] + '-' + phns_list[i] + '-' + phns_list[i+1] + '-' + phns_list[i+2];
                ix = match_TGT2CTL(all_phns_bs2,pphn)

                if len(ix) < minnp:
                    if verbose_flag: print('Backoff to stage - 3')
                    pphn = phns_list[i-1] + '-' + phns_list[i] + '-' + phns_list[i+1];
                    ix = match_TGT2CTL(all_phns_bs3,pphn)

                    if len(ix) < minnp:
                        if verbose_flag: print('Backoff to stage - 6')
                        pphn = phns_list[i-1] + '-' + phns_list[i];
                        ix = match_TGT2CTL(all_phns_bs6,pphn)

                        if len(ix) < minnp:
                            if verbose_flag: print('Backoff to stage - 7')
                            pphn = phns_list[i] + '-' + phns_list[i+1];
                            ix = match_TGT2CTL(all_phns_bs7,pphn)

                            if len(ix) < minnp:
                                if verbose_flag: print('Backoff to stage - 8')
                                pphn = phns_list[i];
                                ix = match_TGT2CTL(all_phns_bs8,pphn)


        if len(ix) > maxnp:
            ix = ix[:maxnp]

        l.append(ix)
    return(l);
