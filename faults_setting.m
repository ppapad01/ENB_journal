function faults_setting(PER)
%%%%%%%%%%

model_name='controller_observer_AllAgents_v5';

load_system([model_name,'.mdl'])

% % Tz    
% add_f_zones=[1];
% mult_f_zones=[2];
% incr_f_zones=[3];
% % Tsa
% add_f_sa=[4];
% mult_f_sa=[5];
% incr_f_sa=[6];
% % Tc Cooing
% add_f_c_C=[7];
% mult_f_c_C=[8];
% incr_f_c_C=[9];
% % mc Cooing
% add_fm_c_C=[10];
% mult_fm_c_C=[11];
% incr_fm_c_C=[12];
% % Tc Heating
% add_f_c_H=[13];
% mult_f_c_H=[14];
% incr_f_c_H=[15];
% % mc Heating
% add_fm_c_H=[16];
% mult_fm_c_H=[18];
% incr_fm_c_H=[17];

%Tz    
add_f_zones=[10];
mult_f_zones=[];
incr_f_zones=[];
% Tsa
add_f_sa=[];
mult_f_sa=[];
incr_f_sa=[];
% Tc Cooing
add_f_c_C=[];
mult_f_c_C=[];
incr_f_c_C=[];
% Tc Heating
add_f_c_H=[];
mult_f_c_H=[];
incr_f_c_H=[];
% mc Cooing
add_fm_c_C=[];
mult_fm_c_C=[];
incr_fm_c_C=[];
% mc Heating
add_fm_c_H=[];
mult_fm_c_H=[];
incr_fm_c_H=[];



for i=1:numel(building.zone)
% Tz    
z_day_ofthe_add_fault=1; % 1 --> second day
z_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).z_additive_Sensor_fault_time=60*60*24*(z_day_ofthe_add_fault + z_time_ofthe_add_fault);
building.zone(i).z_additive_Sensor_fault_value=0;    

if ismember(i,add_f_zones)
    building.zone(i).z_additive_Sensor_fault_value=building.zone(i).TzRef*PER; %;20;
end
%%
z_day_ofthe_mult_fault=1; % 1 --> second day
z_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).z_mult_Sensor_fault_time=60*60*24*(z_day_ofthe_mult_fault + z_time_ofthe_mult_fault);
building.zone(i).z_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_f_zones)
    building.zone(i).z_mult_Sensor_fault_value=1.1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
z_day_ofthe_incr_fault=1; % 1 --> second day
z_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).z_incr_Sensor_fault_time=60*60*24*(z_day_ofthe_incr_fault + z_time_ofthe_incr_fault);
building.zone(i).z_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_f_zones)
    building.zone(i).z_incr_Sensor_fault_value=10;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step'],'Time',['building.zone(' , num2str(i) , ').z_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step'],'After',['building.zone(' , num2str(i) , ').z_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Constant'],'Value',['building.zone(' , num2str(i) , ').z_mult_Sensor_fault_time']);    

set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Gain'],'Gain',['building.zone(' , num2str(i) , ').z_mult_Sensor_fault_value']);    


set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step1'],'Time',['building.zone(' , num2str(i) , ').z_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Gain1'],'Gain',['building.zone(' , num2str(i) , ').z_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tz_' building.zone(i).tag '/Constant2'],'Value',['building.zone(' , num2str(i) , ').z_incr_Sensor_fault_time']);    


%% Tsa
sa_day_ofthe_add_fault=1; % 1 --> second day
sa_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).sa_additive_Sensor_fault_time=60*60*24*(sa_day_ofthe_add_fault + sa_time_ofthe_add_fault);
building.zone(i).sa_additive_Sensor_fault_value=0;    

if ismember(i,add_f_sa)
    building.zone(i).sa_additive_Sensor_fault_value=-10;
end
%%
sa_day_ofthe_mult_fault=1; % 1 --> second day
sa_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).sa_mult_Sensor_fault_time=60*60*24*(sa_day_ofthe_mult_fault + sa_time_ofthe_mult_fault);
building.zone(i).sa_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_f_sa)
    building.zone(i).sa_mult_Sensor_fault_value=1.5;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
sa_day_ofthe_incr_fault=1; % 1 --> second day
sa_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).sa_incr_Sensor_fault_time=60*60*24*(sa_day_ofthe_incr_fault + sa_time_ofthe_incr_fault);
building.zone(i).sa_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_f_sa)
    building.zone(i).sa_incr_Sensor_fault_value=10;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step'],'Time',['building.zone(' , num2str(i) , ').sa_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step'],'After',['building.zone(' , num2str(i) , ').sa_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Constant'],'Value',['building.zone(' , num2str(i) , ').sa_mult_Sensor_fault_time']);    

