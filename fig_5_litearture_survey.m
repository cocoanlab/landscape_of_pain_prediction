% Fig 5. Survey results 2: Model performance across different data levels, spatial scales, model levels, and sample sizes.
%   5a. Train Data Levels
%   5b. Spatial Scales
%   5c. Model Levels
%   5d. Sample size
%% Set up
clear; clc;

% Load Data
basedir = '/Users/donghee/Documents/project'; % set a path to local project directory
figdir = fullfile(basedir, 'figures');

svm_model = readtable(fullfile(basedir, 'data/survey_result_cls_model.csv'));
main_targets_idx = contains(svm_model.target,{'Pain vs. no pain','Low pain vs. High pain'});
svm_model_filter = svm_model(main_targets_idx,:);

svm_test = readtable(fullfile(basedir, 'data/survey_result_cls_test.csv'));
main_targets_idx2 = contains(svm_test.target,{'Pain vs. no pain','Low pain vs. High pain'});
svm_test_filter = svm_test(main_targets_idx2,:);

pcr_model = readtable(fullfile(basedir, 'data/survey_result_reg_model.csv'));
main_targets_idx = contains(pcr_model.target,{'Pain rating'});
pcr_model_filter = pcr_model(main_targets_idx,:);

pcr_test = readtable(fullfile(basedir, 'data/survey_result_reg_test.csv'));
main_targets_idx2 = contains(pcr_test.target,{'Pain rating'});
pcr_test_filter = pcr_test(main_targets_idx2,:);

load(fullfile(basedir, 'colormap_blind_wani.mat')); % color map

%% Fig 5a Train Data Level
clearvars -except basedir svm_model_filter svm_test_filter pcr_model_filter pcr_test_filter cols_blind_maps
acc_tr = svm_model_filter.acc(strcmp(svm_model_filter.trainDataLevel,'Tr-level'));
acc_trial = svm_model_filter.acc(strcmp(svm_model_filter.trainDataLevel,'Trial-level'));
acc_cond = svm_model_filter.acc(strcmp(svm_model_filter.trainDataLevel,'Condition-level'));
fake = ones(length(acc_trial),1)*9999;

acc_trb2 = svm_test_filter.acc(strcmp(svm_test_filter.trainDataLevel, 'Tr bin-level'));
acc_trial2 = svm_test_filter.acc(strcmp(svm_test_filter.trainDataLevel, 'Trial-level'));
acc_cond2 = svm_test_filter.acc(strcmp(svm_test_filter.trainDataLevel, 'Condition-level'));
fake2 = ones(length(acc_cond2),1)*9999;


result = {fake, fake2, ... % tr
          fake, fake2, ... % tr bin
          acc_trial, fake2, ... % trial
          acc_cond, acc_cond2}; % condition

cols = repmat(cols_blind_maps([2 4],:), 4,1);

figure(1);
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
scatter([1 4 4 6],[acc_tr acc_trb2' acc_trial2], 50,[cols(1,:); cols(2,:);cols(2,:);cols(2,:)], 'filled', 'MarkerFaceAlpha', .7, 'jitter' ,'on')
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [30 125],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:8,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'TR', 'TR-bin', 'Trial', 'Condition'})
xtickangle(45);
% set(gca,'YTickLabel',{}) %40 60 80 100
set(gca,'YTick',[40 60 80 100])
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Accuracy (%)', 'fontsize', 18);
set(gcf, 'position', [303   472   400   250])

% file save
% savename = fullfile(figdir, 'fig5a_cls.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

corr_tr = pcr_model_filter.corr(strcmp(pcr_model_filter.trainDataLevel,'Tr-level'));
corr_trb = pcr_model_filter.corr(strcmp(pcr_model_filter.trainDataLevel,'Tr bin-level'));
corr_trial = pcr_model_filter.corr(strcmp(pcr_model_filter.trainDataLevel,'Trial-level'));
corr_cond = pcr_model_filter.corr(strcmp(pcr_model_filter.trainDataLevel,'Condition-level'));
corr_ind = pcr_model_filter.corr(strcmp(pcr_model_filter.trainDataLevel,'Individual-level'));
fake1 = corr_trial*999999;

corr_trb2 = pcr_test_filter.corr(strcmp(pcr_test_filter.trainDataLevel,'Tr bin-level'));
corr_trial2 = pcr_test_filter.corr(strcmp(pcr_test_filter.trainDataLevel,'Trial-level'));
corr_cond2 = pcr_test_filter.corr(strcmp(pcr_test_filter.trainDataLevel,'Condition-level'));
corr_etc2 = pcr_test_filter.corr(strcmp(pcr_test_filter.trainDataLevel,'-'));
fake2 = corr_trial*999999;


result = {corr_tr, fake2, ... % tr
          fake1, corr_trb2, ... % tr bin
          corr_trial, corr_trial2, ... % trial
          fake1, corr_cond2, ... % condition
          fake1, fake2, ... % individual
          fake1, fake2};  % -

cols = repmat(cols_blind_maps([7 6],:), 6,1);

figure;
%violinplot(result,'xlabel',{'TR','TR-bin','Trial','Condition'}, 'facecolor', cols, 'pointsize', 5,'pointcolor', cols, 'facealpha', .6, 'mc','none', 'edgecolor',cols);
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
scatter([3 7 9 12], ...
    [corr_trb corr_cond corr_ind corr_etc2], 50, ...
    [cols(1,:);cols(1,:);cols(1,:);cols(2,:)], ...
    'filled', 'MarkerFaceAlpha', .7, 'jitter' ,'on')
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [-0.15 1.25],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:12,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'TR', 'TR-bin', 'Trial', 'Condition', 'Individual', 'Ensemble'})
xtickangle(45);
% set(gca,'YTickLabel',{}) %'0','0.2','0.4','0.6','0.8', '1'
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1])
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Correlation', 'fontsize', 18);
set(gcf, 'position', [303   472   600   250])

