% function DesignParameters(Scenario)

%% Storage Tank
% A_br_st = 0.9;
% [Kst, KstRef, Kstcij, Ksta] = matsplit([(A_st-A_br_st)/B_st, (A_br_st-1)/B_st, Cpw/(Ehp_max*COP), UA_st/(Ehp_max*COP)]);

%% Test %% Corner class 1 Pod 1
format long

SystemParameters_Control
disp('Loaded: System Parameters - Control')

SystemParameters_Observer
disp('Loaded: Systemn Parameters - Observer')

model_name='controller_observer_AllAgents_v5';

%load_system(model_name,'.mdl')
%load_system([model_name,'.mdl'])

%%

large_zones = [2 13 14 15 17 18 19 20 21 22 23 24 25];
correct_zones = [3 4 5 6 7 8 9 10 11 12 19 20 21 22 23 24];
tr_error =[1 10 11 12 16 17];
% h= 0.35*[0.4 0.5 0.4 0.4 0.4 ...
%        0.4 0.4 0.4 0.4 0.4 ...
%        0.4 0.4 0.4 0.5 0.3 ...
%        0.3 0.4 0.4 0.5 0.5 ...
%        0.5 0.5 0.5 0.5 0.5];
h= 0.1*ones(1,25);

fsa = [1.25 9 1.25 1.25 1.25 ...
       1.25 1.25 1.25 1.25 1.75 ...
       1.75 1.75 5.5 5 6 ...
       1.5 6 1.5 12.5 12.5 ...
       12.5 12.5 12.5 11 5.5];
msa=fsa*1.25;

%%%%%%%%%%%%% CONTROL -- DESIGN PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

for i=1:numel(building.zone)
    
building.zone(i).TzRef = 23;

building.zone(i).A_br_z =0.8*building.zone(i).control_A_z ;%0.65 %0.85 0.7;%2;% 
building.zone(i).A_br_sa_C = 2.5*1e04*building.zone(i).control_A_sa_C; %0.06; % %1.8*1e04**building.zone(i).A_sa_C; %2.2*1e04**building.zone(i).A_sa_C;
building.zone(i).A_br_c_C = 1.03*building.zone(i).control_A_c_C; %0.98; % %0.95*building.zone(i).A_c_C;
building.zone(i).A_br_sa_H = 2.5*1e04*building.zone(i).control_A_sa_H; %1.8* 0.06; %
building.zone(i).A_br_c_H =1.03*building.zone(i).control_A_c_H; %0.95 % 0.98; % 
building.zone(i).hi = 0.1; %0.1;%0*0.0002;

%%
 m_max=3;
 Ni=1;
% 

%%  Zone
[building.zone(i).Ke, building.zone(i).Kz, building.zone(i).Kza] =....
    matsplit([ (building.zone(i).control_A_z-building.zone(i).A_br_z)/building.zone(i).control_B_z,...
    (building.zone(i).control_A_z-1)/building.zone(i).control_B_z, ...
    building.zone(i).a_z/(building.zone(i).m_sa*Cpa)]);
building.zone(i).Kij = (1/(building.zone(i).m_sa*Cpa))*building.zone(i).a_int;


%% set up constant control gains for ZONE - cooling
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/ZoneControlGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').Ke; building.zone(' , num2str(i) , ').Kz; transpose(building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').Kza; building.zone(' , num2str(i) , ').hi]']);

%% set up number of neighbours Controller
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Demux'],'Outputs',...
    ['[1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Demux'],'Outputs',...
    ['[1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling_Mux'],'Inputs',...
    ['[1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating_Mux'],'Inputs',...
    ['[1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour)]']);

% set up the sampling time of blocks
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/ZoneControlGains'],'SampleTime','Ts');


%% set up constant control gains for ZONE - heating
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/ZoneControlGains'],'Value',...
['[building.zone(' , num2str(i) , ').Ke; building.zone(' , num2str(i) , ').Kz; transpose(building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').Kza; building.zone(' , num2str(i) , ').hi]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/ZoneControlGains'],'SampleTime','Ts');


%% set up zone temperature reference
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/TzRef'],'Value',['building.zone(' , num2str(i) , ').TzRef']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/TzRef'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/TzRef'],'Value',['building.zone(' , num2str(i) , ').TzRef']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/TzRef'],'SampleTime','Ts');

