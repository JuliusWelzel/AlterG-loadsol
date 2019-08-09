%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Get PCA weights
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% analysis for frequncy-space patterns 
% Data: dummy_proj(Walter Maetzler & Johanna Geritz, University of Kiel)
% Author: Julius Welzel (j.welzel@neurologie.uni-kiel.de)

% define paths
PATHIN = [path_data '00_rawdata\'];
PATHOUT_pre = [MAIN '04_Data\01_prepro_dat\'];

if ~exist(PATHOUT_pre)
  mkdir(PATHOUT_pre);
end

%% define config vars

cfg.filer.HP = 0.1;
cfg.filter.LP = 40;
cfg.exp.n_trials = 120;

save(cfg,[PATHOUT_pre 'cfg.mat']);