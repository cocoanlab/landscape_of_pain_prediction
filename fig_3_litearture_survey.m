% Fig 3. Survey results of neuroimaging-based predictive models of pain
%   3a. Studies: Measurement tools
%   3b. Studies: Populations
%   3c. Models
%   3d. Sample size
%% Set up
clear; clc;

% Load Data 
basedir = '/Users/donghee/Documents/project'; % set a path to local project directory
githubdir = '/Users/donghee/github'; % set a path to local git directory
figdir = fullfile(basedir, 'figures');

load(fullfile(basedir,'data/survey_result.mat')); % 'survey' results

load(fullfile(basedir, 'colormap_blind_wani.mat')); % color map

% Load libraries
addpath(genpath(fullfile(githubdir, 'CanlabCore')));
%% Fig 3a Studies: Measurement tools
clearvars -except basedir githubdir figdir survey cols_blind_maps; clc;

study_table = table(survey.study.study_year, survey.study.study_tooltype);
gs = groupsummary(study_table,["Var2","Var1"],'IncludeEmptyGroups',true);
study_table_sum = unstack(gs,'GroupCount','Var1');
study_matrix_sum = study_table_sum{:,2:end};

% change the order of years
study_matrix_sum_new(1,:) = study_matrix_sum(3,:);
study_matrix_sum_new(2,:) = study_matrix_sum(1,:);
study_matrix_sum_new(3,:) = study_matrix_sum(4,:);
study_matrix_sum_new(4,:) = study_matrix_sum(2,:);

% change the order of tool types
study_tooltypes = unique(survey.study.study_tooltype);
study_tooltypes_new(1) = study_tooltypes(3);
study_tooltypes_new(2) = study_tooltypes(1);
study_tooltypes_new(3) = study_tooltypes(4);
study_tooltypes_new(4) = study_tooltypes(2);

% years label
study_years = unique(survey.study.study_year);

% proportion
study_tooltypes2 = string(unique(survey.study.study_tooltype));
study_tooltype_list = string(survey.study.study_tooltype);

for i = 1:numel(study_tooltypes2)
    prop = numel(study_tooltype_list(study_tooltype_list == study_tooltypes2(i)));
    study_tooltype_prop(i) = prop/numel(study_tooltype_list);
end

