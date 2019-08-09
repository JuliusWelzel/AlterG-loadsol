%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Get gait params
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% analysis for gait straight walk
% Data: dummy_proj(Walter Maetzler & Johanna Geritz, University of Kiel)
% Author: Julius Welzel (j.welzel@neurologie.uni-kiel.de)

% define paths
PATHIN_pre = [MAIN '04_Data\01_prepro_dat\']
PATHOUT_gait = [MAIN '04_Data\02_gaitVars\'];

if ~exist(PATHOUT_gait)
  mkdir(PATHOUT_gait);
end

load([PATHIN_pre 'cfg.mat']);
