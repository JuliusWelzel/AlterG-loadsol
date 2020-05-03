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
set(0,'DefaultAxesFontName', 'Arial')
% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')

% for plot
toplot = 1;

%% Set MAIN path  and load data
MAIN = [fileparts(pwd) '\'];
PATHIN_data = [MAIN '04_data\00_rawdata\']; %make sure to use \\ instead of \
PATHOUT_data = [MAIN '04_data\01_pilot_contacttimes\'];
addpath(genpath(MAIN));
if ~exist(PATHOUT_data);mkdir(PATHOUT_data);end

list = dir(fullfile(PATHIN_data));

idx_moon= find(contains({list.name},'raw_data'),1); % find the data
dat_moon = readtable([PATHIN_data list(idx_moon).name],'Sheet','Sheet1');

%% Disttribution params
vars_idp = {'AlterG_BW','Speed','Gradient'};
cb_names = {'cool','spring','summer'};

for i = 1:numel(vars_idp)
   fact_idp(i).cat = unique(dat_moon{:,startsWith(dat_moon.Properties.VariableNames,vars_idp{i})});
   fact_idp(i).size = length(fact_idp(i).cat);
   fact_idp(i).name = vars_idp{i};
    
end

close all

for i = 1:numel(vars_idp)

    fct_dat = dat_moon{:,strcmp(dat_moon.Properties.VariableNames,vars_idp{i})};

    time = nanmean([dat_moon.AvgContactTimeLeft_ms_,dat_moon.AvgContactTimeRight_ms_],2);
    force = nanmean([dat_moon.ForceNormBWLeft,dat_moon.ForceNrmBWRight],2);
    time(isoutlier(time,'quartiles')) = NaN;
    force(isoutlier(force,'quartiles')) = NaN;
    c_map = colormap(cb_names{i});
    c_idx = ceil(linspace(1,length(c_map),fact_idp(i).size));
    
    if toplot
    scatterhist(time,force,'Group',dat_moon{:,strcmp(dat_moon.Properties.VariableNames,vars_idp{i})}...
        ,'Color',c_map(c_idx,:),'Kernel','on','Marker','.','MarkerSize',10)
    title(vars_idp{i})
    xlabel 'avg. contact-time [ms]'
    ylabel 'force [Bodyweight]'
    legend boxoff
    save_fig(gcf,PATHOUT_data,vars_idp{i},'fontsize',20);
    end
end


%% replicate Thomson ea., alterG 2017 findings

% fig. 2
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
c_map = colormap('cool');

if toplot
 for g = 1:fact_idp(1).size
     idx_g = alterG == fact_idp(1).cat(g);
     dat = time(idx_g);
     c_idx = ceil(linspace(1,length(c_map),fact_idp(1).size));

     for i = 1:fact_idp(2).size
        [m(i) se(i)] = mean_SEM(time(idx_g & speed == fact_idp(2).cat(i))');
     end
     errorbar(fact_idp(2).cat,m,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
     clear m
     clear se

 end

xlabel 'Speed [km/h]'
ylabel 'Avg. contact times [ms]'
xlim ([10 26])
ylim ([150 270])
xticks (fact_idp(2).cat)

title 'Contact times at different bodyweights [%]'
legend(num2str(fact_idp(1).cat),'Location','best')
legend boxoff
save_fig(gcf,PATHOUT_data,'contact_times_bw','fontsize',20);

end




%% fig. 2
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
c_map = colormap('spring');

if toplot
 for g = 1:fact_idp(2).size %grouping
     idx_g = speed == fact_idp(2).cat(g);
     dat = time(idx_g);
     c_idx = ceil(linspace(10,length(c_map),fact_idp(2).size));

     for i = 1:fact_idp(1).size
        [m(i) se(i)] = mean_SEM(time(idx_g & alterG == fact_idp(1).cat(i))');
     end
     errorbar(fact_idp(1).cat,m,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
     clear m se
 end

xlabel 'Alter-G [%]'
ylabel 'Avg. contact times [ms]'
xlim ([50 110])
% ylim ([1.6 2.5])
xticks (fact_idp(1).cat)

% fitlm
reg_e1 = fitlm([alterG log(speed)],time,'VarNames',{'Bodyweight','log(Speed)','Contact time'})
% out parameters
[ resreg resregover ] = reg2tab(reg_e1);
writetable(resreg,[PATHOUT_data 'regcoef_contacttimes_1.xls'],'WriteRowNames',true);
writetable(resregover,[PATHOUT_data 'mdlcoef_contacttimes_1.xls']);

% continue plot
title ({'Contact times at different speeds [km/h]',['adj. R²: ' num2str(round(reg_e1.Rsquared.Adjusted,3)) ...
    ' / p <0.0001']})

legend(num2str(fact_idp(2).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'contact_times_sp','fontsize',20);

end




%% fig. new gradients
close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
gradient = dat_moon.Gradient;
c_map = colormap('summer');

if toplot
 for g = 1:fact_idp(3).size %grouping
     idx_g = gradient == fact_idp(3).cat(g);
     dat = time(idx_g);
     c_idx = ceil(linspace(1,length(c_map)-10,fact_idp(3).size));

     for i = 1:fact_idp(2).size
        [m_speed(i) se(i)] = mean_SEM(time(idx_g & speed == fact_idp(2).cat(i))');
     end
     errorbar(fact_idp(2).cat,m_speed,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
 end

xlabel 'Speed [km/h]'
ylabel 'Avg. contact times [ms]'
xlim ([10 26])
% ylim ([1.8 2.35])
xticks (fact_idp(2).cat)
title 'Contact times at gradients [°]'
legend(num2str(fact_idp(3).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'contact_times_grad','fontsize',20);
end
%% fig. new gradients
idx_group = 1; % %alterG
idx_xvar = 3; %gradient

close all
alterG = dat_moon.AlterG_BW;
speed = dat_moon.Speed;
gradient = dat_moon.Gradient;
c_map = colormap('cool');

speed_ng = unique(speed(gradient<0));

if toplot
 for g = 1:fact_idp(idx_group).size %grouping
     idx_g = alterG == fact_idp(idx_group).cat(g);
     idx_speed = ismember(speed,speed_ng);
     dat = time(idx_g & idx_speed);
     c_idx = ceil(linspace(1,length(c_map)-10,fact_idp(idx_group).size));

     for i = 1:fact_idp(idx_xvar).size
        [m_grad(i) se(i)] = mean_SEM(time(idx_g & gradient == fact_idp(idx_xvar).cat(i))');
     end
     errorbar(fact_idp(idx_xvar).cat,m_grad,se,'LineWidth',1.5,'Color',c_map(c_idx(g),:))
     hold on
 end

xlabel 'Gradient [°]'
ylabel 'Avg. contact times [ms]'
xlim ([-18 18])
% ylim ([1.55 2.4])
xticks (fact_idp(idx_xvar).cat)
title ({'Contact times vary with Gradient','averaged for 12 & 15 km/h'})
legend(num2str(fact_idp(idx_group).cat),'Location','southeast')
legend boxoff
save_fig(gcf,PATHOUT_data,'gradient_dep_contact_time','fontsize',20);
end


%% Stats for 3D

%fitlm
reg_grad = fitlm([alterG log(speed) gradient],time,'VarNames',{'Bodyweight','log(Speed)','Gradient','Contact time'})

% out parameters
[ resreg resregover ] = reg2tab(reg_grad);
writetable(resreg,[PATHOUT_data 'regcoef_contacttimes_2.xls'],'WriteRowNames',true);
writetable(resregover,[PATHOUT_data 'mdlcoef_contacttimes_2.xls']);

title ({'Mutiple linear regression',['adj. R²: ' num2str(round(reg_grad.Rsquared.Adjusted,3)) ...
    ' / p <0.0001']})

save_fig(gcf,PATHOUT_data,'mReg_plot_ct');

%% 3D plot
close all

for i = 1:fact_idp(1).size %all alterG
    idx_bw = alterG == fact_idp(1).cat(i);

   for ii = 1:fact_idp(2).size %all speeds
       idx_s = speed == fact_idp(2).cat(ii);
       
       for iii = 1:fact_idp(3).size %all grad
            idx_g = gradient == fact_idp(3).cat(iii);
            dat_3d(i,ii,iii) =  nanmean(time(idx_bw & idx_s & idx_g));
       end
   end
   
   surf(squeeze(dat_3d(i,:,:)),'FaceAlpha',0.7)
   hold on 
end

colormap (cb_names{1});

ylabel 'Speed [km/h]'
yticklabels(fact_idp(2).cat)

% zlim ([1.4 2.6])
zlabel 'Avg. contact times [ms]'
title ({'Mutiple linear regression (including gradient)',['adj. R²: ' num2str(round(reg_grad.Rsquared.Adjusted,3)) ...
    ' / p <0.0001']})
legend(num2str(fact_idp(1).cat),'Location','northwest')
legend boxoff

xlabel 'Gradient [°]'
xlim ([1 7])
xticklabels(fact_idp(3).cat)
xlim([0 8])
axis tight

savefig(gcf,[PATHOUT_data '3D_data_rep.fig']);
save_fig(gcf,PATHOUT_data,'3D_all');







































