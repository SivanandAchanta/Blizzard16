function [final_units_list] = viterbi_uss(pre_selunits_list,param_path,ext,K)

% Purpose: Viterbi for best units selection

% Inputs:
% units        - list of units selected in pre-selection
% param_path   - path of parameters for computing joint cost
% ext          - extension of parameter files ( eg: .f0 for f0 parameter files)
% K            - num of frames at the unit boundary

% Outputs:
% sel_units    - list of selected units

% Example
% units = {{'a_1','a_2','a_3'},{'b_1','b_2'}}

% clear all; close all; clc;

% config

% Step - 1 : Select units from the database for each of the target units
% [pre_selunits_list] = pre_selection(lab_path,fname,ctl_file);

% param_path = '../../units/f0/';
% ext = '.f0';
% K = 3;

final_units_list        = zeros(length(pre_selunits_list),1);
cs                      = zeros(length(pre_selunits_list{1}),1);
cs_allunits{1}          = zeros(length(pre_selunits_list{1}),1);
unitpair_id_allunits{1} = zeros(length(pre_selunits_list{1}),1);

for i = 2:length(pre_selunits_list)
    
    curr_uid   = pre_selunits_list{i};
    prev_uid   = pre_selunits_list{i-1};
    
    % Step - 1 : Get target cost
    
    % Step - 2 : Get joint cost
    [D,~,unitpair_id] = get_jointcost(param_path,curr_uid,prev_uid,ext,K);
    
    % Step - 3 : Forward pass
    D         = bsxfun(@plus,D,cs');
    [cs,csix] = min(D,[],2);
    
    % Step - 4 : Store values and indices
    cs_allunits{i}          = cs;
    unitpair_id_allunits{i} = csix;
    
end

% Viterbi back-trace for best set of units
[~,minix] = min(cs_allunits{i});
for i = length(pre_selunits_list):-1:2
    
    % select the unit which gave the minimum cost
    unit_list           = pre_selunits_list{i};
    final_units_list(i) = unit_list(minix);
    
    % update minimum index
    minix         = unitpair_id_allunits{i}(minix);
end

unit_list             = pre_selunits_list{i-1};
final_units_list(i-1) = unit_list(minix);