set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Gain'],'Gain',['building.zone(' , num2str(i) , ').sa_mult_Sensor_fault_value']);    


set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step1'],'Time',['building.zone(' , num2str(i) , ').sa_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Gain1'],'Gain',['building.zone(' , num2str(i) , ').sa_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tsa_' building.zone(i).tag '/Constant2'],'Value',['building.zone(' , num2str(i) , ').sa_incr_Sensor_fault_time']);    


%% Tc Cooing 
c_C_day_ofthe_add_fault=1; % 1 --> second day
c_C_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_C_additive_Sensor_fault_time=60*60*24*(c_C_day_ofthe_add_fault + c_C_time_ofthe_add_fault);
building.zone(i).c_C_additive_Sensor_fault_value=0;    

if ismember(i,add_f_c_C)
    building.zone(i).c_C_additive_Sensor_fault_value=-10;
end
%%
c_C_day_ofthe_mult_fault=1; % 1 --> second day
c_C_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_C_mult_Sensor_fault_time=60*60*24*(c_C_day_ofthe_mult_fault + c_C_time_ofthe_mult_fault);
building.zone(i).c_C_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_f_c_C)
    building.zone(i).c_C_mult_Sensor_fault_value=1.5;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
c_C_day_ofthe_incr_fault=1; % 1 --> second day
c_C_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_C_incr_Sensor_fault_time=60*60*24*(c_C_day_ofthe_incr_fault + c_C_time_ofthe_incr_fault);
building.zone(i).c_C_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_f_c_C)
    building.zone(i).c_C_incr_Sensor_fault_value=10;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step'],'Time',['building.zone(' , num2str(i) , ').c_C_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step'],'After',['building.zone(' , num2str(i) , ').c_C_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Constant'],'Value',['building.zone(' , num2str(i) , ').c_C_mult_Sensor_fault_time']);    

set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Gain'],'Gain',['building.zone(' , num2str(i) , ').c_C_mult_Sensor_fault_value']);    

% set up the incipient sensor fault 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step1'],'Time',['building.zone(' , num2str(i) , ').c_C_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Gain1'],'Gain',['building.zone(' , num2str(i) , ').c_C_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Cooling/Constant2'],'Value',['building.zone(' , num2str(i) , ').c_C_incr_Sensor_fault_time']);    


%% Tc Heating
c_H_day_ofthe_add_fault=1; % 1 --> second day
c_H_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_H_additive_Sensor_fault_time=60*60*24*(c_H_day_ofthe_add_fault + c_H_time_ofthe_add_fault);
building.zone(i).c_H_additive_Sensor_fault_value=0;    

if ismember(i,add_f_c_H)
    building.zone(i).c_H_additive_Sensor_fault_value=10;
end
%%
c_H_day_ofthe_mult_fault=1; % 1 --> second day
c_H_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_H_mult_Sensor_fault_time=60*60*24*(c_H_day_ofthe_mult_fault + c_H_time_ofthe_mult_fault);
building.zone(i).c_H_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_f_c_H)
    building.zone(i).c_H_mult_Sensor_fault_value=1.50;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
c_H_day_ofthe_incr_fault=1; % 1 --> second day
c_H_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).c_H_incr_Sensor_fault_time=60*60*24*(c_H_day_ofthe_incr_fault + c_H_time_ofthe_incr_fault);
building.zone(i).c_H_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_f_c_H)
    building.zone(i).c_H_incr_Sensor_fault_value=10;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step'],'Time',['building.zone(' , num2str(i) , ').c_H_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step'],'After',['building.zone(' , num2str(i) , ').c_H_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Constant'],'Value',['building.zone(' , num2str(i) , ').c_H_mult_Sensor_fault_time']);    

set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Gain'],'Gain',['building.zone(' , num2str(i) , ').c_H_mult_Sensor_fault_value']);    

set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step1'],'Time',['building.zone(' , num2str(i) , ').c_H_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Gain1'],'Gain',['building.zone(' , num2str(i) , ').c_H_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tc_' building.zone(i).tag '_Heating/Constant2'],'Value',['building.zone(' , num2str(i) , ').c_H_incr_Sensor_fault_time']);    


%% mc Cooing
mc_C_day_ofthe_add_fault=1; % 1 --> second day
mc_C_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_C_additive_Sensor_fault_time=60*60*24*(mc_C_day_ofthe_add_fault + mc_C_time_ofthe_add_fault);
building.zone(i).mc_C_additive_Sensor_fault_value=0;    

