#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 12:14:59 2016

@author: Sivanand Achanta
"""

import numpy as np
import scipy.io
from configparser import ConfigParser

# Match Target Unit in Catalogue
def match_TGT2CTL(cp, pp_db):
    res = np.sum(np.bitwise_xor(cp, pp_db), axis = 1)
    ix = np.where(res == 0)[0]

    return(ix)

def match_TGT2CTLNum(cp, pp_db):
    res = np.sum(np.bitwise_xor(cp, pp_db), axis = 1)
    ix = np.where(res <= 10)[0]

    return(ix)

# Match Target Unit in Catalogue
def match_pp2vow(ix1, ix2):
    ix_f = np.where(np.in1d(ix1, ix2))[0]
    return(ix_f)

def select_Units(M, parser):

    minnp = parser['ints'].getint('minnp') # minimum number of phones to match
    maxnp = parser['ints'].getint('maxnp') # maximum number of phones to match
    verbose_flag = parser['flags'].getboolean('verbose_flag')

    l = []
    l1 = []
    l2 = []

    ctlfile = '../../etc/catalogue.mat'
    mat = scipy.io.loadmat(ctlfile)
    data = mat['data']
    data = data.astype('uint8')

    np = 46
    nv = 20
    npos = 11
    nstress = 6
    num_feats = 37

    db_pp = data[:, 0:5*np]
    db_vow = data[:, 5*np:5*np+nv]
    db_pos = data[:, 5*np+nv:5*np+nv+3*npos]
    db_stress = data[:,5*np+nv+3*npos:5*np+nv+3*npos+nstress]
    db_numfeats = data[:,5*np+nv+3*npos+nstress:5*np+nv+3*npos+nstress+num_feats]


    db_pl4 = db_pp[:, 0:4*np]
    db_pr4 = db_pp[:, np:5*np]
    #db_pl3 = db_pp[:, 0:3*np]
    db_pc3 = db_pp[:, np:4*np]
    #db_pr3 = db_pp[:, 2*np:5*np]
    db_pl2 = db_pp[:, 1*np:3*np]
    db_pr2 = db_pp[:, 2*np:4*np]
    db_pc1 = db_pp[:, 2*np:3*np]

    M = M.astype('uint8')
    sh = M.shape
    M = M[:, :sh[1]-2]


    # Match the Penta-Phones and Get the List of Matched Catalougue Units
    for i in range(sh[0]):
        cp = M[i, 0:5*np]
        ix = match_TGT2CTL(cp,db_pp)

        cp_vow = M[i, 5*np:5*np+nv]
        ix_vow = match_TGT2CTL(cp_vow,db_vow)

        cp_pos = M[i, 5*np+nv:5*np+nv+3*npos]
        ix_pos = match_TGT2CTL(cp_pos,db_pos)

        cp_stress = M[i, 5*np+nv+3*npos:5*np+nv+3*npos+nstress]
        ix_stress = match_TGT2CTL(cp_stress,db_stress)

        cp_num = M[i, 5*np+nv+3*npos+nstress:5*np+nv+3*npos+nstress+num_feats]
        ix_num = match_TGT2CTLNum(cp_num,db_numfeats)

        if len(ix) < minnp:
            if verbose_flag: print('Backoff to stage - 1')
            cp = M[i, 0:4*np]
            ix = match_TGT2CTL(cp,db_pl4)

            if len(ix) < minnp:
                if verbose_flag: print('Backoff to stage - 2')
                cp = M[i, np:5*np]
                ix = match_TGT2CTL(cp,db_pr4)

                if len(ix) < minnp:
                    if verbose_flag: print('Backoff to stage - 3')
                    cp = M[i, np:4*np]
                    ix = match_TGT2CTL(cp,db_pc3)

                    if len(ix) < minnp:
                        if verbose_flag: print('Backoff to stage - 6')
                        cp = M[i, 1*np:3*np]
                        ix = match_TGT2CTL(cp,db_pl2)

                        if len(ix) < minnp:
                            if verbose_flag: print('Backoff to stage - 7')
                            cp = M[i, 2*np:4*np]
                            ix = match_TGT2CTL(cp,db_pr2)

                            if len(ix) < minnp:
                                if verbose_flag: print('Backoff to stage - 8')
                                cp = M[i, 2*np:3*np]
                                ix = match_TGT2CTL(cp,db_pc1)




        ix_v = match_pp2vow(ix, ix_vow)
        if len(ix_v) == 0:
            ix_f = ix
        else:
            ix_f = ix[ix_v]

        ix_p = match_pp2vow(ix_f, ix_pos)
        if len(ix_p) == 0:
            ix_f = ix_f
        else:
            ix_f = ix_f[ix_p]

        ix_s = match_pp2vow(ix_f, ix_stress)
        if len(ix_s) == 0:
            ix_f = ix_f
        else:
            ix_f = ix_f[ix_s]

        ix_n = match_pp2vow(ix_f, ix_num)
        if len(ix_n) == 0:
            ix_f = ix_f
        else:
            ix_f = ix_f[ix_n]

        #if len(ix) > maxnp:
        #    ix = ix[:maxnp]

        l.append(ix_f)
    return(l)


# debug select units

#parser = ConfigParser()
#parser.read('config_uss.ini')

#M = np.loadtxt('../../../data/train/text_feats_uk/hts_numeric/AMidsummerNightsDream_000_000.tfeat')
#M = np.loadtxt('../../../data/test/text_feats_uk/hts_numeric/GoldilocksAndTheThreeBears_000_000.tfeat')
#[l,l_vow] = select_Units(M, parser)



