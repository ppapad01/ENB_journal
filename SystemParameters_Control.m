%% System Parameters - Control

readepJSONout
disp('Loaded: Json')

for i=1:numel(building.zone)

building.zone(i).control_A_con_z = - (building.zone(i).m_sa*Cpa + building.zone(i).a_ij...
                             + building.zone(i).a_z)/(pa*building.vol(i)*Cpa);
building.zone(i).control_B_con_z = (building.zone(i).m_sa*Cpa)/...
                            (pa*building.vol(i)*Cpa);           
building.zone(i).control_A_z = exp(building.zone(i).control_A_con_z*Ts);
building.zone(i).control_B_z = building.zone(i).control_B_con_z*...
    (building.zone(i).control_A_z-1)/building.zone(i).control_A_con_z ;



building.zone(i).n_bar=0.3; 
building.zone(i).nSA_bar=0.3; 
building.zone(i).nC_bar=0.3; 
building.zone(i).nH_bar=0.3; 


% Air side --- cooling coil
building.zone(i).coilcooling.CWCoil_UA=building.zone(i).coilcooling.CWCoil_U* building.zone(i).coilcooling.CWCoil_A;
building.zone(i).control_A_con_sa_C = -(building.zone(i).coilcooling.CWCoil_UA + building.zone(i).m_sa*Cpa)/...
    building.zone(i).coilcooling.C_coil_air;
building.zone(i).control_B_con_sa_C = building.zone(i).coilcooling.CWCoil_UA/building.zone(i).coilcooling.C_coil_air;
building.zone(i).control_A_sa_C = exp(building.zone(i).control_A_con_sa_C*Ts);
building.zone(i).control_B_sa_C = building.zone(i).control_B_con_sa_C*(building.zone(i).control_A_sa_C-1)/building.zone(i).control_A_con_sa_C;
%%
% Ts=60;
% i=4;
% UA=2500;
% m_sa=1.5;
% C_coil_air=20000;
% A_con_sa_C = -(UA + m_sa*Cpa)/C_coil_air
% A_sa_C = exp(A_con_sa_C*Ts)
% B_con_sa_C = (UA)/(C_coil_air)
% B_sa_C = B_con_sa_C*(A_sa_C-1)/A_con_sa_C
% 
% C_coil_water=400000
% A_con_c_C = - UA/C_coil_water
% B_con_c_C = Cpw/C_coil_water
% A_c_C = exp(A_con_c_C*Ts)
% B_c_C = B_con_c_C*(A_c_C-1)/A_con_c_C

%%
% Air side --- heating coil
building.zone(i).coilheating.HWCoil_UA=building.zone(i).coilheating.HWCoil_U* building.zone(i).coilheating.HWCoil_A;
building.zone(i).control_A_con_sa_H = -(building.zone(i).coilheating.HWCoil_UA + building.zone(i).m_sa*Cpa)/...
    building.zone(i).coilheating.H_coil_air;
building.zone(i).control_B_con_sa_H = building.zone(i).coilheating.HWCoil_UA/building.zone(i).coilheating.H_coil_air;
building.zone(i).control_A_sa_H = exp(building.zone(i).control_A_con_sa_H*Ts);
building.zone(i).control_B_sa_H = building.zone(i).control_B_con_sa_H*(building.zone(i).control_A_sa_H-1)/building.zone(i).control_A_con_sa_H;

% Water side --- cooling coil
building.zone(i).control_A_con_c_C = - building.zone(i).coilcooling.CWCoil_UA/building.zone(i).coilcooling.C_coil_water;
building.zone(i).control_B_con_c_C = Cpw/building.zone(i).coilcooling.C_coil_water;
building.zone(i).control_A_c_C = exp(building.zone(i).control_A_con_c_C*Ts);
building.zone(i).control_B_c_C = building.zone(i).control_B_con_c_C*(building.zone(i).control_A_c_C-1)/building.zone(i).control_A_con_c_C;

% Water side -- heating coil
building.zone(i).control_A_con_c_H = - building.zone(i).coilheating.HWCoil_UA/building.zone(i).coilheating.H_coil_water;
building.zone(i).control_B_con_c_H = Cpw/building.zone(i).coilheating.H_coil_water;
building.zone(i).control_A_c_H = exp(building.zone(i).control_A_con_c_H*Ts);
building.zone(i).control_B_c_H = building.zone(i).control_B_con_c_H*(building.zone(i).control_A_c_H-1)/building.zone(i).control_A_con_c_H;



end