if ismember(i,add_fm_c_C)
    building.zone(i).mc_C_additive_Sensor_fault_value=0.1;
end
%%
mc_C_day_ofthe_mult_fault=1; % 1 --> second day
mc_C_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_C_mult_Sensor_fault_time=60*60*24*(mc_C_day_ofthe_mult_fault + mc_C_time_ofthe_mult_fault);
building.zone(i).mc_C_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_fm_c_C)
    building.zone(i).mc_C_mult_Sensor_fault_value=2;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
mc_C_day_ofthe_incr_fault=1; % 1 --> second day
mc_C_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_C_incr_Sensor_fault_time=60*60*24*(mc_C_day_ofthe_incr_fault + mc_C_time_ofthe_incr_fault);
building.zone(i).mc_C_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_fm_c_C)
    building.zone(i).mc_C_incr_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step'],'Time',['building.zone(' , num2str(i) , ').mc_C_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step'],'After',['building.zone(' , num2str(i) , ').mc_C_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Constant'],'Value',['building.zone(' , num2str(i) , ').mc_C_mult_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Gain'],'Gain',['building.zone(' , num2str(i) , ').mc_C_mult_Sensor_fault_value']);    


set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step1'],'Time',['building.zone(' , num2str(i) , ').mc_C_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Gain1'],'Gain',['building.zone(' , num2str(i) , ').mc_C_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Cooling/Constant2'],'Value',['building.zone(' , num2str(i) , ').mc_C_incr_Sensor_fault_time']);    


%% mc Heating
    
mc_H_day_ofthe_add_fault=1; % 1 --> second day
mc_H_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_H_additive_Sensor_fault_time=60*60*24*(mc_H_day_ofthe_add_fault + mc_H_time_ofthe_add_fault);
building.zone(i).mc_H_additive_Sensor_fault_value=0;    

if ismember(i,add_fm_c_H)
    building.zone(i).mc_H_additive_Sensor_fault_value=-0.2;
end
%%
mc_H_day_ofthe_mult_fault=1; % 1 --> second day
mc_H_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_H_mult_Sensor_fault_time=60*60*24*(mc_H_day_ofthe_mult_fault + mc_H_time_ofthe_mult_fault);
building.zone(i).mc_H_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault

if ismember(i,mult_fm_c_H)
    building.zone(i).mc_H_mult_Sensor_fault_value=2;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%
% set up the incr sensor fault 
mc_H_day_ofthe_incr_fault=1; % 1 --> second day
mc_H_time_ofthe_incr_fault=0.5; % 0.5 --> @ 12:00

building.zone(i).mc_H_incr_Sensor_fault_time=60*60*24*(mc_H_day_ofthe_incr_fault + mc_H_time_ofthe_incr_fault);
building.zone(i).mc_H_incr_Sensor_fault_value=0;  % 0 --> no fault  ,  1 --> 1 fault

if ismember(i,incr_fm_c_H)
    building.zone(i).mc_H_incr_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
%%

% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step'],'Time',['building.zone(' , num2str(i) , ').mc_H_additive_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step'],'After',['building.zone(' , num2str(i) , ').mc_H_additive_Sensor_fault_value']);    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Constant'],'Value',['building.zone(' , num2str(i) , ').mc_H_mult_Sensor_fault_time']);    

set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Gain'],'Gain',['building.zone(' , num2str(i) , ').mc_H_mult_Sensor_fault_value']);    

% set up the incipient sensor fault 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step1'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step1'],'Time',['building.zone(' , num2str(i) , ').mc_H_incr_Sensor_fault_time']);    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step1'],'Before','0');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Step1'],'After','1');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Gain1'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Gain1'],'Gain',['building.zone(' , num2str(i) , ').mc_H_incr_Sensor_fault_value']); 
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Constant2'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_mc_' building.zone(i).tag '_Heating/Constant2'],'Value',['building.zone(' , num2str(i) , ').mc_H_incr_Sensor_fault_time']);    



end

%% Tamb Tst_C Tst_Heating

add_f_Tamb=0; add_f_Tst_C=0; add_f_Tst_H=0;
mult_f_Tamb=0; mult_f_Tst_C=0; mult_f_Tst_H=0;
    
Tamb_day_ofthe_add_fault=1; % 1 --> second day
Tamb_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00
Tamb_additive_Sensor_fault_time=60*60*24*(Tamb_day_ofthe_add_fault + Tamb_time_ofthe_add_fault);
Tamb_additive_Sensor_fault_value=0;    
if ismember(1,add_f_Tamb)
    Tamb_additive_Sensor_fault_value=10;