%% set up sampling time
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Dot Product2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Dot Product2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Gain2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Gain2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Subtract1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Subtract1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Add'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Add'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Unit Delay'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Unit Delay'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Dot Product1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Dot Product1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Gain1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Gain1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Gain'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Gain'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Dot Product'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Dot Product'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Add1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Add1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Subtract'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Subtract'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Divide1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Divide1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Gain3'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Gain3'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Product'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Product'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Divide'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Divide'],'SampleTime','Ts');


%%  Cooling Supply Air
[building.zone(i).Kesa_C, building.zone(i).Ksa_C, building.zone(i).K_C,...
    building.zone(i).Kma_C, building.zone(i).Kf_C] = ...
    matsplit([ (building.zone(i).control_A_sa_C-building.zone(i).A_br_sa_C)/building.zone(i).control_B_sa_C, ...
    (building.zone(i).control_A_sa_C-1)/building.zone(i).control_B_sa_C,...
    (building.zone(i).m_sa-building.zone(i).m_o)*Cpa/building.zone(i).coilcooling.CWCoil_UA,...
    building.zone(i).m_o*Cpa/building.zone(i).coilcooling.CWCoil_UA,...
    building.zone(i).Wfan*building.zone(i).fan_f/building.zone(i).coilcooling.CWCoil_UA]);

set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/CoilControlGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').Kesa_C; building.zone(' , num2str(i) , ').Ksa_C; building.zone(' , num2str(i) , ').K_C; building.zone(' , num2str(i) , ').Kma_C; building.zone(' , num2str(i) , ').Kf_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/CoilControlGains'],'SampleTime','Ts');



%%  Heating Supply Air
[building.zone(i).Kesa_H, building.zone(i).Ksa_H, building.zone(i).K_H,...
    building.zone(i).Kma_H, building.zone(i).Kf_H] = ...
    matsplit([ (building.zone(i).control_A_sa_H-building.zone(i).A_br_sa_H)/building.zone(i).control_B_sa_H, ...
    (building.zone(i).control_A_sa_H-1)/building.zone(i).control_B_sa_H, ...
    (building.zone(i).m_sa-building.zone(i).m_o)*Cpa/building.zone(i).coilheating.HWCoil_UA,...
    building.zone(i).m_o*Cpa/building.zone(i).coilheating.HWCoil_UA,...
    building.zone(i).Wfan*building.zone(i).fan_f/building.zone(i).coilheating.HWCoil_UA]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/CoilControlGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').Kesa_H; building.zone(' , num2str(i) , ').Ksa_H; building.zone(' , num2str(i) , ').K_H; building.zone(' , num2str(i) , ').Kma_H; building.zone(' , num2str(i) , ').Kf_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/CoilControlGains'],'SampleTime','Ts');


%%  Cooling Water
[building.zone(i).Kec_C, building.zone(i).Kc_C, building.zone(i).Kcsa_C] =...
    matsplit([(building.zone(i).control_A_c_C-building.zone(i).A_br_c_C)/building.zone(i).control_B_c_C,...
    (building.zone(i).control_A_c_C-1)/building.zone(i).control_B_c_C, building.zone(i).coilcooling.CWCoil_UA/Cpw]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/ValveControlGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').Kec_C; building.zone(' , num2str(i) , ').Kc_C; building.zone(' , num2str(i) , ').Kcsa_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/ValveControlGains'],'SampleTime','Ts');


%%  Heating Water
[building.zone(i).Kec_H, building.zone(i).Kc_H, building.zone(i).Kcsa_H] =...
    matsplit([(building.zone(i).control_A_c_H-building.zone(i).A_br_c_H)/building.zone(i).control_B_c_H, ...
    (building.zone(i).control_A_c_H-1)/building.zone(i).control_B_c_H, building.zone(i).coilheating.HWCoil_UA/Cpw]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/ValveControlGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').Kec_H; building.zone(' , num2str(i) , ').Kc_H; building.zone(' , num2str(i) , ').Kcsa_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/ValveControlGains'],'SampleTime','Ts');


%%  set up mat file records

global Scenario

