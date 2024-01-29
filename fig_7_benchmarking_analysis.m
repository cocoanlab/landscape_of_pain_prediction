% Fig 7. Benchmarking analysis results for data levels (i.e., data averaging)
%   7c. Binary Classification
%       7c-1. Benchmarking for train data levels
%       7c-2. Benchmarking for test data levels
%       7c-3. Benchmarking for test data levels (matched data)
%   7d. Regression
%       7d-1. Benchmarking for train data levels
%       7d-2. Benchmarking for test data levels
%       7d-3. Benchmarking for test data levels (matched data)
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

%% Fig 7. Benchmarking analysis results for data levels (i.e., data averaging)
%% (1) 7c. Binary Classification
result_table = readtable(fullfile(basedir, 'data/benchmark_result_data_level_cls.csv'));
%% (a) 7c-1. Benchmarking for train data levels
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% test: no average(trial)
test_trial = [result_table.acc_trial_to_trial ...
    result_table.acc_run_to_trial ...
    result_table.acc_quart_to_trial ...
    result_table.acc_semi_to_trial ...
    result_table.acc_cond_to_trial];

% test: 16 trials average(condition)
test_condition = [result_table.acc_trial_to_cond ...
    result_table.acc_run_to_cond ...
    result_table.acc_quart_to_cond ...
    result_table.acc_semi_to_cond ...
    result_table.acc_cond_to_cond];