% file save
% savename = fullfile(figdir, 'fig5a_reg.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% 5b Spatial Scales
clearvars -except basedir svm_model_filter svm_test_filter pcr_model_filter pcr_test_filter cols_blind_maps
acc_whole = svm_model_filter.acc(strcmp(svm_model_filter.spatialScale, 'Brain-wide'));
acc_comb = svm_model_filter.acc(strcmp(svm_model_filter.spatialScale, 'Combination of regions'));
acc_single = svm_model_filter.acc(strcmp(svm_model_filter.spatialScale, 'Single region'));

acc_whole2 = svm_test_filter.acc(strcmp(svm_test_filter.spatialScale, 'Brain-wide'));
acc_comb2 = svm_test_filter.acc(strcmp(svm_test_filter.spatialScale, 'Combination of regions'));
acc_single2 = svm_test_filter.acc(strcmp(svm_test_filter.spatialScale, 'Single region'));
fake2 = ones(length(acc_whole2),1)*9999;

result = {acc_single, fake2, ... % single region
        acc_comb, fake2, ... % combination of regions
        acc_whole, acc_whole2};% Brain-wide 
    
cols = repmat(cols_blind_maps([2 4],:), 3,1);
    
figure;
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [30 125],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:8,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'Single', 'Combination', 'Brain-wide'})
xtickangle(45);
set(gca,'YTickLabel',{'40','60','80','100',''})
%set(gca,'YTickLabel',{}) %'40','60','80','100',''
set(gca,'YTick',[40 60 80 100])
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Accuracy (%)', 'fontsize', 18);
set(gcf, 'position', [303   472   300   250])

% file save
% savename = fullfile(figdir, 'fig5b_cls.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

corr_bw = pcr_model_filter.corr(strcmp(pcr_model_filter.spatialScale,'Brain-wide'));
corr_bw2 = pcr_test_filter.corr(strcmp(pcr_test_filter.spatialScale,'Brain-wide'));

result = {corr_bw, corr_bw2};
    
cols = repmat(cols_blind_maps([7 6],:), 1,1);

figure;
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [-0.15 1.25],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:12,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'Brain-wide'})
xtickangle(45);
set(gca,'YTickLabel',{'0','0.2','0.4','0.6','0.8', '1'})
%set(gca,'YTickLabel',{}) %'0','0.2','0.4','0.6','0.8', '1'
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1])
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Correlation', 'fontsize', 18);
set(gcf, 'position', [303   472   100   250])

% file save
% savename = fullfile(figdir, 'fig5b_reg.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% 5c  Model Levels
clearvars -except basedir svm_model_filter svm_test_filter pcr_model_filter pcr_test_filter cols_blind_maps

acc_with = svm_model_filter.acc(strcmp(svm_model_filter.modelLevel, 'idiographic model'));
acc_bet = svm_model_filter.acc(strcmp(svm_model_filter.modelLevel, 'population-level model'));

acc_with2 = svm_test_filter.acc(strcmp(svm_test_filter.modelLevel, 'idiographic model'));
acc_bet2 = svm_test_filter.acc(strcmp(svm_test_filter.modelLevel, 'population-level model'));
fake2 = ones(length(acc_bet2),1)*9999;

result = {acc_with, fake2, ... % idiographic
        acc_bet, acc_bet2 }; % population-level
 
    
cols = repmat(cols_blind_maps([2 4],:), 2,1);
    
figure;
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [30 125],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:8,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'Idiographic', 'Population-level'})
xtickangle(45);
set(gca,'YTickLabel',{'40','60','80','100',''})
%set(gca,'YTickLabel',{}) %'40','60','80','100',''
set(gca,'YTick',[40 60 80 100])
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Accuracy (%)', 'fontsize', 18);
set(gcf, 'position', [303   472   200   250])