currentFolder = pwd;
idcs   = strfind(currentFolder,'\');
newdir = currentFolder(1:idcs(end)-1);

folder=['Results_fz19_sensor_',num2str(Scenario)];

mkdir([newdir,'\',folder])
addpath([newdir,'\',folder])

dirc= [newdir,'\',folder];
%  cooling




set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tz_mat'],'FileName',...
    [dirc, '\Tz_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/er_Tz_mat'],'FileName',...
    [dirc, '\er_Tz_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tz_ref_mat'],'FileName',...
    [dirc, '\Tz_ref_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/zone_gains_mat'],'FileName',...
    [dirc, '\zone_gains_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/K_I_mat'],'FileName',...
    [dirc, '\K_I_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tsa_ref_mat'],'FileName',...
    [dirc, '\Tsa_ref_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tc_C_ref_mat'],'FileName',...
    [dirc, '\Tc_C_ref_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tc_C_mat'],'FileName',...
    [dirc, '\Tc_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tsa_mat'],'FileName',...
    [dirc, '\Tsa_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/mc_Tst_Tc_C_mat'],'FileName',...
    [dirc, '\mc_Tst_Tc_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/mc_C_mat'],'FileName',...
    [dirc, '\mc_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/TsTc_err_C_mat'],'FileName',...
    [dirc, '\TsTc_err_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/Tst_Tc_C_mat'],'FileName',...
    [dirc, '\Tst_Tc_C_',building.zone(i).tag, '.mat' ]);


%  heating

set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Tc_H_ref_mat'],'FileName',...
    [dirc, '\Tc_H_ref_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Tc_H_mat'],'FileName',...
    [dirc, '\Tc_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/mc_Tst_Tc_H_mat'],'FileName',...
    [dirc, '\mc_Tst_Tc_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/mc_H_mat'],'FileName',...
    [dirc, '\mc_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/TsTc_err_H_mat'],'FileName',...
    [dirc, '\TsTc_err_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/Tst_Tc_H_mat'],'FileName',...
    [dirc, '\Tst_Tc_H_',building.zone(i).tag, '.mat' ]);
%  control inputs
set_param([model_name,'/Controller/control_inputs_mat'],'FileName',...
    [dirc, '\control_inputs.mat' ]);


%  Max Valve Flow
set_param([model_name,'/Controller/' building.zone(i).tag '_Cooling/MaxValveFlow'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Heating/MaxValveFlow'],'SampleTime','Ts');


mc_MAX=2;

%end

end

%%%%%%%%%%%%% OBSERVER -- DESIGN PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

%%
for i=1:numel(building.zone)
%clc
currentPrecision = digits;
% POLE SELLECTION

pz=eig(building.zone(i).A_z)*0.1;

psa=eig(building.zone(i).A_sa_C);
p1_sa=0.0000000000001; % psa(1)*0.1;
p2_sa=0.0000000002; %psa(2)*0.1;

pcc=eig(building.zone(i).A_c_C);
p1_cc=pcc(1)*0.8;
p2_cc=pcc(2)*0.0087;

phc=eig(building.zone(i).A_c_H);
p1_hc=phc(1)*0.1;
p2_hc=phc(2)*0.2;
p3_hc=phc(3)*0.5;
p4_hc=phc(4)*0.7;

building.zone(i).L =place(building.zone(i).A_z,1,pz);
building.zone(i).L_sa_C =place((building.zone(i).A_sa_C)',(building.zone(i).C_sa_C)',[p1_sa p2_sa])';
building.zone(i).L_sa_H =place((building.zone(i).A_sa_H)',(building.zone(i).C_sa_H)',[p1_sa p2_sa])';
building.zone(i).L_c_C  =place((building.zone(i).A_c_C)',(building.zone(i).C_c_C)',[p1_cc p2_cc])';
building.zone(i).L_c_H =place((building.zone(i).A_c_H)',(building.zone(i).C_c_H)',[p1_hc p2_hc p3_hc p4_hc])';
 
% if abs(pcc(1))<=eps
%  building.zone(i).L_c_C=[4 1]';
% end
% if abs(pcc(2))<=eps
%  building.zone(i).L_c_C=[4 1]';
% end

building.zone(i).AL_z = building.zone(i).A_z - building.zone(i).L ;
%eig(building.zone(i).AL_z)
building.zone(i).AL_sa_C = building.zone(i).A_sa_C - building.zone(i).L_sa_C*building.zone(i).C_sa_C ;
%eig(building.zone(i).AL_sa_C)
%norm(building.zone(i).L_sa_C)
building.zone(i).AL_c_C = building.zone(i).A_c_C - building.zone(i).L_c_C*building.zone(i).C_c_C;
%eig(building.zone(i).AL_c_C)
%norm(building.zone(i).L_c_C)
building.zone(i).AL_sa_H = building.zone(i).A_sa_H - building.zone(i).L_sa_H*building.zone(i).C_sa_H;
%eig(building.zone(i).AL_sa_H)
building.zone(i).AL_c_H = building.zone(i).A_c_H - building.zone(i).L_c_H*building.zone(i).C_c_H;
%eig(building.zone(i).AL_c_H)
%norm(building.zone(i).L_c_H)
  %for i=1:25
%      eig(building.zone(i).AL_sa_C)
%   eig(building.zone(i).AL_c_C)
%        eig(building.zone(i).AL_c_H)
 %  norm(building.zone(i).L_sa_C)
% % % % sys=ss(building.zone(i).AL_c_H,[1 1 1 1]',[0 0 0 1],0,60)
% % % % figure
% % % % step(sys)
%end
%% DETECTION THRESHOLD PARAMETERS

building.zone(i).a= 0.8; % abs(building.zone(i).AL_z)+abs(building.zone(i).AL_z)*500; %*g/h;0.84;
building.zone(i).e_bar=100;
% ZONE UNCERTAINTY BOUND
building.zone(i).Qbar=2;

building.zone(i).a_c_C=0.8; %norm(building.zone(i).AL_c_C);
building.zone(i).e_c_C_bar=100;

building.zone(i).a_SA_C=0.8; %norm(building.zone(i).AL_sa_C);
building.zone(i).e_SA_C_bar=100;
 
building.zone(i).a_c_H=0.6; %0.8 norm(building.zone(i).AL_c_H);
building.zone(i).e_c_H_bar=100;

building.zone(i).a_SA_H=0.7; %norm(building.zone(i).AL_sa_H);
building.zone(i).e_SA_H_bar=100;
    
% SENSOR NOISE BOUND FOR NEIGBOORING ZONES
temp=zeros(1,numel(building.zone(i).Kij));
for j=1:numel(building.zone(i).Kij)
   building.zone(i).n_nei(1,j)=0.3; 
end
    
%% SET UP OBSERVER GAINS for ZONE 

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/ZoneGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').A_z; building.zone(' , num2str(i) , ').B_z; building.zone(' , num2str(i) , ').B_z*transpose(building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').Kza; building.zone(' , num2str(i) , ').L]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/ZoneGains'],'SampleTime','Ts');

%%%%% CHANGE
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Subtract5'],'Inputs','+-');
%%%%%%%%

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Saturation'],'LinearizeAsGain','off');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Saturation1'],'LinearizeAsGain','off');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/ZoneGains'],'Value',...
% ['[building.zone(' , num2str(i) , ').A_z; building.zone(' , num2str(i) , ').B_z; building.zone(' , num2str(i) , ').B_z*transpose(building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').Kza; building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').L]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/ZoneGains'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Demux'],'Outputs',...
    ['[1 1 1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Demux'],'Outputs',...
    ['[1 1 1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Mux1'],'Inputs',...
    ['[1 1 1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Heating_Mux1'],'Inputs',...
%     ['[1 1 1 1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Mux4'],'Inputs',...
    ['[1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Mux4'],'Inputs',...
%     ['[1 1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/4'],'Value',...
    ['[ones(numel(building.zone(' , num2str(i) , ').neighbour),1)]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/4'],'Value',...
%     ['[ones(numel(building.zone(' , num2str(i) , ').neighbour),1)]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/Mux3'],'Inputs',...
    ['[1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);

% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/Mux3'],'Inputs',...
%     ['[1 numel(building.zone(' , num2str(i) , ').neighbour) 1 1]']);

%% Cooling Sa

building.zone(i).Df_SA=[(building.zone(i).Wfan*building.zone(i).fan_f)/building.zone(i).coilcooling.CWCoil_UA 0]';
building.zone(i).Damb_SA=[(building.zone(i).m_o*Cpa)/building.zone(i).coilcooling.CWCoil_UA 0]';
building.zone(i).Dma_SA=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilcooling.CWCoil_UA 0]';

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').A_sa_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_sa_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_sa_C*building.zone(' , num2str(i) , ').Df_SA]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_sa_C*building.zone(' , num2str(i) , ').Damb_SA]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_sa_C*building.zone(' , num2str(i) , ').Dma_SA]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'Value',...
    ['[building.zone(' , num2str(i) , ').L_sa_C]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Csa'],'Value',...
    ['[building.zone(' , num2str(i) , ').C_sa_C]']);


set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'SampleTime','Ts');

    
%% heating SA    
% building.zone(i).Df_H=[building.zone(i).Wfan*building.zone(i).fan_f/building.zone(i).coilheating.HWCoil_UA 0]';
% building.zone(i).Damb_H=[building.zone(i).m_o*Cpa/building.zone(i).coilheating.HWCoil_UA 0]';
% building.zone(i).Dma_H=[(building.zone(i).m_sa-building.zone(i).m_o)*Cpa/building.zone(i).coilheating.HWCoil_UA 0]';
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'Value',...
%     ['[building.zone(' , num2str(i) , ').A_sa_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'Value',...
%     ['[building.zone(' , num2str(i) , ').B_sa_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'Value',...
%     ['[building.zone(' , num2str(i) , ').B_sa_H*building.zone(' , num2str(i) , ').Df_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'Value',...
%     ['[building.zone(' , num2str(i) , ').B_sa_H*building.zone(' , num2str(i) , ').Damb_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'Value',...
%     ['[building.zone(' , num2str(i) , ').B_sa_H*building.zone(' , num2str(i) , ').Dma_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'Value',...
%     ['[building.zone(' , num2str(i) , ').L_sa_H]']);
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Csa'],'Value',...
%     ['[building.zone(' , num2str(i) , ').C_sa_H]']);
% 
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'SampleTime','Ts');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'SampleTime','Ts');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'SampleTime','Ts');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'SampleTime','Ts');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'SampleTime','Ts');
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'SampleTime','Ts');

