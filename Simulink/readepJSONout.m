%clear all; %clc;
clear dat

currentFolder = pwd;
addpath([currentFolder,'\jsonlab'])
idcs   = strfind(currentFolder,'\');
newdir = currentFolder(1:idcs(end)-1);

dat=loadjson([newdir,'\ePlus\ASHRAE9012016_SchoolPrimary_Denver.epJSON']);



%%
%clc;
% simulation step
Ts=3600/dat.Timestep.Timestep_0x20_1.number_of_timesteps_per_hour;

%%% Global parameters %%%
Cv = 718; % Specific heat of air at constant volume (J/kg.K)
Cpa = 1005; % Specific heat of air at constant pressure (J/kg.K)
pa = 1.25; % air density (kg/m3)
pw = 1000; % water density (kg/m3)
Cpw = 4180; % Specific heat of water at constant pressure (J/kg.K)

clear building 
%%%%%%%%%%%%%%%%%%%%%%%%%% Zone Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

building.zonenames=fieldnames(dat.Zone);
for zone=1:numel(fieldnames(dat.Zone))
    building.vol(zone,:)=eval(['dat.Zone.' building.zonenames{zone} '.volume']);
    building.zone(zone).name=building.zonenames{zone};
    building.zone(zone).vol=building.vol(zone,:);
    building.zone(zone).tag=strrep(building.zonenames{zone},'_ZN_1_FLR_1','');
    building.zone(zone).tag=strrep(building.zone(zone).tag,'_','');
end

% read material group
materialnames = fieldnames(dat.Material);

for i=1:numel(materialnames)
   building.material(i).name=materialnames{i}; 
   building.material(i).tag=strrep(materialnames{i},'_0x20_',' ');
   building.material(i).tag=strrep(building.material(i).tag,'x0x31_','1');
   building.material(i).tag=strrep(building.material(i).tag,'x0x32_','2');
   building.material(i).tag=strrep(building.material(i).tag,'_0x2D_','-');
   building.material(i).conductivity=eval(['dat.Material.' building.material(i).name '.conductivity']);
   building.material(i).thickness=eval(['dat.Material.' building.material(i).name '.thickness']);
   building.material(i).Res=building.material(i).thickness/building.material(i).conductivity;
end

% read material no mass group
materialnomassnames = fieldnames(dat.Material_0x3A_NoMass);

k=numel(materialnames)+1:numel(materialnames)+1+numel(materialnomassnames);

for i=1:numel(materialnomassnames)
   building.material(k(i)).name=materialnomassnames{i}; 
   building.material(k(i)).tag=strrep(materialnomassnames{i},'_0x20_',' ');
   building.material(k(i)).tag=strrep(building.material(k(i)).tag,'x0x31_','1');
   building.material(k(i)).tag=strrep(building.material(k(i)).tag,'x0x32_','2');
   building.material(k(i)).tag=strrep(building.material(k(i)).tag,'_0x2D_','-');
   building.material(k(i)).Res=eval(['dat.Material_0x3A_NoMass.' building.material(k(i)).name '.thermal_resistance']);
end

% read dat.WindowMaterial_0x3A_Glazing   
windowmaterialnames = fieldnames(dat.WindowMaterial_0x3A_Glazing);
h=k(end)+1:k(end)+1+numel(windowmaterialnames);

for i=1:numel(windowmaterialnames)
   building.material(h(i)).name=windowmaterialnames{i}; 
   building.material(h(i)).tag=strrep(windowmaterialnames{i},'_0x20_',' ');
   building.material(h(i)).tag=strrep(building.material(h(i)).tag,'x0x31_','1');
   building.material(h(i)).tag=strrep(building.material(h(i)).tag,'x0x32_','2');
   building.material(h(i)).tag=strrep(building.material(h(i)).tag,'_0x2D_','-');
   building.material(h(i)).conductivity=eval(['dat.WindowMaterial_0x3A_Glazing.' building.material(h(i)).name '.conductivity']);
   building.material(h(i)).thickness=eval(['dat.WindowMaterial_0x3A_Glazing.' building.material(h(i)).name '.thickness']);
   building.material(h(i)).Res=building.material(h(i)).thickness/building.material(h(i)).conductivity;
end

% read construction group
constructionnames = fieldnames(dat.Construction);

% remove windows from construction group
p=1;
for g=1:numel(fieldnames(dat.Construction))
    temp=constructionnames{g,:};
    if temp(1:6)=='Window'
        p=p;
    else
        constructionnames_str(p)=cellstr(temp);
        p=p+1;
    end
end
constructionnames=constructionnames_str';

for i=1:numel(constructionnames)
    building.construction(i).name=constructionnames{i};
    building.construction(i).layers=eval(['dat.Construction.' building.construction(i).name]);
    layersnames{i}=building.construction(i).layers;
    building.construction(i).layersname=layersnames{i};
    fnames=fieldnames(building.construction(i).layersname);
    totRes=0;
    for j=1:numel(fieldnames(building.construction(i).layers))  
        if isa(eval(['dat.Construction.' building.construction(i).name '.' fnames{j}]),'char')
           % building.material.tag='100mm Normalweight concrete floor'      
           m =getfield(eval(['dat.Construction.' building.construction(i).name ]),fnames{j});
           ind=find(strcmp({building.material.tag}, m)==1);
           totRes=totRes+building.material(ind).Res;      
        end
    end
    building.construction(i).Uvalue=1/totRes;
end

BuildingSurfaces=fieldnames(dat.BuildingSurface_0x3A_Detailed);
for i=1:numel(BuildingSurfaces)
    building.surfaces(i).name=BuildingSurfaces{i};
    building.surfaces(i).zone_name=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.zone_name']);
    building.surfaces(i).surface_type=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.surface_type']);
    building.surfaces(i).outside_boundary=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.outside_boundary_condition']);
    building.surfaces(i).construction_name=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.construction_name']);
    building.surfaces(i).num_of_vertices=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.number_of_vertices']);
    
    %    eval(['dat.Material.' building.material(i).name '.conductivity']); 
    %    find(strcmp({building.material.tag}, building.zonednames{i})==1)
    
    % calculate Area of a surface using vertices
    for j=1:building.surfaces(i).num_of_vertices
    X(j)=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.vertices{1,' num2str(j) '}.vertex_x_coordinate']); 
    Y(j)=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.vertices{1,' num2str(j) '}.vertex_y_coordinate']);
    Z(j)=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.vertices{1,' num2str(j) '}.vertex_z_coordinate']);
    end
    if range(Y) == 0
        % vertical (floor/celling)
        building.surfaces(i).surface_area = polyarea(X,Z);
        %plot(X,Z,'*')
    elseif range(Z) == 0
        % horizontal (wall)
        building.surfaces(i).surface_area = polyarea(X,Y);   
        %plot(X,Y,'*')
    else
      % horizontal (wall)
        building.surfaces(i).surface_area = polyarea(Y,Z);   
        %plot(Y,Z,'*')
    end
    
    
end


 sum_ext=0;
    for zone=1:numel(building.zonenames)
        k=1;
        sum_int(zone)=0;
        sum_ext(zone)=0;
        % interzone
        for i=1:numel(BuildingSurfaces)
            if isequal(building.surfaces(i).construction_name,'int_wall')
                ind=find(strcmp({building.construction.name}, 'int_wall')==1);
                building.surfaces(i).outside_object=eval(['dat.BuildingSurface_0x3A_Detailed.' building.surfaces(i).name '.outside_boundary_condition_object']);
                if strcmp(building.surfaces(i).zone_name,building.zonenames{zone})
                   sum_int(zone)=sum_int(zone) + building.surfaces(i).surface_area*building.construction(ind).Uvalue;
                   building.zone(zone).a_int(k)=building.surfaces(i).surface_area*building.construction(ind).Uvalue;
                   % change with the general case
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_1','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_2','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_3','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_4','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_5','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_6','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_7','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_8','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end 
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_9','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end 
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_10','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end 
                   temp=strrep(building.surfaces(i).outside_object,'_ZN_1_FLR_1_Wall_11','');
                   if ~isequal(building.surfaces(i).outside_object,temp)
                   building.zone(zone).neighbour{k}=temp;
                   %continue
                   end 
                   k=k+1;
                end
            end
            building.zone(zone).a_ij=sum_int(zone);
            % external
            if isequal(building.surfaces(i).construction_name,'nonres_ext_wall')
                ind=find(strcmp({building.construction.name}, 'nonres_ext_wall')==1);
                if strcmp(building.surfaces(i).zone_name,building.zonenames{zone})
                    sum_ext(zone)=sum_ext(zone)+ building.surfaces(i).surface_area*building.construction(ind).Uvalue;
                end
            end
            building.zone(zone).a_z=sum_ext(zone);
            % roof
            if isequal(building.surfaces(i).construction_name,'nonres_roof')
                ind=find(strcmp({building.construction.name}, 'nonres_roof')==1);
                if strcmp(building.surfaces(i).zone_name,building.zonenames{zone})
                    building.zone(zone).a_roof=building.surfaces(i).surface_area*building.construction(ind).Uvalue;
                end
            end
            % floor
            if isequal(building.surfaces(i).construction_name,'ext_slab_6in_with_carpet')
                ind=find(strcmp({building.construction.name}, 'ext_slab_6in_with_carpet')==1);
                if strcmp(building.surfaces(i).zone_name,building.zonenames{zone})
                    building.zone(zone).a_floor=building.surfaces(i).surface_area*building.construction(ind).Uvalue;
                end
            end
        end
        
    end

 clear B ind
for l=1:length(building.zone)
B{l}=building.zone(l).tag;
end
for l=1:length(building.zone)
    for m=1:length(building.zone(l).neighbour)
        [~,ind(l,m)]=ismember(regexprep(building.zone(l).neighbour{m},'_',''),B)
    end
    building.zone(l).neightags=ind(l,:);
end
  


% Find the number of fields with a specific fieldname
% if sum(strcmp(fieldnames(STRUCTURE), 'FIELDNAME')) == 1
%   do something
% end

%%%%%%%%%%%%%%%%%%%%%%% Fan parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fan power % get it from the output after simulation
Wfan_i= 0; %eval(['dat.Pump_0x3A_ConstantSpeed.Cooling_0x20_Circ_0x20_Pump.design_power_consumption']);  

%  Fraction of the fan/pump power 
%  converted to the fluid thermal energy 
fannames=fieldnames(dat.Fan_0x3A_ConstantVolume);
for i=1:numel(fannames)
    
   building.fans(i).name=fannames{i}; 
   building.fans(i).tag=strrep(building.fans(i).name,'_0x20_','');
   building.fans(i).tag=strrep(building.fans(i).tag,'SupplyFan','');
   building.fans(i).tag=strrep(building.fans(i).tag,'AHU','');
   
   %m =getfield([building.fans(i).tag '_ZN_1_FLR_1' ], building.zonenames{1} );
   ind=find(strcmp([building.fans(i).tag '_ZN_1_FLR_1' ], building.zonenames)==1);
   building.zone(ind).fan_f=eval(['dat.Fan_0x3A_ConstantVolume.' fannames{ind} '.fan_total_efficiency']) ;
end

% % find the design_supply_air_flow_rate  (m3/sec)
airloopnames=fieldnames(dat.AirLoopHVAC);
for i=1:numel(airloopnames)
   building.airloop(i).name=airloopnames{i}; 
   building.airloop(i).tag=strrep(building.airloop(i).name,'_0x20_','');
   building.airloop(i).tag=strrep(building.airloop(i).tag,'AHU','');
   %m =getfield([building.fans(i).tag '_ZN_1_FLR_1' ], building.zonenames{1} );
   ind=find(strcmp([building.fans(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
   building.zone(ind).Vdot_fan=eval(['dat.AirLoopHVAC.' airloopnames{i} '.design_supply_air_flow_rate']) ;
   building.zone(ind).m_sa=building.zone(ind).Vdot_fan*pa;
end

%% Cooling and Heating coil

programnames=fieldnames(dat.EnergyManagementSystem_0x3A_Program);
for i=1:numel(programnames)
    % cooling coil
    building.coilcooling(i).name=programnames{i};  
    if ~isempty(strfind(building.coilcooling(i).name, '_CWCoil'))
        building.coilcooling(i).tag=strrep(building.coilcooling(i).name,'_CWCoil','');
        if ~isempty(strfind(building.coilcooling(i).tag, '_ModelInput'))
            building.coilcooling(i).tag=strrep(building.coilcooling(i).tag,'_ModelInput','');
            % m_sa_i
            temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_CWCoil_ModelInput.lines{1,1}.program_line']);
            ind=find(strcmp([building.coilcooling(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
            %building.zone(ind).m_sa=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
            
        end
    end
    %%%
    if ~isempty(strfind(building.coilcooling(i).name, '_C_InitSimpleCoilModel'))     
        %disp('kati')
        building.coilcooling(i).tag=strrep(building.coilcooling(i).name,'_C_InitSimpleCoilModel','');
        ind=find(strcmp([building.coilcooling(i).tag '_ZN_1_FLR_1'], building.zonenames)==1); 
        % Ts
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_C_InitSimpleCoilModel.lines{1,5}.program_line']);
        building.zone(ind).coilcooling.Ts=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % CWCoil_U % Conduction heat transfer coefficient
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_C_InitSimpleCoilModel.lines{1,6}.program_line']);
        building.zone(ind).coilcooling.CWCoil_U=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % CWCoil_A % area of the coil
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_C_InitSimpleCoilModel.lines{1,7}.program_line']);
        building.zone(ind).coilcooling.CWCoil_A=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % C_coil_air %Thermal capacitance, Air and Meter
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_C_InitSimpleCoilModel.lines{1,9}.program_line']);
        building.zone(ind).coilcooling.C_coil_air=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % C_coil_water %Thermal capacitance, Water and metal 
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilcooling(i).tag '_C_InitSimpleCoilModel.lines{1,10}.program_line']);
        building.zone(ind).coilcooling.C_coil_water=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
    end
    
    % heating coil
    building.coilheating(i).name=programnames{i};    
        
    if ~isempty(strfind(building.coilheating(i).name, '_HWCoil'))
        building.coilheating(i).tag=strrep(building.coilheating(i).name,'_HWCoil','');
        if ~isempty(strfind(building.coilheating(i).tag, '_ModelInput'))
            building.coilheating(i).tag=strrep(building.coilheating(i).tag,'_ModelInput','');
            % m_sa_i
            temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_HWCoil_ModelInput.lines{1,1}.program_line']);
            ind=find(strcmp([building.coilheating(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
            %building.zone(ind).m_sa=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
            %building.zone(ind).m_sa=eval(['dat.AirLoopHVAC_0x3A_UnitarySystem.' programnames{i} '.cooling_supply_air_flow_rate'])
        end
    end    
    if ~isempty(strfind(building.coilheating(i).name, '_H_InitSimpleCoilModel'))     
        %disp('kati')
        building.coilheating(i).tag=strrep(building.coilheating(i).name,'_H_InitSimpleCoilModel','');
        ind=find(strcmp([building.coilheating(i).tag '_ZN_1_FLR_1'], building.zonenames)==1); 
        % Ts
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_H_InitSimpleCoilModel.lines{1,5}.program_line']);
        building.zone(ind).coilheating.Ts=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % HWCoil_U % Conduction heat transfer coefficient
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_H_InitSimpleCoilModel.lines{1,6}.program_line']);
        building.zone(ind).coilheating.HWCoil_U=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % HWCoil_A % area of the coil
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_H_InitSimpleCoilModel.lines{1,7}.program_line']);
        building.zone(ind).coilheating.HWCoil_A=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % H_coil_air %Thermal capacitance, Air and Meter
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_H_InitSimpleCoilModel.lines{1,9}.program_line']);
        building.zone(ind).coilheating.H_coil_air=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
        % H_coil_water %Thermal capacitance, Water and metal 
        temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.coilheating(i).tag '_H_InitSimpleCoilModel.lines{1,10}.program_line']);
        building.zone(ind).coilheating.H_coil_water=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
    end
    
end

%% AHU Fan paramenters

% find the cooling_supply_air_flow_rate  (m3/sec)
airloopnames=fieldnames(dat.AirLoopHVAC_0x3A_UnitarySystem);
for i=1:numel(airloopnames)
   building.airloop(i).name=airloopnames{i}; 
   building.airloop(i).tag=strrep(building.airloop(i).name,'_0x20_','');
   building.airloop(i).tag=strrep(building.airloop(i).tag,'AHU','');
   building.airloop(i).tag=strrep(building.airloop(i).tag,'Unitary System','');
   ind=find(strcmp([building.fans(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
   %building.zone(ind).Vdot_fan=eval(['dat.AirLoopHVAC_0x3A_UnitarySystem.' airloopnames{i} '.cooling_supply_air_flow_rate']) ;
end
%Vdot_fan=dat.AirLoopHVAC_0x3A_UnitarySystem.AHU_0x20_Bath_0x20_Unitary_0x20_System.cooling_supply_air_flow_rate;


fannames=fieldnames(dat.Fan_0x3A_ConstantVolume);
for i=1:numel(fannames)
    
   building.fan(i).name=fannames{i}; 
   building.fan(i).tag=strrep(building.fan(i).name,'_0x20_','');
   building.fan(i).tag=strrep(building.fan(i).tag,'AHU','');
   building.fan(i).tag=strrep(building.fan(i).tag,'SupplyFan','');
   ind=find(strcmp([building.fan(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
   building.zone(ind).e_tot=eval(['dat.Fan_0x3A_ConstantVolume.' fannames{i} '.fan_total_efficiency']);
   building.zone(ind).dP=eval(['dat.Fan_0x3A_ConstantVolume.' fannames{i} '.pressure_rise']) ;
   building.zone(ind).e_motor=eval(['dat.Fan_0x3A_ConstantVolume.' fannames{i} '.motor_efficiency']) ;
   building.zone(ind).f_motor=eval(['dat.Fan_0x3A_ConstantVolume.' fannames{i} '.motor_in_airstream_fraction']) ;
   
% building.zone(ind).Wfan= (building.zone(ind).e_motor*building.zone(ind).Vdot_fan*...
%     building.zone(ind).dP)/building.zone(ind).e_tot...
%     + ((building.zone(ind).Vdot_fan*building.zone(ind).dP)/building.zone(ind).e_tot)*...
%     (1- building.zone(ind).e_motor)*building.zone(ind).f_motor;
building.zone(ind).Wfan= (building.zone(ind).e_motor*building.zone(ind).m_sa/1.225*...
    building.zone(ind).dP)/building.zone(ind).e_tot...
    + ((building.zone(ind).m_sa/1.225*building.zone(ind).dP)/building.zone(ind).e_tot)*...
    (1- building.zone(ind).e_motor)*building.zone(ind).f_motor;

end
% e_tot= dat.Fan_0x3A_ConstantVolume.AHU_0x20_Bath_0x20_Supply_0x20_Fan.fan_total_efficiency;
% dP= dat.Fan_0x3A_ConstantVolume.AHU_0x20_Bath_0x20_Supply_0x20_Fan.pressure_rise;
% e_motor= dat.Fan_0x3A_ConstantVolume.AHU_0x20_Bath_0x20_Supply_0x20_Fan.motor_efficiency;
% f_motor= dat.Fan_0x3A_ConstantVolume.AHU_0x20_Bath_0x20_Supply_0x20_Fan.motor_in_airstream_fraction;

% mixing box flow rate
%building.zone(1).mo
programnames=fieldnames(dat.EnergyManagementSystem_0x3A_Program);
for i=1:numel(programnames)
     building.mixing(i).name=programnames{i};  
    if ~isempty(strfind(building.mixing(i).name, '_MixingProgram'))
        building.mixing(i).tag=strrep(building.mixing(i).name,'_MixingProgram','');
            temp=eval(['dat.EnergyManagementSystem_0x3A_Program.' building.mixing(i).tag '_MixingProgram.lines{1, 1}.program_line']);
            ind=find(strcmp([building.mixing(i).tag '_ZN_1_FLR_1'], building.zonenames)==1);
            building.zone(ind).m_o=str2double(regexp(temp, '(?<==[^0-9]*)[0-9]*\.?[0-9]+', 'match'));
    end
    %dat.EnergyManagementSystem_0x3A_Program.Computer_Class_MixingProgram.lines{1, 1}.program_line  
end