end
Tamb_day_ofthe_mult_fault=1; % 1 --> second day
Tamb_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00
Tamb_mult_Sensor_fault_time=60*60*24*(Tamb_day_ofthe_mult_fault + Tamb_time_ofthe_mult_fault);
Tamb_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault
if ismember(1,mult_f_Tamb)
    Tamb_mult_Sensor_fault_value=1.1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tamb/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tamb/Step'],'Time','Tamb_additive_Sensor_fault_time');    
set_param([model_name,'/Controller/Fault_Tamb/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tamb/Step'],'After','Tamb_additive_Sensor_fault_value');    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tamb/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tamb/Constant'],'Value','Tamb_mult_Sensor_fault_time');    

set_param([model_name,'/Controller/Fault_Tamb/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tamb/Gain'],'Gain','Tamb_mult_Sensor_fault_value');    

%%

Tst_C_day_ofthe_add_fault=1; % 1 --> second day
Tst_C_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00
Tst_C_additive_Sensor_fault_time=60*60*24*(Tst_C_day_ofthe_add_fault + Tst_C_time_ofthe_add_fault);
Tst_C_additive_Sensor_fault_value=0;    
if ismember(1,add_f_Tst_C)
    Tst_C_additive_Sensor_fault_value=10;
end
Tst_C_day_ofthe_mult_fault=1; % 1 --> second day
Tst_C_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00
Tst_C_mult_Sensor_fault_time=60*60*24*(Tst_C_day_ofthe_mult_fault + Tst_C_time_ofthe_mult_fault);
Tst_C_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault
if ismember(1,mult_f_Tst_C)
    Tst_C_mult_Sensor_fault_value=1.1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tst_Cooling/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tst_Cooling/Step'],'Time','Tst_C_additive_Sensor_fault_time');    
set_param([model_name,'/Controller/Fault_Tst_Cooling/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tst_Cooling/Step'],'After','Tst_C_additive_Sensor_fault_value');    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tst_Cooling/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tst_Cooling/Constant'],'Value','Tst_C_mult_Sensor_fault_time');    

set_param([model_name,'/Controller/Fault_Tst_Cooling/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tst_Cooling/Gain'],'Gain','Tst_C_mult_Sensor_fault_value');  

%%

Tst_H_day_ofthe_add_fault=1; % 1 --> second day
Tst_H_time_ofthe_add_fault=0.5; % 0.5 --> @ 12:00
Tst_H_additive_Sensor_fault_time=60*60*24*(Tst_H_day_ofthe_add_fault + Tst_H_time_ofthe_add_fault);
Tst_H_additive_Sensor_fault_value=0;    
if ismember(1,add_f_Tst_H)
    Tst_H_additive_Sensor_fault_value=10;
end
Tst_H_day_ofthe_mult_fault=1; % 1 --> second day
Tst_H_time_ofthe_mult_fault=0.5; % 0.5 --> @ 12:00
Tst_H_mult_Sensor_fault_time=60*60*24*(Tst_H_day_ofthe_mult_fault + Tst_H_time_ofthe_mult_fault);
Tst_H_mult_Sensor_fault_value=1;  % 1 --> no fault  ,  1.1 --> 10% fault
if ismember(1,mult_f_Tst_H)
    Tst_H_mult_Sensor_fault_value=1.1;  % 1 --> no fault  ,  1.1 --> 10% fault
end
% set up the additive sensor fault 
set_param([model_name,'/Controller/Fault_Tst_Heating/Step'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tst_Heating/Step'],'Time','Tst_H_additive_Sensor_fault_time');    
set_param([model_name,'/Controller/Fault_Tst_Heating/Step'],'Before','0');    
set_param([model_name,'/Controller/Fault_Tst_Heating/Step'],'After','Tst_H_additive_Sensor_fault_value');    

% set up the multiplicative sensor fault 
set_param([model_name,'/Controller/Fault_Tst_Heating/Constant'],'SampleTime','Ts');
set_param([model_name,'/Controller/Fault_Tst_Heating/Constant'],'Value','Tst_H_mult_Sensor_fault_time');    

set_param([model_name,'/Controller/Fault_Tst_Heating/Gain'],'SampleTime','Ts');    
set_param([model_name,'/Controller/Fault_Tst_Heating/Gain'],'Gain','Tst_H_mult_Sensor_fault_value');  

end