%% COOLING COIL -- WATER
building.zone(i).Df_C=[((building.zone(i).Wfan*building.zone(i).fan_f))/building.zone(i).coilcooling.C_coil_air 0]';
building.zone(i).Damb_C=[(building.zone(i).m_o*Cpa)/building.zone(i).coilcooling.C_coil_air 0]';
building.zone(i).Dma_C=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilcooling.C_coil_air 0]';

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').A_c_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains1'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains2'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').Df_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains3'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').Damb_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains4'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').Dma_C]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains5'],'Value',...
    ['[building.zone(' , num2str(i) , ').L_c_C]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Cc_C'],'Value',...
    ['[building.zone(' , num2str(i) , ').C_c_C]']);


set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'SampleTime','Ts');

% COIL observer -- Cooling Subsystem
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains'],'Value',...
%     ['[building.zone(' , num2str(i) , ').A_c_C; building.zone(' , num2str(i) , ').B_c_C; building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').Kcsa_C; building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').L_c_C]']);
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains'],'SampleTime','Ts');
    
%% HEATING COIL -- WATER
building.zone(i).Dfc_H=[(building.zone(i).Wfan*building.zone(i).fan_f)/building.zone(i).coilheating.H_coil_air 0 0 0]';
building.zone(i).Dambc_H=[(building.zone(i).m_o*Cpa)/building.zone(i).coilheating.H_coil_air 0 0 0]';
building.zone(i).Dmac_H=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilheating.H_coil_air 0 0 0]';

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains'],'Value',...
    ['[building.zone(' , num2str(i) , ').A_c_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains1'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains2'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Dfc_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains3'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Dambc_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains4'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Dmac_H]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/HCoilGains5'],'Value',...
    ['[building.zone(' , num2str(i) , ').L_c_H]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Hc_H'],'Value',...
    ['[building.zone(' , num2str(i) , ').C_c_H]']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Hc_H1'],'Value',...
    ['transpose([building.zone(' , num2str(i) , ').C_c_H])']);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Unit Delay1'],'InitialCondition',...
    'transpose([0 0 0 0])');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains1'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains2'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains3'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains4'],'SampleTime','Ts');
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/SupplyGains5'],'SampleTime','Ts');



