clc; clear all;
warning('off','all')

addpath([getenv('BCVTB_HOME'), '/lib/matlab']);
addpath(pwd) 

addpath([pwd,'\ePlus']) 
addpath([pwd,'\jsonlab']) 
model_name='controller_observer_AllAgents_v5';

load_system([model_name,'.mdl'])

global PER Scenario

sc=[2 4 8 16 32 64 128];
Scenario=7; %1:6
PER= (sc(Scenario))/100; 
disp('Start Configurations')

readepJSONout
disp('Loaded: Json')
faults_setting% (PER,Scenario)
% run('faults_setting_distributed.m')
disp('Faults Loaded')
sim(model_name);
disp('Done')

save(['faultsize_' num2str(Scenario) '.mat'])
%end

disp('ALL Done')
%quit;
