%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      Distribution parameters time& force
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data: Walking on the moon (Clint Hansen, Neurogeriatrie, UKSH Kiel,University of Kiel)
% Author: Julius Welzel (Neurogeriatrie, UKSH Kiel,University of Kiel)
% Contact: c.hansen@neurologie.uni-kiel.de & j.welzel@neurologie.uni-kiel.de
% Version: 1.0 // setting up default (30.08.2019)


clc;close all;clear all;
%Change MatLab defaults
set(0,'defaultfigurecolor',[1 1 1]);
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'CMU Sans Serif')
% Change default text fonts.
set(0,'DefaultTextFontname', 'CMU Sans Serif')


%% Set MAIN path  and load data
MAIN = 'C:\Users\juliu\Desktop\NG_kiel\moonwalk_CliH\';
PATHIN_data = [MAIN '04_data\00_rawdata\']; %make sure to use \\ instead of \
PATHOUT_data = [MAIN '04_data\01_pilot\'];
addpath(genpath(MAIN));
if ~exist(PATHOUT_data);mkdir(PATHOUT_data);end

list = dir(fullfile(PATHIN_data));

idx_moon= find(contains({list.name},'raw_data'),1); % find the raw flesh
dat_moon = readtable([PATHIN_data list(idx_moon).name],'Sheet','Sheet1');

%% Disttribution params
vars_idp = {'AlterG_BW','Speed','Gradient'};
cb_names = {'cool','spring','summer'};

for i = 1:numel(vars_idp)
   fact_idp(i).cat = unique(dat_moon{:,strcmp(dat_moon.Properties.VariableNames,vars_idp{i})});
   fact_idp(i).size = length(fact_idp(i).cat);
   fact_idp(i).name = vars_idp{i};
end

close all

for i = 1:numel(vars_idp)

    figure
    fct_dat = dat_moon{:,strcmp(dat_moon.Properties.VariableNames,vars_idp{i})};

    time = nanmean([dat_moon.AvgContactTimeLeft_ms_,dat_moon.AvgContactTimeRight_ms_],2);
    force = nanmean([dat_moon.ForceNormBWLeft,dat_moon.ForceNrmBWRight],2);
    time(isoutlier(time)) = NaN;
    force(isoutlier(force)) = NaN;
    c_map = colormap(cb_names{i});
    c_idx = ceil(linspace(1,length(c_map),fact_idp(i).size));
    scatterhist(time,force,'Group',dat_moon{:,strcmp(dat_moon.Properties.VariableNames,vars_idp{i})}...
        ,'Color',c_map(c_idx,:),'Kernel','on','Marker','.','MarkerSize',10)
    title(vars_idp{i})
    xlabel 'time [ms]'
    ylabel 'force [N]'
    legend boxoff
    save_fig(gcf,PATHOUT_data,vars_idp{i},'fontsize',20);
end
