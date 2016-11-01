#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 13:07:21 2016

@author: Sivanand Achanta
"""

import readFile
import preSelection_htsnumericfeats
import ussViterbi
import unitsConcat
import time
import os
from os import listdir
from os.path import isfile, join
from configparser import ConfigParser
import sola
import numpy as np
import scipy
from scipy.io import wavfile
import subprocess

def main():
    """ main """

    # Step 0: Parse the config file
    parser = ConfigParser()
    parser.read('config_uss.ini')

    # Step 1: Set Directory Paths and Names
    testlab_path = parser['paths'].get('testlab_path')
    testlab_path1 = parser['paths'].get('testlab_path1')
    files = [f for f in listdir(testlab_path1) if isfile(join(testlab_path1, f))]
    lab_ext = parser['strs'].get('lab_ext')
    num_synthfiles = parser['ints'].getint('num_synthfiles')
    p_mgc = parser['floats'].getfloat('p_mgc')
    p_f0 = parser['floats'].getfloat('p_f0')
    K = parser['ints'].getint('K')
    minnp = parser['ints'].getint('minnp') # minimum number of phones to match
    maxnp = parser['ints'].getint('maxnp') # maximum number of phones to match

    synth_path = parser['paths'].get('synth_path')
    synth_path = synth_path + 'synth_mgcc' + str(p_mgc) + '_f0c' + str(p_f0) + '_minnp' + str(minnp) + '_maxnp' + str(maxnp) + '_K' + str(K) + '/'

    # Step 2: Create the synthesis directory
    if not os.path.exists(synth_path):
        os.makedirs(synth_path)


    cnt = 0
    # Step 3: Synthesize each lab file
    for f in files:

        print('\n' + 'Synthesizing ' + f)
        [fname, ext] = f.split('.')

        # Step 3.1: Read Test HTS Label File or a Normal Sequece of Phones from a text file
        M = np.loadtxt(testlab_path + fname + lab_ext)

        # Step 3.2: Select Units from the Database that Match the Target Specification
        start_time_ps = time.time()
        units_ps = preSelection_htsnumericfeats.select_Units(M, parser)
        print("Time taken for preSelection module %s seconds ---" % (time.time() - start_time_ps))

        # Step 3.3: Do Viterbi
        start_time_vit = time.time()
        units_vit = ussViterbi.doViterbi(units_ps, parser)
        print("Time taken for Viterbi module %s seconds ---" % (time.time() - start_time_vit))
        np.save('../../matlab_codes/Voice_Synthesis/units_vit.npy', units_vit)

        # Step 3.4: Dumb Concatenate Units
        #start_time_vit = time.time()
        #yb = unitsConcat.synthDumb(units_vit, synth_path, (fname + '_py'), parser)
        #print("Time taken for Synthesis module %s seconds ---" % (time.time() - start_time_vit))

        # Step 3.5: SOLA to Concatenate Units
        # start_time_vit = time.time()
        # unitsConcat.synthSola(units_vit, synth_path, (fname + '_py'), parser)
        # print("Time taken for Synthesis module %s seconds ---" % (time.time() - start_time_vit))

        # Step 3.6: PSOLA using ZFF in matlab
        synth_fname = synth_path + fname
        os.system('/media/sivanand/HDD_OCT16/Work/blizzard16/iiith_uss_blz16_uk/matlab_codes/Voice_Synthesis/call_matlab_psola_htsnumeric.sh' + ' ' + synth_fname)

        cnt = cnt + 1

        if cnt == num_synthfiles:
            break


if __name__ == "__main__":
    main()
