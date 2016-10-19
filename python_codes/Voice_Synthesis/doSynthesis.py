# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 11:11:10 2016

@author: Sivanand Achanta
"""

import readFile
import preSelection
import ussViterbi
import unitsConcat
import time
import os
from os import listdir
from os.path import isfile, join
from configparser import ConfigParser


def main():
    """ main """

    # Step 0: Parse the config file
    parser = ConfigParser()
    parser.read('config_uss.ini')

    # Step 1: Set Directory Paths and Names
    testlab_path = parser['paths'].get('testlab_path')
    files = [f for f in listdir(testlab_path) if isfile(join(testlab_path, f))]
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

        # Step 3.1: Read Test EHMM Label File or a Normal Sequece of Phones from a text file
        [et, phns_list] = readFile.EHMMLab(testlab_path, (fname + lab_ext))
        phns_list = ['SIL'] + ['SIL'] + phns_list + ['SIL'] + ['SIL']


        # Step 3.2: Select Units from the Database that Match the Target Specification
        start_time_ps = time.time()
        units_ps = preSelection.select_Units(phns_list, parser)
        print("Time taken for preSelection module %s seconds ---" % (time.time() - start_time_ps))


        # Step 3.3: Do Viterbi
        start_time_vit = time.time()
        units_vit = ussViterbi.doViterbi(units_ps, parser)
        print("Time taken for Viterbi module %s seconds ---" % (time.time() - start_time_vit))


        # Step 3.4: PSOLA to Concatenate Units
        start_time_vit = time.time()
        unitsConcat.synthDumb(units_vit, synth_path, (fname + '_py'), parser)
        print("Time taken for Synthesis module %s seconds ---" % (time.time() - start_time_vit))

        cnt = cnt + 1

        if cnt == num_synthfiles:
            break


if __name__ == "__main__":
    main()
