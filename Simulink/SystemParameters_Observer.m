%% System Parameters -- Observer

currentPrecision = digits;

for i=1:numel(building.zone)

building.zone(i).A_con_z = - (building.zone(i).m_sa*Cpa + building.zone(i).a_ij...
                             + building.zone(i).a_z)/(pa*building.vol(i)*Cpa);
building.zone(i).B_con_z = (building.zone(i).m_sa*Cpa)/...
                            (pa*building.vol(i)*Cpa);           
building.zone(i).A_z = exp(building.zone(i).A_con_z*Ts);
building.zone(i).B_z = building.zone(i).B_con_z*...
    (building.zone(i).A_z-1)/building.zone(i).A_con_z ;

%%
% Air side --- cooling coil

building.zone(i).coilcooling.CWCoil_UA=building.zone(i).coilcooling.CWCoil_U* building.zone(i).coilcooling.CWCoil_A;
building.zone(i).coilheating.HWCoil_UA=building.zone(i).coilheating.HWCoil_U* building.zone(i).coilheating.HWCoil_A;

building.zone(i).A_con_sa_C = [ -(building.zone(i).coilcooling.CWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air 0;...
    (building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air -(building.zone(i).coilheating.HWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilheating.H_coil_air];

building.zone(i).B_con_sa_C =[ building.zone(i).coilcooling.CWCoil_UA/building.zone(i).coilcooling.C_coil_air 0;...
    0 building.zone(i).coilheating.HWCoil_UA/building.zone(i).coilheating.H_coil_air];

building.zone(i).C_sa_C=[0 1]; 

building.zone(i).A_sa_C = expm(building.zone(i).A_con_sa_C*Ts);
building.zone(i).B_sa_C = building.zone(i).B_con_sa_C*(building.zone(i).A_sa_C-eye(2))/building.zone(i).A_con_sa_C;

building.zone(i).Df_SA=[(building.zone(i).Wfan*building.zone(i).fan_f)/building.zone(i).coilcooling.CWCoil_UA 0]';
building.zone(i).Damb_SA=[(building.zone(i).m_o*Cpa)/building.zone(i).coilcooling.CWCoil_UA 0]';
building.zone(i).Dma_SA=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilcooling.CWCoil_UA 0]';

%%
% Air side --- heating coil

building.zone(i).A_con_sa_H = [ -(building.zone(i).coilcooling.CWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air 0;...
    (building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air -(building.zone(i).coilheating.HWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilheating.H_coil_air];

building.zone(i).B_con_sa_H =[ building.zone(i).coilcooling.CWCoil_UA/building.zone(i).coilcooling.C_coil_air 0;...
    0 building.zone(i).coilheating.HWCoil_UA/building.zone(i).coilheating.H_coil_air];

sys=ss(building.zone(i).A_con_sa_H,building.zone(i).B_con_sa_H,[0 1],0);
pole(sys);

building.zone(i).A_sa_H = expm(building.zone(i).A_con_sa_H.*Ts);
building.zone(i).B_sa_H = ( building.zone(i).B_con_sa_H*(building.zone(i).A_sa_H-eye(2)) )/building.zone(i).A_con_sa_H;

building.zone(i).C_sa_H=[0 1]; 

%%
% Water side --- cooling coil

building.zone(i).A_con_c_C =[ -(building.zone(i).coilcooling.CWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air (building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_air;
                (building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_water -(building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_water];

building.zone(i).B_con_c_C =[1 0;
                             0 Cpw/building.zone(i).coilcooling.C_coil_water];

building.zone(i).A_c_C = expm(building.zone(i).A_con_c_C*Ts);
building.zone(i).B_c_C =(inv(building.zone(i).A_con_c_C)*(building.zone(i).A_c_C-eye(2)))*building.zone(i).B_con_c_C;
building.zone(i).C_c_C=[0 1]; 
building.zone(i).Df_C=[((building.zone(i).Wfan*building.zone(i).fan_f))/building.zone(i).coilcooling.C_coil_air 0]';
building.zone(i).Damb_C=[(building.zone(i).m_o*Cpa)/building.zone(i).coilcooling.C_coil_air 0]';
building.zone(i).Dma_C=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilcooling.C_coil_air 0]';



%%

% Water side -- heating coil

building.zone(i).A_con_c_H =[ -(building.zone(i).coilcooling.CWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air (building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_air 0 0;
                (building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_water -(building.zone(i).coilcooling.CWCoil_UA)/building.zone(i).coilcooling.C_coil_water 0 0;
   (building.zone(i).m_sa*Cpa)/building.zone(i).coilcooling.C_coil_air 0 -(building.zone(i).coilheating.HWCoil_UA + building.zone(i).m_sa*Cpa)/building.zone(i).coilheating.H_coil_air (building.zone(i).coilheating.HWCoil_UA)/building.zone(i).coilheating.H_coil_air;
   0 0 (building.zone(i).coilheating.HWCoil_UA)/building.zone(i).coilheating.H_coil_water -(building.zone(i).coilheating.HWCoil_UA)/building.zone(i).coilheating.H_coil_water];


building.zone(i).B_con_c_H =[1 0 0 0;
                             0 Cpw/building.zone(i).coilheating.H_coil_water 0 0;
                             0 0 0 0;
                             0 0 0 Cpw/building.zone(i).coilheating.H_coil_water];

building.zone(i).A_c_H = expm(building.zone(i).A_con_c_H*Ts);
building.zone(i).B_c_H = (inv(building.zone(i).A_con_c_H)*(building.zone(i).A_c_H-eye(4)))*building.zone(i).B_con_c_H;
building.zone(i).C_c_H=[0 0 0 1]; 
building.zone(i).Dfc_H=[(building.zone(i).Wfan*building.zone(i).fan_f)/building.zone(i).coilheating.H_coil_air 0 0 0]';
building.zone(i).Dambc_H=[(building.zone(i).m_o*Cpa)/building.zone(i).coilheating.H_coil_air 0 0 0]';
building.zone(i).Dmac_H=[((building.zone(i).m_sa-building.zone(i).m_o)*Cpa)/building.zone(i).coilheating.H_coil_air 0 0 0]';

end
