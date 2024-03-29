%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      Distribution parameters time & force
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

% for plot
toplot = 0;

%% Set MAIN path  and load data
MAIN = [fileparts(pwd) '\'];
PATHIN_data = [MAIN '04_data\00_rawdata\']; %make sure to use \\ instead of \
PATHOUT_data = [MAIN '04_data\01_pilot_peakforce\'];
addpath(genpath(MAIN));
if ~exist(PATHOUT_data);mkdir(PATHOUT_data);end

list = dir(fullfile(PATHIN_data));

idx_moon = find(contains({list.name},'raw_data'),1); % find the raw flesh
dat_moon = readtable([PATHIN_data list(idx_moon).name]);

dat_moon.ForceNormBWLeft = str2double(dat_moon.ForceNormBWLeft);
dat_moon.ForceNrmBWRight = str2double(dat_moon.ForceNrmBWRight);

%% Disttribution params
nms_UV = {'AlterG_{BW}','Speed','Gradient'};



[~,tbl,stats] = anovan(mean([dat_moon.ForceNormBWLeft,dat_moon.ForceNrmBWRight],2),...
                {dat_moon.AlterG_BW,dat_moon.Gradient,dat_moon.Speed},...
                'varnames',nms_UV);
writecell(tbl,[PATHOUT_data 'tbl_ANOVA.xls']);
            
            
[c,~,~,nms] = multcompare(stats,'Dimension',[1 2 3])



% fig2plotly()
savefig([PATHOUT_data 'mlt_cmpr_ANOVA.fig'])


% save_fig(gcf,PATHOUT_data,'mlt_cmpr_ANOVA','FigSize',[0 0 20 40],'FontSize',8)
%% export data for web
dat_pages = table;
dat_pages.force = mean([dat_moon.ForceNormBWLeft,dat_moon.ForceNrmBWRight],2);
dat_pages.time = mean([dat_moon.AvgContactTimeLeft_ms_,dat_moon.AvgContactTimeRight_ms_],2);

dat_pages.force(isoutlier(dat_pages.force)) = NaN;
dat_pages.time(isoutlier(dat_pages.time)) = NaN;

dat_pages.speed = dat_moon.Speed;
dat_pages.gradtient = dat_moon.Gradient;
dat_pages.bw = dat_moon.AlterG_BW;


writetable(dat_pages,[PATHOUT_data 'dat_pages.csv'])


dat_speed = unstack(dat_pages,{'force','time'},'speed')