% COIL observer -- Heating Subsystem
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains'],'Value',...
%     ['[building.zone(' , num2str(i) , ').A_c_H; building.zone(' , num2str(i) , ').B_c_H; building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Kcsa_H; building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').L_c_H]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/CoilGains'],'SampleTime','Ts');
%%    
    
%  State estimation 
%if i==4

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Tzhat_mat'],'FileName',...
    [dirc, '\Tzhat_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Tsahat_mat'],'FileName',...
    [dirc, '\Tsahat_',building.zone(i).tag, '.mat' ]);

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Tchat_mat'],'FileName',...
    [dirc, '\Tchat_',building.zone(i).tag, '.mat' ]);

%%%%
% set residula and threshold  Cooling 
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_zone'],'FileName',...
    [dirc, '\Res_zC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_zone'],'FileName',...
    [dirc, '\Th_zC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_zone'],'FileName',...
    [dirc, '\D_zC_',building.zone(i).tag, '.mat' ]);
% set threshold sa Cooling 
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_sa'],'FileName',...
    [dirc, '\Res_saC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_sa'],'FileName',...
    [dirc, '\Th_saC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_sa'],'FileName',...
    [dirc, '\D_saC_',building.zone(i).tag, '.mat' ]);

% set threshold Coil Cooling
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_coil'],'FileName',...
    [dirc, '\Res_c_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_coil'],'FileName',...
    [dirc, '\Th_c_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_coil'],'FileName',...
    [dirc, '\D_c_C_',building.zone(i).tag, '.mat' ]);

