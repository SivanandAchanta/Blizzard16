# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 22:15:26 2016

@author: Sivanand Achanta
"""

import numpy as np
import scipy
from scipy.io import wavfile


def synthDumb(units,synth_path, fname, parser):

    wav_segpath = parser['paths'].get('wav_segpath')
    zstr_full = parser['strs'].get('zstr_full')

    for i in range(len(units)):
            uname  = units[i]
            uname  = zstr_full[:len(zstr_full)-len(str(uname))] + str(uname)
            [fs,y] = scipy.io.wavfile.read(wav_segpath+uname+'.wav');

            if i == 0:
                yb = y;
            else:
                yb     = np.concatenate((yb,y),axis = 0);

    scipy.io.wavfile.write((synth_path + fname + '.wav'),fs,yb)