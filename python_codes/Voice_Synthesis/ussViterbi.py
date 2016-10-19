# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 15:45:23 2016

Purpose: Do a Viterbi on pre-selected units (search for optimal units)

Inputs:
[1] units_list           - List of Unit IDs from preSelection Module

Additional Inputs:
[1] param_path           - Path for spectral and f0 parameters
[2] ext                  - Extension for parameters (eg: .f0 for f0 params)
[3] K                    - Num. of frames to the either side of unit concatenation boundary (Ref[2])
[4] zstr_full            - Default string for unit-names (zero string)

Outputs:
[1] final_units_list     - Units Selected via Viterbi Search


Dependecies: Numpy

References:

[1] Hunt, A. J., and A. W. Black. "Unit selection in a concatenative speech synthesis system using a large speech database."
Proc. ICASSP, IEEE Computer Society, 1996.

[2] Lakkavalli, Vikram Ramesh, P. Arulmozhi, and A. G. Ramakrishnan. "Continuity metric for unit selection based text-to-speech synthesis."
Proc. SPCOM, IEEE, 2010.

@author: Sivanand Achanta
"""

# Import packages here
import numpy as np


# Compute joinCost for two successive units C(U_{j-1},U_{j})
def joinCost_f0(prev_unit_list, curr_unit_list, zstr_full, f0_param_path, f0_ext, K):

    '''
    Compute the join cost for the units

    Inputs:
    [1] prev_unit_list - List of units for previous target  (Np - number of units in this list)
    [2] curr_unit_list - List of units for current target unit (Nc - number of units in this list)

    Outputs:
    [1] D              - Distortion matrix (Nc x Np)

    '''

    s = (len(prev_unit_list),K)
    P = np.zeros(s)

    for i in range(len(prev_unit_list)):
        uname  = prev_unit_list[i]
        uname  = zstr_full[:len(zstr_full)-len(str(uname))] + str(uname)
        a      = np.loadtxt(f0_param_path+uname+f0_ext, delimiter=' ', ndmin=2);
        s      = a.shape;

        if s[1] >= K:
            P[i,:] = a[0][-K:];
        else:
            b      = np.zeros((1,K-s[1]));
            a      = np.concatenate((b,a),axis =1)
            P[i,:] = a;


    s = (len(curr_unit_list),K)
    C = np.zeros(s)

    for i in range(len(curr_unit_list)):
        uname  = curr_unit_list[i]
        uname  = zstr_full[:len(zstr_full)-len(str(uname))] + str(uname)
        a      = np.loadtxt(f0_param_path+uname+f0_ext, delimiter=' ', ndmin=2);
        s      = a.shape;

        if s[1] >= K:
            C[i,:] = a[0][:K];
        else:
            b      = np.zeros((1, K-s[1]))
            a      = np.concatenate((a,b),axis =1)
            C[i,:] = a;


    D = np.zeros((len(curr_unit_list),len(prev_unit_list)))

    for i in range(len(curr_unit_list)):
        D[i,:] = np.sqrt(np.sum((P - C[i,:])**2,axis=1))

    return(D)



def joinCost_mgc(prev_unit_list, curr_unit_list, zstr_full, mgc_param_path, mgc_ext, mgc_dim, K):

    '''
    Compute the join cost for the units

    Inputs:
    [1] prev_unit_list - List of units for previous target  (Np - number of units in this list)
    [2] curr_unit_list - List of units for current target unit (Nc - number of units in this list)

    Outputs:
    [1] D              - Distortion matrix (Nc x Np)

    '''

    P = np.zeros((len(prev_unit_list), mgc_dim, K))

    for i in range(len(prev_unit_list)):
        uname  = prev_unit_list[i]
        uname  = zstr_full[:len(zstr_full)-len(str(uname))] + str(uname)
        a      = np.loadtxt(mgc_param_path+uname+mgc_ext, delimiter=' ', ndmin=2)
        s      = a.shape

        if s[0] == 0:
            a = np.zeros((mgc_dim, 1))

        if s[1] >= K:
            P[i, :, :] = a[:, -K:]
        else:
            b      = np.zeros((mgc_dim,K-s[1]))
            a      = np.concatenate((b,a),axis =1)
            P[i, :, :] = a;


    C = np.zeros((len(curr_unit_list), mgc_dim, K))

    for i in range(len(curr_unit_list)):
        uname  = curr_unit_list[i]
        uname  = zstr_full[:len(zstr_full)-len(str(uname))] + str(uname)
        a      = np.loadtxt(mgc_param_path+uname+mgc_ext, delimiter=' ', ndmin=2)
        s      = a.shape

        if s[0] == 0:
            a = np.zeros((mgc_dim, 1))

        if s[1] >= K:
            C[i, :, :] = a[:, 0:K];
        else:
            b = np.zeros((mgc_dim, K-s[1]))
            a = np.concatenate((a,b),axis =1)
            C[i, :, :] = a;


    D = np.zeros((len(curr_unit_list), len(prev_unit_list)))

    for i in range(len(curr_unit_list)):
        for j in range((len(prev_unit_list))):
            D[i,j] = np.mean(np.sqrt(np.sum((P[j,:,:] - C[i, :, :])**2,axis=0)))

    return(D)


# Do Viterbi here
def doViterbi(units_list, parser):
    '''
    Viterbi for optimal unit selection

    Inputs:
    [1] units_list

    Outputs:
    [1] final_units_list

    Dependencies: joinCost

    '''


    # Additional inputs
    f0_param_path = parser['paths'].get('f0_param_path')
    f0_ext = parser['strs'].get('f0_ext')
    mgc_param_path = parser['paths'].get('mgc_param_path')
    mgc_ext = parser['strs'].get('mgc_ext')
    p_mgc = parser['floats'].getfloat('p_mgc')
    p_f0 = parser['floats'].getfloat('p_f0')
    K = parser['ints'].getint('K')
    mgc_dim = parser['ints'].getint('mgc_dim')
    zstr_full = parser['strs'].get('zstr_full')
    nc_flag = parser['flags'].get('normalize_costs_flag')

    ######### Start of Viterbi Forward Pass #########

    cs        = np.zeros((len(units_list[0]),1));
    csix      = np.zeros((len(units_list[0]),1));
    cs_list   = []
    csix_list = []
    cs_list.append(cs)
    csix_list.append(csix)

    for i in range(1,len(units_list)):

        '''
        Step -1: Get the Join Cost for the previous and next units
        '''

        prev_unit_list = units_list[i-1];
        curr_unit_list = units_list[i];

        D_f0 = joinCost_f0(prev_unit_list, curr_unit_list, zstr_full, f0_param_path, f0_ext, K)

        D_mgc = joinCost_mgc(prev_unit_list, curr_unit_list, zstr_full, mgc_param_path, mgc_ext, mgc_dim, K)

        if nc_flag:
            D_f0 = D_f0/np.max(D_f0)
            D_mgc = D_mgc/np.max(D_mgc)

        D = p_mgc*D_mgc + p_f0*D_f0

        '''
        Step -2: Viterbi Forward Pass
        '''
        D    = D + cs.T;
        cs   = np.min(D,axis=1)
        csix = np.argmin(D,axis=1)


        '''
        Step -3: Append minima and indices to lists
        '''
        cs_list.append(cs)
        csix_list.append(csix)

    ######### End of Viterbi Forward Pass #########



    ######### Start of Viterbi Back Trace #########
    '''
    Viterbi Back Trace
    '''

    '''
    Step - 1: Select the unit with minimum cost at the end of trellis (Initialization Step)
    '''
    final_units_list = []
    minix = np.argmin(cs);

    '''
    Step - 2: Back-Trace through the trellis (Iteration Step)
    '''
    for i in range(len(units_list)-1,0,-1):
        units_list_step  = units_list[i];
        final_units_list.append(units_list_step[minix])

        # update minimum index
        minix = csix_list[i][minix]


    '''
    Step - 3: Termination Step
    '''
    units_list_step  = units_list[i-1];
    final_units_list.append(units_list_step[minix])
    final_units_list.reverse()  ### Very Important


    return(final_units_list);

    ######### End of Viterbi Back Trace #########



# Debugging the Code
# prev_unit_list = [1,2,45,56]
#curr_unit_list = [3,4,9,10,11,12,13]
#units_list     = [prev_unit_list,curr_unit_list]
#D              = joinCost(prev_unit_list,curr_unit_list)
#units_vit      = doViterbi(units_list)