set_param([model_name,'/Controller/EnableD_C_' building.zone(i).tag '_mat'],'FileName',...
     [dirc, '\EnableD_C_',building.zone(i).tag, '.mat' ]);

%%  THRESHOLD ZONE - COOLING 
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae1'],'Value',...
    ['building.zone(' , num2str(i) , ').e_bar']); % building.zone(' , num2str(i) , ').a*
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae1'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/Gain'],'Gain',...
    ['building.zone(' , num2str(i) , ').e_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/Gain'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a1'],'Value',...
    ['building.zone(' , num2str(i) , ').a']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a1'],'SampleTime','Ts');


set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/n_bar1'],'Value',...
    ['building.zone(' , num2str(i) , ').n_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/n_bar1'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ZoneGainsThreshold1'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_z; transpose(building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').n_nei.*building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').L; building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').Qbar]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ZoneGainsThreshold1'],'SampleTime','Ts');
%%% SAVE FILES
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_z3'],'FileName',...
    [dirc, '\kC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_z2'],'FileName',...
    [dirc, '\aeC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_sum1'],'FileName',...
    [dirc, '\aeC_sum_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/x1'],'FileName',...
    [dirc, '\xC_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a mat'],'FileName',...
    [dirc, '\a_',building.zone(i).tag, '.mat' ]);

%% THRESHOLD COOOLING COIL -- SA 
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SAC'],'Value',...
    ['building.zone(' , num2str(i) , ').e_SA_C_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SAC'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/Gain'],'Gain',...
    ['building.zone(' , num2str(i) , ').e_SA_C_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/Gain'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/a_SA_C'],'Value',...
    ['building.zone(' , num2str(i) , ').a_SA_C']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/a_SA_C'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nSA_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').nC_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nSA_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nC_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').nC_bar+0.5']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nC_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nZ_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').n_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nZ_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/SAGainsThreshold'],'Value',...
    ['[norm(building.zone(' , num2str(i) , ').B_sa_C); norm(building.zone(' , num2str(i) , ').B_sa_C); norm(building.zone(' , num2str(i) , ').B_sa_C*building.zone(' , num2str(i) , ').Dma_SA); norm(building.zone(' , num2str(i) , ').L_sa_C)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/SAGainsThreshold'],'SampleTime','Ts');

% SAVE FILES
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/k_SA_C'],'FileName',...
    [dirc, '\k_SA_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SA_C'],'FileName',...
    [dirc, '\ae_SA_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/aeSA_C_sum'],'FileName',...
    [dirc, '\aeSA_C_sum_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/xSA_C'],'FileName',...
    [dirc, '\xSA_C_',building.zone(i).tag, '.mat' ]);