% file save
% savename = fullfile(figdir, 'fig5c_cls.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

corr_with = pcr_model_filter.corr(strcmp(pcr_model_filter.modelLevel,'idiographic model'));
corr_comb = pcr_model_filter.corr(strcmp(pcr_model_filter.modelLevel,'combination'));
corr_bet = pcr_model_filter.corr(strcmp(pcr_model_filter.modelLevel,'population-level model'));
fake = corr_bet*99999;

corr_bet2 = pcr_test_filter.corr(strcmp(pcr_test_filter.modelLevel,'population-level model'));
corr_etc2 = pcr_test_filter.corr(strcmp(pcr_test_filter.modelLevel,'-'));

result = {corr_with, fake, ... % within
          corr_comb, fake, ... % combination
          corr_bet, corr_bet2, ... % between
          fake, fake};  % -

cols = repmat(cols_blind_maps([7 6],:), 4,1);

figure;
violinplot(result, 'facecolor', cols, 'pointsize', 6,'pointcolor', cols, 'facealpha', .7, 'mc','none', 'edgecolor',cols);
legend(gca,'off');
scatter([8], ...
    [corr_etc2], 50, ...
    [cols(2,:)], ...
    'filled', 'MarkerFaceAlpha', .7, 'jitter' ,'on')
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [-0.15 1.25],'tickdir', 'out', 'box', 'off');
set(gca,'xtick',1.5:2:12,'ticklength', [.02 .02])
set(gca,'XTickLabel',{'Idiographic', 'Combination', 'Population-level', 'Ensemble'})
xtickangle(45);
set(gca,'YTickLabel',{'0','0.2','0.4','0.6','0.8', '1'})
%set(gca,'YTickLabel',{}) %'0','0.2','0.4','0.6','0.8', '1'
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1])
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Correlation', 'fontsize', 18);
set(gcf, 'position', [303   472   600   250])

% file save
% savename = fullfile(figdir, 'fig5c_reg.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% 5d Sample Size
clearvars -except basedir svm_model_filter svm_test_filter pcr_model_filter pcr_test_filter cols_blind_maps

acc1 = [svm_model_filter.acc svm_model_filter.sampleSize];
acc2 = [svm_test_filter.acc svm_test_filter.sampleSize];

acc_all = [acc1;acc2]; % performance, sample size


%    
figure;
hold on
scatter(acc1(:,2), acc1(:,1), 70, cols_blind_maps(2,:),'filled', 'MarkerFaceAlpha', .8, 'jitter' ,'on','jitterAmount', 0.6)
scatter(acc2(:,2), acc2(:,1), 70, cols_blind_maps(4,:),'filled', 'MarkerFaceAlpha', .8, 'jitter' ,'on','jitterAmount', 0.6)
hold off

set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [45 105],'tickdir', 'out', 'box', 'off');
set(gca,'ticklength', [.02 .02])
set(gca,'xtick',0:20:100)
set(gca,'XTickLabel',{'0','20','40','60','80','100'})
% set(gca,'XTickLabel',{}) %'0','20','40','60','80','100',''
set(gca,'YTickLabel',{'50','60','70','80','90','100'})
% set(gca,'YTickLabel',{}) %'50','60','70','80','90','100',''
set(refline([0 100]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Accuracy (%)', 'fontsize', 18);
set(gcf, 'position', [303   472   400   250]);

% file save
% savename = fullfile(figdir, 'fig5d_cls.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

corr1 = [pcr_model_filter.corr pcr_model_filter.sampleSize];
corr2 = [pcr_test_filter.corr pcr_test_filter.sampleSize];

figure;
hold on
scatter(corr1(:,2), corr1(:,1), 70, cols_blind_maps(7,:),'filled', 'MarkerFaceAlpha', .8, 'jitter' ,'on','jitterAmount', 0.6)
scatter(corr2(:,2), corr2(:,1), 70, cols_blind_maps(6,:),'filled', 'MarkerFaceAlpha', .8, 'jitter' ,'on','jitterAmount', 0.6)
hold off
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [-0.05 1.05],'tickdir', 'out', 'box', 'off');
set(gca,'ticklength', [.02 .02])
set(gca,'xtick',0:50:250)
set(gca,'XTickLabel',{'0','50','100','150','200','250'})
set(gca,'YTickLabel',{'0','0.2','0.4','0.6','0.8', '1'})
set(refline([0 1]), 'color', 'k', 'linestyle', '--', 'linewidth', 1.8);
set(refline([0 0]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);
ylabel('Correlation', 'fontsize', 18);
set(gcf, 'position', [303   472   400   250]);

% file save
% savename = fullfile(figdir, 'fig5d_reg.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure