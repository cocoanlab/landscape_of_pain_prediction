% Fig 9. Benchmarking analysis results for model levels
%   9b. Binarry Classification
%   9c. Regression
%% Set up
clear; clc;

% Load Data 
basedir = '/Users/donghee/Documents/project'; % set a path to local project directory
githubdir = '/Users/donghee/github'; % set a path to local git directory for external codes
figdir = fullfile(basedir, 'figures');

load(fullfile(basedir, 'colormap_blind_wani.mat')); % color map

% Load libraries
addpath(genpath(fullfile(githubdir, 'CanlabCore')));
addpath(genpath(fullfile(githubdir, 'spm12')));
addpath(genpath(fullfile(githubdir, 'MediationToolbox')));

%% Fig 9. Benchmarking analysis results for model levels
%% (1) 9b. Binary Classification
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
result_table = readtable(fullfile(basedir, 'data/benchmark_result_model_level_cls.csv'));

%%% test: within-individual run-level (61)
result = {result_table.acc_self2self*100, ... 
          result_table.acc_group2self*100};  
cols = cols_blind_maps([2 3],:);

% plotting      
figure;
violinplot(result,'facecolor', cols, 'pointsize', 4, 'facealpha', .6, ...
    'edgecolor',cols, ...
    'linewidth', 2, 'mc','none');
legend(gca,'off');
lpp_plot_set([30 125], [40 60 80 100], false, [0.5 2.5], [1 2], false, [303   472   200   250])
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);

% save figure
% savename = fullfile(figdir, 'fig9b_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test (two-sample t-test)
[h,p,ci,stats] = ttest2(result{1}, result{2});

%%% test: independent test set (44)
result = {result_table.acc_self2group*100, ...
          result_table.acc_group2group*100};
result{1} = result{1}(~isnan(result{1}));
result{2} = result{2}(~isnan(result{2}));
cols = cols_blind_maps([2 3],:);

% plotting
figure;
violinplot(result,'facecolor', cols, 'pointsize', 4, 'facealpha', .6, ...
    'edgecolor',cols, ...
    'linewidth', 2, 'mc','none');
legend(gca,'off');
lpp_plot_set([30 125], [], false, [0.5 2.5], [1 2], false, [303   472   200   250])
set(gca,'YColor', [1 1 1])
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);

% save figure
% savename = fullfile(figdir, 'fig9b_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test (two-sample t-test)
[h,p,ci,stats] = ttest2(result{1}, result{2});

%% (2) 9c. Regression
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
result_table = readtable(fullfile(basedir, 'data/benchmark_result_model_level_reg.csv'));

%%% test: within-individual run-level (61)
result = {result_table.corr_self2self, ... 
          result_table.corr_group2self};  
cols = cols_blind_maps([2 3],:);

% plotting
figure;
violinplot(result,'facecolor', cols, 'pointsize', 4, 'facealpha', .6, ...
    'edgecolor',cols, ...
    'linewidth', 2, 'mc','none');
legend(gca,'off');
lpp_plot_set([-0.05 1.2], [0 0.2 0.4 0.6 0.8 1], false, [0.5 2.5], [1 2], false, [303   472   200   250])
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);

% save figure
% savename = fullfile(figdir, 'fig9c_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test (two-sample t-test)
[h,p,ci,stats] = ttest2(result{1}, result{2});


%%% test: independent test set (44)
result ={result_table.corr_self2group, ...
         result_table.corr_group2group};
result{1} = result{1}(~isnan(result{1}));
result{2} = result{2}(~isnan(result{2}));
cols = cols_blind_maps([2 3],:);

% plotting
figure;
violinplot(result,'facecolor', cols, 'pointsize', 4, 'facealpha', .6, ...
    'edgecolor',cols, ...
    'linewidth', 2, 'mc','none');
legend(gca,'off');
lpp_plot_set([-0.05 1.2], [], false, [0.5 2.5], [1 2], false, [303   472   200   250])
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [-0.05 1.2],'tickdir', 'out', 'box', 'off');
set(gca,'YColor', [1 1 1])
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);

% save figure
% savename = fullfile(figdir, 'fig9c_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test (two-sample t-test)
[h,p,ci,stats] = ttest2(result{1}, result{2});