%% THRESHOLD COOOLING COIL -- WATER 
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/ae_c_C'],'Value',...
    ['building.zone(' , num2str(i) , ').e_c_C_bar']); % building.zone(' , num2str(i) , ').a_c_C*
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/ae_c_C'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/Gain'],'Gain',...
    ['building.zone(' , num2str(i) , ').e_c_C_bar']); % building.zone(' , num2str(i) , ').a_c_C*
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/Gain'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/a_c_C'],'Value',...
    ['building.zone(' , num2str(i) , ').a_c_C']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/a_c_C'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/nC_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').nC_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/nC_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/nZ_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').n_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/nZ_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/CoilGainsThreshold'],'Value',...
    ['[norm(building.zone(' , num2str(i) , ').B_c_C); norm(building.zone(' , num2str(i) , ').B_c_C*building.zone(' , num2str(i) , ').Dma_C); norm(building.zone(' , num2str(i) , ').L_c_C)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/CoilGainsThreshold'],'SampleTime','Ts');

% SAVE FILES
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/k_c_C'],'FileName',...
    [dirc, '\k_c_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/ae_C_C'],'FileName',...
    [dirc, '\ae_C_C_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/ae_C_C_sum'],'FileName',...
    [dirc, '\ae_C_C_sum_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_coil/x_C_C'],'FileName',...
    [dirc, '\x_C_C_',building.zone(i).tag, '.mat' ]);


%%  THRESHOLD ZONE - HEATING

% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Tzhat_mat'],'FileName',...
%     [dirc, '\TzhatH_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Tsahat_mat'],'FileName',...
%     [dirc, '\TsahatH_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Thchat_mat'],'FileName',...
    [dirc, '\TchatH_',building.zone(i).tag, '.mat' ]);

% set residual and threshold  heating 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_zone'],'FileName',...
%     [dirc, '\Res_zH_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_zone'],'FileName',...
%     [dirc, '\Th_zH_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_zone'],'FileName',...
%     [dirc, '\D_zH_',building.zone(i).tag, '.mat' ]);
% % set threshold sa Cooling 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_sa'],'FileName',...
%     [dirc, '\Res_saH_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_sa'],'FileName',...
%     [dirc, '\Th_saH_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_sa'],'FileName',...
%     [dirc, '\D_saH_',building.zone(i).tag, '.mat' ]);
% set threshold Coil Heating Subsystem
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/residual_hcoil'],'FileName',...
    [dirc, '\Res_c_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/threshold_hcoil'],'FileName',...
    [dirc, '\Th_c_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Detection_hcoil'],'FileName',...
    [dirc, '\D_c_H_',building.zone(i).tag, '.mat' ]);

set_param([model_name,'/Controller/EnableD_H_' building.zone(i).tag '_mat'],'FileName',...
     [dirc, '\EnableD_H_',building.zone(i).tag, '.mat' ]);

%%
  
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae1'],'Value',...
    ['building.zone(' , num2str(i) , ').a*building.zone(' , num2str(i) , ').e_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae1'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a1'],'Value',...
    ['building.zone(' , num2str(i) , ').a']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a1'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/n_bar1'],'Value',...
    ['building.zone(' , num2str(i) , ').n_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/n_bar1'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ZoneGainsThreshold1'],'Value',...
    ['[building.zone(' , num2str(i) , ').B_z; transpose(building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').n_nei.*building.zone(' , num2str(i) , ').Kij); building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').L; building.zone(' , num2str(i) , ').B_z*building.zone(' , num2str(i) , ').Qbar]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ZoneGainsThreshold1'],'SampleTime','Ts');

% SAVE FILES
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_z3'],'FileName',...
    [dirc, '\kH_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_z2'],'FileName',...
    [dirc, '\aeH_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/ae_sum1'],'FileName',...
    [dirc, '\aeH_sum_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/x1'],'FileName',...
    [dirc, '\xH_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_zone/a mat'],'FileName',...
    [dirc, '\aH_',building.zone(i).tag, '.mat' ]);

