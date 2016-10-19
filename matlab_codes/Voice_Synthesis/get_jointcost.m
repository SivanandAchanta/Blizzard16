function [D,Cc,unit_pair_id] = get_jointcost(param_path,curr_uid,prev_uid,ext,K)

% Note : All parameter files must be row vectors

% Purpose: Compute the joint/concatenation cost between u_i and u_{i-1}

% Inputs:
% param_path   - path of parameters for computing joint cost
% curr_uid     - candidate list of current target units (u_i)
% prev_uid     - candidate list of previous target units (u_{i-1})
% ext          - extension of parameter files ( eg: .f0 for f0 parameter files)
% K            - num of frames at the unit boundary

% Outputs
% Cc           - concatenation cost of u_i and u_{i-1}
% unit_pair_id - the id of previous unit which gave minimum concatenation distortion

zstr_full   = 'u_0000000';

% Step1 : Load feature vectors of all previous units
P = zeros(length(prev_uid),K);
for j = 1:length(prev_uid)
    zstr     = zstr_full(1:end-length(num2str(prev_uid(j))));
    uid      = strcat(zstr,num2str(prev_uid(j)));
    M1       = dlmread(strcat(param_path,uid,ext));
    
    % Check if there are K frames in M1 if not pad zeros at beginning
    nof = size(M1,2);
    if nof < K
        M1 = [zeros(1,K-nof) M1];
    end
    
    % take last K frames of u_{i-1}
    P(j,:) = M1(:,end-K+1:end);
    
end

% Step2 : Load feature vectors of all previous units
C = zeros(length(curr_uid),K);
for j = 1:length(curr_uid)

    
    zstr     = zstr_full(1:end-length(num2str(curr_uid(j))));
    uid      = strcat(zstr,num2str(curr_uid(j)));
    
    % strcat(param_path,uid,ext)
    M1       = dlmread(strcat(param_path,uid,ext));
    
    % Check if there are K frames in M1 if not pad zeros at end
    nof = size(M1,2);
    if nof < K
        M1 = [M1 zeros(1,K-nof)];
    end
    
    % take first K frames of u_i
    C(j,:) = M1(:,1:K);
end


% Step3 : Compute the distortion matrix
D = zeros(length(curr_uid),length(prev_uid));

for j = 1:length(curr_uid)
    D(j,:) = sqrt(sum(power(bsxfun(@minus,P,C(j,:)),2),2))';
end


% Step4 : Concatenation cost and minimum cost unit_pairs from the distortion matrix
[Cc,unit_pair_id] = min(D,[],2);

end