% Pie chart
figure(1)
p = wani_pie(sort(study_tooltype_prop,'descend'),'fontsize', 18,'hole','hole_size', 4500);
p(1).FaceColor = cols_blind_maps(7,:);
p(3).FaceColor = cols_blind_maps(6,:);
p(5).FaceColor = cols_blind_maps(2,:);
p(7).FaceColor = cols_blind_maps(4,:);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3a_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% Bar plot (2009~2019)
figure(2) 
b = bar(study_years(1:11),study_matrix_sum_new(:,1:11)', 'stacked', 'LineWidth', 1.2);
b(1).FaceColor = cols_blind_maps(7,:);
b(2).FaceColor = cols_blind_maps(6,:);
b(3).FaceColor = cols_blind_maps(2,:);
b(4).FaceColor = cols_blind_maps(4,:);
set(gca, 'fontsize', 18, 'linewidth', 2, 'ylim', [0 14],'tickdir', 'out', 'box', 'off');
xtickangle(45)
set(gca,'ticklength', [.02 .02])
set(gca,'YTick',[0 2 4 6 8 10 12])
set(gcf, 'position', [303   472   300   300])
xlabel('Years');
ylabel('Number of papers');
legend(study_tooltypes_new,'Location','northwest');

% file save
% savename = fullfile(figdir, 'fig3a_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% Fig 3b Studies: Populations
clearvars -except basedir githubdir figdir survey cols_blind_maps; clc;

% healthy and clinical populations
study_population_total = numel(survey.study.study_population);
study_population_healthy = sum(contains(survey.study.study_population,'Healthy'));
study_population_clinical = sum(contains(survey.study.study_population,'Clinical'));
study_population_prop = [study_population_clinical study_population_healthy]/study_population_total;

% clinical pain types
study_clipain_num = [];
clipain_types = unique(survey.study.study_clinpain);
clipain_types = clipain_types(2:end);
for i = 1:numel(clipain_types)
    study_clipain_num(i) = sum(contains(survey.study.study_clinpain, clipain_types(i)));
end

study_clipain_prop = study_clipain_num / sum(study_clipain_num);
study_clipain_prop = sort(study_clipain_prop, 'descend');
study_clipain_prop = [study_clipain_prop*study_population_prop(1) study_population_prop(2)]; % 16 clinical pain & healthy population

% Pie chart: Clinical and Healthy populations
figure(3)
wani_pie(study_population_prop,'hole','hole_size', 4500,'cols',cols_blind_maps([8 3],:));
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3b_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% Pie chart: Types of clinical populstion
figure(4)
[~,idx] = sort(study_clipain_prop(1:end-1), 'descend');
clipain_types(idx) % print clinical pain types (note: 'Fibromyalgia(FM), back pain' actually means 'back pain')
p = wani_pie(study_clipain_prop,'hole','hole_size',4500,'notext');
p(33).FaceColor = "none";
p(33).FaceAlpha = 0;
p(33).EdgeAlpha = 0;
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3b_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% Fig 3c Models
clearvars -except basedir githubdir figdir survey cols_blind_maps; clc;

%%% (1) prediction task
clf;
model_tasks = string(unique(survey.model.task));
model_task_list = string(survey.model.task);

for i = 1:numel(model_tasks)
    prop = numel(model_task_list(model_task_list == model_tasks(i)));
    model_task_prop(i) = prop/numel(model_task_list);
end
model_task_prop = sort(model_task_prop, 'descend');

figure(5)
wani_pie(model_task_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (2) target
clf;
model_targets = string(unique(survey.model.target));
model_target_list = string(survey.model.target);

for i = 1:numel(model_targets)
    prop = numel(model_target_list(model_target_list == model_targets(i)));
    prop_list(i) = prop;
    model_target_prop(i) = prop/numel(model_target_list); 
end
model_target_prop = sort(model_target_prop, 'descend');

figure(5)
wani_pie(model_target_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (3) model levels
clf;
model_model_levels = string(unique(survey.model.level));
model_model_level_list = string(survey.model.level);

for i = 1:numel(model_model_levels)
    prop = numel(model_model_level_list(model_model_level_list == model_model_levels(i)));
    model_model_level_prop(i) = prop/numel(model_model_level_list); 
end
model_model_level_prop = sort(model_model_level_prop, 'descend');

figure(5)
wani_pie(model_model_level_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_3.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (4) (train) data levels
clf;
model_train_data_levels = string(unique(survey.model.train_data_level));
model_train_data_level_list = string(survey.model.train_data_level);

for i = 1:numel(model_train_data_levels)
    prop = numel(model_train_data_level_list(model_train_data_level_list == model_train_data_levels(i)));
    model_train_data_level_prop(i) = prop/numel(model_train_data_level_list); 
end
model_train_data_level_prop = sort(model_train_data_level_prop, 'descend');

figure(5)
wani_pie(model_train_data_level_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_4.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (5) spatial scales
clf;
model_spaital_scales = string(unique(survey.model.feature_spatial_scale));
model_spaital_scale_list = string(survey.model.feature_spatial_scale);

for i = 1:numel(model_spaital_scales)
    prop = numel(model_spaital_scale_list(model_spaital_scale_list == model_spaital_scales(i)));
    model_spatial_scale_prop(i) = prop/numel(model_spaital_scale_list); 
end
model_spatial_scale_prop = sort(model_spatial_scale_prop, 'descend');

figure(5)
wani_pie(model_spatial_scale_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_5.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (6) experimental tasks
clf;
model_experimental_tasks = string(unique(survey.model.feature_task));
model_experimental_task_list = string(survey.model.feature_task);
model_experimental_task_list = strrep(model_experimental_task_list, "T1 image", "Structure");
model_experimental_tasks = unique(model_experimental_task_list);

for i = 1:numel(model_experimental_tasks)
    prop = numel(model_experimental_task_list(model_experimental_task_list == model_experimental_tasks(i)));
    model_experimental_task_prop(i) = prop/numel(model_experimental_task_list); 
end
model_experimental_task_prop = sort(model_experimental_task_prop, 'descend');

idx = [1 2 5 3 4]; % for exclusion of structural studies
model_experimental_task_prop = model_experimental_task_prop(:, idx);
model_experimental_tasks = model_experimental_tasks(idx);

figure(5)
wani_pie(model_experimental_task_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_6.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (7) feature types
clf;
model_feature_methods = string(unique(survey.model.feature_method));
model_feature_method_list = string(survey.model.feature_method);

for i = 1:numel(model_feature_methods)
    prop = numel(model_feature_method_list(model_feature_method_list == model_feature_methods(i)));
    model_feature_method_prop(i) = prop/numel(model_feature_method_list); 
end
model_feature_method_prop = sort(model_feature_method_prop, 'descend');

figure(5)
wani_pie(model_feature_method_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_7.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (8) algorithms
clf;
model_algorithms = string(unique(survey.model.algorithm));
model_algorithm_list = string(survey.model.algorithm);

for i = 1:numel(model_algorithms)
    prop = numel(model_algorithm_list(model_algorithm_list == model_algorithms(i)));
    model_algorithm_prop(i) = prop/numel(model_algorithm_list); 
end
model_algorithm_prop = sort(model_algorithm_prop, 'descend');

figure(5)
wani_pie(model_algorithm_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_8.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%%% (9) validation
clf;
model_validations = string(unique(survey.model.validation));
model_validation_list = string(survey.model.validation);

for i = 1:numel(model_validations)
    prop = numel(model_validation_list(model_validation_list == model_validations(i)));
    model_validation_prop(i) = prop/numel(model_validation_list); 
end
model_validation_prop = sort(model_validation_prop, 'descend');

figure(5)
wani_pie(model_validation_prop,'hole','hole_size',4500);
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3c_9.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

%% Fig 3d Sample size
model_sample_size_studywise = [5 15 14 16 16 23 28 20 66 26 216 32 26 17 ...
    30 91 34 17 20 10 72 108 25 180 137 30 81 18 20 21 19 30 46 96 159 9 ...
    21 34 164 53 140 30 32 24 26 14 84 114 29 34 35 52 68 45 110 70 29 47 ...
    23 14 94 52 10 8 51 19]; % remove repeated samples in studies
% box plot
figure(6)
boxplot_wani_2016(model_sample_size_studywise', ...
    'linewidth', 2, 'boxlinewidth', 1, 'mediancolor', 'r', 'medianlinewidth', 2, ...
    'violin')
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3d_1.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure

% histogram
figure(7)
h = histogram(model_sample_size_studywise, 'BinWidth', 25, 'FaceColor', [0.4603    0.4603    0.4603], 'linewidth', 1.2);
set(gca, 'fontsize', 18, 'linewidth', 1.2, 'ylim', [0 30],'tickdir', 'out', 'box', 'off');
set(gca,'ticklength', [.02 .02])
set(gca,'YTick',[0 5 10 15 20 25])
set(gca,'XTick',[0 50 100 150 200])
xlabel('Sample size');
ylabel('Counts');
set(gcf, 'position', [303   472   300   300])

% file save
% savename = fullfile(figdir, 'fig3d_2.pdf'); % uncomment this line to save the figure
% saveas(gcf, savename); % uncomment this line to save the figure