%% THRESHOLD SA Heating 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SAC'],'Value',...
%     ['building.zone(' , num2str(i) , ').e_SA_H_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SAC'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/Gain'],'Gain',...
%     ['building.zone(' , num2str(i) , ').e_SA_H_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/Gain'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/a_SA_C'],'Value',...
%     ['building.zone(' , num2str(i) , ').a_SA_H']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/a_SA_C'],'SampleTime','Ts');
% 
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nSA_bar'],'Value',...
%     ['building.zone(' , num2str(i) , ').nH_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nSA_bar'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nC_bar'],'Value',...
%     ['building.zone(' , num2str(i) , ').nH_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nC_bar'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nH_bar'],'Value',...
%     ['building.zone(' , num2str(i) , ').nH_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nH_bar'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nZ_bar'],'Value',...
%     ['building.zone(' , num2str(i) , ').n_bar']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/nZ_bar'],'SampleTime','Ts');
% 
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/SAGainsThreshold'],'Value',...
%     ['[norm(building.zone(' , num2str(i) , ').B_sa_H); norm(building.zone(' , num2str(i) , ').B_sa_H); norm(building.zone(' , num2str(i) , ').B_sa_H*building.zone(' , num2str(i) , ').Dma_H); norm(building.zone(' , num2str(i) , ').L_sa_H)]']);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/SAGainsThreshold'],'SampleTime','Ts');
% 
% % SAVE FILES
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/k_SA_C'],'FileName',...
%     [dirc, '\k_SA_H_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/ae_SA_C'],'FileName',...
%     [dirc, '\ae_SA_H_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/aeSA_C_sum'],'FileName',...
%     [dirc, '\aeSA_H_sum_',building.zone(i).tag, '.mat' ]);
% set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_sa/xSA_C'],'FileName',...
%     [dirc, '\xSA_H_',building.zone(i).tag, '.mat' ]);



%% THRESHOLD Coil Heating 

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/ae_c_C'],'Value',...
    ['building.zone(' , num2str(i) , ').e_c_H_bar']); % building.zone(' , num2str(i) , ').a_c_C*
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/ae_c_C'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/Gain'],'Gain',...
    ['building.zone(' , num2str(i) , ').e_c_H_bar']); % building.zone(' , num2str(i) , ').a_c_C*
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/Gain'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/a_c_C'],'Value',...
    ['building.zone(' , num2str(i) , ').a_c_H']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/a_c_C'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/nC_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').nH_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/nC_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/nZ_bar'],'Value',...
    ['building.zone(' , num2str(i) , ').n_bar']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/nZ_bar'],'SampleTime','Ts');

set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/CoilGainsThreshold'],'Value',...
    ['[norm(building.zone(' , num2str(i) , ').B_c_H); norm(building.zone(' , num2str(i) , ').B_c_H); norm(building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Dmac_H); norm(building.zone(' , num2str(i) , ').L_c_H)]']);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/CoilGainsThreshold'],'SampleTime','Ts');


% if i==18
%     set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/CoilGainsThreshold'],'Value',...
%     ['[norm(building.zone(' , num2str(i) , ').B_c_H); norm(building.zone(' , num2str(i) , ').B_c_H); norm(building.zone(' , num2str(i) , ').B_c_H*building.zone(' , num2str(i) , ').Dmac_H); norm(building.zone(' , num2str(i) , ').L_c_H)]']);
% 
% end

% SAVE FILES
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/k_c_C'],'FileName',...
    [dirc, '\k_c_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/ae_C_C'],'FileName',...
    [dirc, '\ae_C_H_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/ae_C_C_sum'],'FileName',...
    [dirc, '\ae_C_H_sum_',building.zone(i).tag, '.mat' ]);
set_param([model_name,'/Controller/' building.zone(i).tag '_Agent/Threshold_hcoil/x_C_C'],'FileName',...
    [dirc, '\x_C_H_',building.zone(i).tag, '.mat' ]);


end

%  For energy calculations
set_param([model_name,'/Controller/Cpw'],'Gain','Cpw');
set_param([model_name,'/Controller/Energy'],'FileName',[dirc, '\Energy',folder,'.mat' ]);

% set_param([model_name,'/Controller/Air_Electric_Energy_mat'],'FileName',...
%     [dirc, '\Air_Electric_Energy_mat.mat' ]);

%end
