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
    ylabel 'force [Bodyweight]'
    legend boxoff
    save_fig(gcf,PATHOUT_data,vars_idp{i},'fontsize',20);
end


%% replicate Thomson ea., alterG 2017 findings

% fig. 2
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
c_map = colormap('cool');

figure
 for g = 1:fact_idp(1).size
     idx_g = alterG == fact_idp(1).cat(g);
     dat = force(idx_g);
     c_idx = ceil(linspace(1,length(c_map),fact_idp(1).size));

     for i = 1:fact_idp(2).size
        [m(i) se(i)] = mean_SEM(force(idx_g & speed == fact_idp(2).cat(i))');
     end
     errorbar(fact_idp(2).cat,m,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
 end

xlabel 'Speed [km/h]'
ylabel 'Norm Peak Force? [Bodyweight]'
xlim ([10 26])
ylim ([1.6 2.5])
xticks (fact_idp(2).cat)

title 'Replicate Thomson ea. (Fig. 2), JSS, 2017'
legend(num2str(fact_idp(1).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'Thomson_2017_fig2','fontsize',20);

clear m
clear se

%% fig. 2
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
c_map = colormap('spring');

 for g = 1:fact_idp(2).size %grouping
     idx_g = speed == fact_idp(2).cat(g);
     dat = force(idx_g);
     c_idx = ceil(linspace(1,length(c_map)-10,fact_idp(2).size));

     for i = 1:fact_idp(1).size
        [m(i) se(i)] = mean_SEM(force(idx_g & alterG == fact_idp(1).cat(i))');
     end
     errorbar(fact_idp(1).cat,m,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
 end

xlabel 'Alter-G [%]'
ylabel 'Norm Peak Force? [Bodyweight]'
xlim ([55 105])
ylim ([1.6 2.5])
xticks (fact_idp(1).cat)
title 'Replicate Thomson ea. (Fig. 1), JSS, 2017'
legend(num2str(fact_idp(2).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'Thomson_2017_fig1','fontsize',20);

%% fig. new gradients
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
gradient = dat_moon.Gradient;
c_map = colormap('summer');

 for g = 1:fact_idp(3).size %grouping
     idx_g = gradient == fact_idp(3).cat(g);
     dat = force(idx_g);
     c_idx = ceil(linspace(1,length(c_map)-10,fact_idp(3).size));

     for i = 1:fact_idp(2).size
        [m_speed(i) se(i)] = mean_SEM(force(idx_g & speed == fact_idp(2).cat(i))');
     end
     errorbar(fact_idp(2).cat,m_speed,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
 end

xlabel 'Speed [km/h]'
ylabel 'Norm Peak Force? [Bodyweight]'
xlim ([10 26])
ylim ([1.8 2.35])
xticks (fact_idp(2).cat)
title 'Norm Peak Force varies with Gradient'
legend(num2str(fact_idp(3).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'gradient_dependency','fontsize',20);

%% 3D plot
close all

for i = 1:fact_idp(1).size %all alterG
    idx_bw = alterG == fact_idp(1).cat(i);

   for ii = 1:fact_idp(2).size %all speeds
       idx_s = speed == fact_idp(2).cat(ii);
       
       for iii = 1:fact_idp(3).size %all grad
            idx_g = gradient == fact_idp(3).cat(iii);
            dat_3d(i,ii,iii) =  nanmean(force(idx_bw & idx_s & idx_g));
       end
   end
   
   surf(squeeze(dat_3d(i,:,:)))
   hold on 
end

colormap (cb_names{1});

ylabel 'Speed [km/h]'
ylim([0 6])
yticklabels(fact_idp(2).cat)

zlim ([1.4 2.6])
zlabel 'Norm Peak Force? [Bodyweight]'
title 'Norm Peak Force varies with Gradient'
legend(num2str(fact_idp(1).cat),'Location','northwest')
legend boxoff

xlabel 'Gradient [°]'
xlim ([1 7])
xticklabels(fact_idp(3).cat)
xlim([0 8])

savefig(gcf,[PATHOUT_data '3D_data_rep.fig'])