% plotting
figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(test_trial), ste(test_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(7,:))
lpp_plot_shading([1 2 3 4 5], mean(test_condition), ste(test_condition), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(2,:))
lpp_plot_set([0.73 0.96], [0.73 0.8 0.85 0.9 0.95 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.745 0.75125 0.7575 0.75125]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7c_left.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel GLM
dum = [1,2,3,4,5]; % 5 test data levels
sub=44; % 44 participants

%y = test_trial'*100; % uncomment this line to do multi-level GLM for this data
y = test_condition'*100; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (b) 7c-2. Benchmarking for test data levels
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% train: no average (trial)
train_trial = [result_table.acc_trial_to_trial ...
    result_table.acc_trial_to_run ...
    result_table.acc_trial_to_quart ...
    result_table.acc_trial_to_semi ...
    result_table.acc_trial_to_cond];
% train: 16 trials average (condition)
train_condition = [result_table.acc_cond_to_trial ...
    result_table.acc_cond_to_run ...
    result_table.acc_cond_to_quart ...
    result_table.acc_cond_to_semi ...
    result_table.acc_cond_to_cond];

% plotting
figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(train_trial), ste(train_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(7,:))
lpp_plot_shading([1 2 3 4 5], mean(train_condition), ste(train_condition), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(2,:))
lpp_plot_set([0.73 0.96], [0.73 0.8 0.85 0.9 0.95 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.745 0.75125 0.7575 0.75125]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7c_center.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel GLM
dum = [1,2,3,4,5]; % 5 test data levels
sub=44; % 44 participants

% y = train_trial'*100; % uncomment this line to do multi-level GLM for this data
y = train_condition'*100; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (c) 7c-3. Benchmarking for test data levels (with matched number of data across test data levels)
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% train: no average (trial)
train_trial = [ ...
    result_table.train_trial_test_trial ...
    result_table.train_trial_test_run ...
    result_table.train_trial_test_quarter ...
    result_table.train_trial_test_semi ...
    result_table.train_trial_test_cond ...
    ];
% train: 16 trials average (condition)
train_cond = [ ...
    result_table.train_cond_test_trial ...
    result_table.train_cond_test_run ...
    result_table.train_cond_test_quarter ...
    result_table.train_cond_test_semi ...
    result_table.train_cond_test_cond ...
    ];

figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(train_trial), ste(train_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(7,:))
lpp_plot_shading([1 2 3 4 5], mean(train_cond), ste(train_cond), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(2,:))
lpp_plot_set([0.73 0.96], [0.73 0.8 0.85 0.9 0.95 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.745 0.75125 0.7575 0.75125]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7c_right.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5]; % 5 test data levels
sub=44; % 44 participants

% y = train_trial'*100; % uncomment this line to do multi-level GLM for this data
y = train_cond'*100; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (2) 7d. Regression
clearvars -except basedir githubdir figdir cols_blind_maps; clc;
result_table = readtable(fullfile(basedir,'data/benchmark_result_data_level_reg.csv'));
%% (a) 7d-1. Benchmarking for train data levels
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% test trial
test_trial = [...
    result_table.corr_trial_to_trial ...
    result_table.corr_run_to_trial ...
    result_table.corr_quart_to_trial ...
    result_table.corr_semi_to_trial ...
    result_table.corr_cond_to_trial ...
    ];
% test condition
test_cond = [...
    result_table.corr_trial_to_cond ...
    result_table.corr_run_to_cond ...
    result_table.corr_quart_to_cond ...
    result_table.corr_semi_to_cond ...
    result_table.corr_cond_to_cond ...
    ];

% plotting
figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(test_trial), ste(test_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(4,:))
lpp_plot_shading([1 2 3 4 5], mean(test_cond), ste(test_cond), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(6,:))
lpp_plot_set([0.4 1.02], [0.4 0.5 0.6 0.7 0.8 0.9 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.44 0.46 0.48 0.46]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7d_left.pdf');  % uncomment this line to save the figure
% saveas(gcf, savename);  % uncomment this line to save the figure

% multilevel GLM
dum = [1,2,3,4,5]; % 5 test data levels
sub=44; % 44 participants

% y = test_trial'; % uncomment this line to do multi-level GLM for this data
y = test_cond'; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (b) 7d-2. Benchmarking for test data levels
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% train trial
train_trial = [result_table.corr_trial_to_trial ...
    result_table.corr_trial_to_run ...
    result_table.corr_trial_to_quart ...
    result_table.corr_trial_to_semi ...
    result_table.corr_trial_to_cond];

% train condition
train_cond = [result_table.corr_cond_to_trial ...
        result_table.corr_cond_to_run ...
        result_table.corr_cond_to_quart ...
        result_table.corr_cond_to_semi ...
        result_table.corr_cond_to_cond];

% plotting
figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(train_trial), ste(train_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(4,:))
lpp_plot_shading([1 2 3 4 5], mean(train_cond), ste(train_cond), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(6,:))
lpp_plot_set([0.4 1.02], [0.4 0.5 0.6 0.7 0.8 0.9 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.44 0.46 0.48 0.46]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7d_center.pdf');  % uncomment this line to save the figure
% saveas(gcf, savename);  % uncomment this line to save the figure

% multilevel GLM
dum = [1,2,3,4,5]; % 5 test data levels
sub=44; % 44 participants

y = train_trial'; % uncomment this line to do multi-level GLM for this data
% y = train_cond'; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);

%% (c) 7d-c. Benchmarking for test data levels (with matched number of data across test data levels)
clearvars -except basedir githubdir figdir result_table cols_blind_maps; clc;
% train on trial
train_trial = [ ...
    result_table.train_trial_test_trial ...
    result_table.train_trial_test_run ...
    result_table.train_trial_test_quarter ...
    result_table.train_trial_test_semi ...
    result_table.train_trial_test_cond ...
    ];
% train on condition
train_cond = [ ...
    result_table.train_cond_test_trial ...
    result_table.train_cond_test_run ...
    result_table.train_cond_test_quarter ...
    result_table.train_cond_test_semi ...
    result_table.train_cond_test_cond ...
    ];

% plotting
figure;
hold on
lpp_plot_shading([1 2 3 4 5], mean(train_trial), ste(train_trial), 'marker', 's','alpha',0.4, 'color', cols_blind_maps(4,:))
lpp_plot_shading([1 2 3 4 5], mean(train_cond), ste(train_cond), 'marker', 'o','alpha',0.4, 'color', cols_blind_maps(6,:))
lpp_plot_set([0.4 1.02], [0.4 0.5 0.6 0.7 0.8 0.9 1], false, [0.5 5.5], [1 2 3 4 5], false, [303   472   300   250])
lpp_plot_break_yaxis([.40 0.60 0.60 0.40], [0.44 0.46 0.48 0.46]) % break y-axis
hold off

% file save
% savename = fullfile(figdir, 'fig7d_right.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% multilevel
dum = [1,2,3,4,5]; sub=44;

y = train_cond'; % uncomment this line to do multi-level GLM for this data
% y = train_trial'; % uncomment this line to do multi-level GLM for this data
x = repmat(dum,sub,1)';

for i = 1:size(y, 2), YY{i} = y(:, i); end
for i = 1:size(y, 2), XX{i} = x(:, i); end

stats = glmfit_multilevel(YY, XX, [], 'verbose','weighted','boot','nresample', 10000);