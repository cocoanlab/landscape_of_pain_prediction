% Fig 8. Benchmarking analysis results for spatial scales
%   8b. Binarry Classification
%       8b-1. Inreasing spatial scale
%       8b-2. Bain-wide masks
%   8c. Regression
%       8c-1. Inreasing spatial scale
%       8c-2. Bain-wide masks
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

%% Fig 8. Benchmarking analysis results for spatial scales 
%% (1) 8b. Binarry Classification
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
x = [1 3 6 10 15 21 25 29];
result_table = readtable(fullfile(basedir, 'data/benchmark_result_spatial_scale_cls.csv'));

mean_list = [mean(result_table{:,1}) mean(result_table{:,2}) mean(result_table{:,3}) mean(result_table{:,4}) mean(result_table{:,5}) mean(result_table{:,6}) mean(result_table{:,7}) mean(result_table{:,8})];
std_list = [std(result_table{:,1}) std(result_table{:,2}) std(result_table{:,3}) std(result_table{:,4}) std(result_table{:,5}) std(result_table{:,6}) std(result_table{:,7}) std(result_table{:,8})];

% plotting
figure;
hold on
for n = 1:44 % 44 gray lines
    y = result_table{n,[1:8]}*100;
    plot(x,y,'Color',[ 0    0    0],'LineWidth', 0.1)
end
x3 = x';
y3 = mean_list'*100; % percentage
dy3 = std_list'*100; % percentage
h = fill([x3;flipud(x3)],[y3-dy3;flipud(y3+dy3)], cols_blind_maps(8,:),'linestyle','none');
set(h,'facealpha',.3)
plot(x3, y3,'-o', ...
     'Color', cols_blind_maps(8,:),'linewidth', 2, ...
     'MarkerSize', 8 ,'MarkerEdgeColor', 'white', 'MarkerFaceColor', cols_blind_maps(8,:))

lpp_plot_set([40 110], [40 60 80 100], false, [0 30], [1 3 6 10 15 21 25 29], false, [303   472   400   250])
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
lpp_plot_break_yaxis([-0.5 0.5 0.5 -0.5], [43   44.5   46   44.5]) % break y-axis
hold off

% save figure
% savename = fullfile(figdir, 'fig8b_cls_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test box plot
result_wholebrain = result_table{:,6:8} * 100;
lpp_plot_boxplot(result_wholebrain,[40 110], [40 60 80 100],false);
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
lpp_plot_break_yaxis([0.125 0.25 0.25 0.125], [43   44.5   46   44.5])

% save figure
% savename = fullfile(figdir, 'fig8b_cls_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5]; sub=44;

y = 100*result_table{:,1:5}';
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

% paired t-test (two-sample t-test)
[h1,p1,ci1,stats1] = ttest(result_wholebrain(:,1), result_wholebrain(:,2)); % 21 regions vs. neurosynth
[h2,p2,ci2,stats2] = ttest(result_wholebrain(:,2), result_wholebrain(:,3)); % neurosynth vs. graymatter
[h3,p3,ci3,stats3] = ttest(result_wholebrain(:,1), result_wholebrain(:,3)); % 21 regions vs. graymatter

%% (2) 8c. Regression
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
result_table = readtable(fullfile(basedir, 'data/benchmark_result_spatial_scale_reg.csv'));
x = [1 3 6 10 15 21 25 29];

mean_list = [mean(result_table{:,1}) mean(result_table{:,2}) mean(result_table{:,3}) mean(result_table{:,4}) mean(result_table{:,5}) mean(result_table{:,6}) mean(result_table{:,7}) mean(result_table{:,8})];
std_list = [std(result_table{:,1}) std(result_table{:,2}) std(result_table{:,3}) std(result_table{:,4}) std(result_table{:,5}) std(result_table{:,6}) std(result_table{:,7}) std(result_table{:,8})];

% plotting
figure;
hold on
for n = 1:44 % 44 gray lines
    y = result_table{n,[1:8]};
    plot(x,y,'Color',[0    0    0],'LineWidth', 0.1)
end
x3 = x';
y3 = mean_list'; % percentage
dy3 = std_list'; % percentage
h = fill([x3;flipud(x3)],[y3-dy3;flipud(y3+dy3)], cols_blind_maps(8,:),'linestyle','none');
set(h,'facealpha',.3)
plot(x3, y3,'-o', ...
     'Color', cols_blind_maps(8,:),'linewidth', 2, ...
     'MarkerSize', 8 ,'MarkerEdgeColor', 'white', 'MarkerFaceColor', cols_blind_maps(8,:))
lpp_plot_set([0.4 1.1], [0.4 0.6 0.8 1.0], false, [0 30], [1 3 6 10 15 21 25 29], false, [303   472   400   250])
set(refline([0 0]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);
hold off

% save figure
% savename = fullfile(figdir, 'fig8c_reg_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% paired t-test box plot
result_wholebrain = result_table{:,6:8};
lpp_plot_boxplot(result_wholebrain,[-.05 1.1],[0 0.2 0.4 0.6 0.8 1], false);
set(refline([0 0]), 'color', [.7 .7 .7], 'linestyle', '--', 'linewidth', 1.8);

% save figure
% savename = fullfile(figdir, 'fig8c_reg_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5]; sub=44;

y = result_table{:,1:5}';
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

% paired t-test (two-sample t-test)
[h1,p1,ci1,stats1] = ttest(result_wholebrain(:,1), result_wholebrain(:,2)); % 21 regions vs. neurosynth
[h2,p2,ci2,stats2] = ttest(result_wholebrain(:,2), result_wholebrain(:,3)); % neurosynth vs. graymatter
[h3,p3,ci3,stats3] = ttest(result_wholebrain(:,1), result_wholebrain(:,3)); % 21 regions vs. graymatter