# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 11:15:12 2016

@author: Sivanand Achanta
"""
import csv

# Read EHMM Label file
def EHMMLab(file_path,fname):

    file = file_path + fname;
    fidr = open(file,'r')
    fidr.readline()
    ehmm_obj = csv.reader(fidr, delimiter=' ', )

    et = []
    phn = []

    for col in ehmm_obj:
        et.append(float(col[0]))
        phn.append(col[2])

    return(et,phn)

def CTLFile(file_path,fname,colno):

    file = file_path + fname;
    fidr = open(file,'r')
    ctl_obj = csv.reader(fidr, delimiter=' ', )

    all_Phns = []

    for col in ctl_obj:
        all_Phns.append(col[colno])

    return(all_Phns)


def BOFile(file_path,fname,colno):

    file = file_path + fname;
    fidr = open(file,'r')
    ctl_obj = csv.reader(fidr, delimiter=' ', )

    all_Phns = []

    for col in ctl_obj:
        all_Phns.append(col[colno])

    return(all_Phns)