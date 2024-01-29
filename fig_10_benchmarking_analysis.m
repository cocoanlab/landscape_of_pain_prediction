% Fig 10. Benchmarking analysis results for sample size
%   10b. Binarry Classification
%   10c. Regression
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

%% Fig 10. Benchmarking analysis results for sample size
%% (1) 10b. Binary Classification
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
x = [10 20 30 40 50 60 70];

result_table = readtable(fullfile(basedir, 'data/benchmark_result_sample_size_cls.csv'));

mean_list = [mean(result_table{:,1}) mean(result_table{:,2}) mean(result_table{:,3}) mean(result_table{:,4}) mean(result_table{:,5}) mean(result_table{:,6}) mean(result_table{:,7})];
std_list = [std(result_table{:,1}) std(result_table{:,2}) std(result_table{:,3}) std(result_table{:,4}) std(result_table{:,5}) std(result_table{:,6}) std(result_table{:,7})];

% plotting
figure;
hold on
for n = 1:100 % 100 gray lines
    y = result_table{n,[1:7]}*100;
    p = polyfit(x,y,2);
    x2 = 10:0.5:70;
    y2 = polyval(p,x2);
    plot(x2,y2,'Color',[0 0 0],'LineWidth', 0.1)
end
x3 = x';
y3 = mean_list'*100;
dy3 = std_list'*100;
h = fill([x3;flipud(x3)],[y3-dy3;flipud(y3+dy3)], cols_blind_maps(8,:),'linestyle','none');
set(h,'facealpha',.3)
plot(x3, y3,'-o', ...
     'Color', cols_blind_maps(8,:),'linewidth', 2, ...
     'MarkerSize', 8 ,'MarkerEdgeColor', 'white', 'MarkerFaceColor', cols_blind_maps(8,:))
line([70 80], [mean_list(end)*100 result_table{1,8}*100],'Color', cols_blind_maps(8,:),'linewidth', 2);
scatter(80, result_table{1,8}*100, ...
    40, cols_blind_maps(8,:), 'filled')
hold off
lpp_plot_set([80 90], [80 82 84 86 88 90], false, [5 85], [10 20 30 40 50 60 70 80], false, [303   472   400   250])

% save figure
% savename = fullfile(figdir, 'fig10b.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5,6,7]; iter=100;

y = 100*result_table{:,1:7}';
x = repmat(dum,iter,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (2) 10c. Regression
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
x = [10 20 30 40 50 60 70];

result_table = readtable(fullfile(basedir, 'data/benchmark_result_sample_size_reg.csv'));

mean_list = [mean(result_table{:,1}) mean(result_table{:,2}) mean(result_table{:,3}) mean(result_table{:,4}) mean(result_table{:,5}) mean(result_table{:,6}) mean(result_table{:,7})];
std_list = [std(result_table{:,1}) std(result_table{:,2}) std(result_table{:,3}) std(result_table{:,4}) std(result_table{:,5}) std(result_table{:,6}) std(result_table{:,7})];

% plotting
figure;
hold on
for n = 1:100 % 100 gray lines
    y = result_table{n,[1:7]};
    p = polyfit(x,y,2);
    x2 = 10:0.5:70;
    y2 = polyval(p,x2);
    plot(x2,y2,'Color',[0 0 0],'LineWidth', 0.1)
end
x3 = x';
y3 = mean_list';
dy3 = std_list';
h = fill([x3;flipud(x3)],[y3-dy3;flipud(y3+dy3)], cols_blind_maps(8,:),'linestyle','none');
set(h,'facealpha',.3)
plot(x3, y3,'-o', ...
     'Color', cols_blind_maps(8,:),'linewidth', 2, ...
     'MarkerSize', 8 ,'MarkerEdgeColor', 'white', 'MarkerFaceColor', cols_blind_maps(8,:))
% sample size 80
line([70 80], [mean_list(end) result_table{1,8}],'Color', cols_blind_maps(8,:),'linewidth', 2);
scatter(80, result_table{1,8}, ...
     40, cols_blind_maps(8,:), 'filled')
hold off
lpp_plot_set([0.6 0.8], [0.6 0.65 0.7 0.75 0.8], false, [5 85], [10 20 30 40 50 60 70 80], false, [303   472   400   250])

% save figure
% savename = fullfile(figdir, 'fig10c.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5,6,7]; iter=100;

y = result_table{:,1:7}';
x = repmat(dum,iter,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);