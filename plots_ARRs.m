close all; 

currentFolder = pwd;
idcs   = strfind(currentFolder,'\');
newdir = currentFolder(1:idcs(end)-1);
addpath([newdir,'\Simulink\jsonlab'])

addpath([newdir,'\Simulink'])
addpath(pwd)

addpath([newdir,'\Simulink'])

dat=loadjson([newdir,'\ePlus\ASHRAE9012016_SchoolPrimary_Denver.epJSON'])
run('DesignParameters.m')
run('faults_setting.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% state estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=4;
n=400/1.5;
%%
clear h1 h2 h3 h4
run('DesignParameters.m')
run('faults_setting.m')

%%

morning=6;
for day=1
    xStart = day*seconds(60*60*24);
    xEnd = (day+1)*seconds(60*60*24); 

for i=10%1: numel(building.zone)
    figure('Name',['ARRs: Cooling Operation for zone ',building.zone(i).tag],'Position', [100 100 1000 1000])
    
    subplot(4,1,1)
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    Res_zC=load(['Res_zC_',building.zone(i).tag,'.mat']);
    Th_zC=load(['Th_zC_',building.zone(i).tag,'.mat']);
    p1=plot(seconds(Res_zC.ans.Time), Res_zC.ans.data,'.');
    set(p1,'MarkerSize',12,'Color','k')%,'Linestyle','-')
    hold on
    p2=plot(seconds(Th_zC.ans.Time), Th_zC.ans.data,'.');
    set(p2,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':')   
%     Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
%     Th_zH=load(['Th_zH_',building.zone(i).tag,'.mat']);
%     p3=plot(seconds(Res_zH.ans.Time), Res_zH.ans.Data,'.');
%     set(p3,'MarkerSize',12,'Color','k')%,'Linestyle','-')
%     hold on
%     p4=plot(seconds(Th_zH.ans.Time), Th_zH.ans.data,'.');
%     set(p4,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':')
    title(['ARR: Air Temperature for zone ',building.zone(i).tag])
    grid on
    xlim([xStart+seconds(60*60*morning) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss') 
    ylim([-5 30])
    y=ylabel('($^oC$)');
    set(y,'Interpreter','latex','FontSize',17)
    box on
    
    yyaxis right
    D_zC=load(['D_zC_',building.zone(i).tag,'.mat']);
    p5=plot(seconds(D_zC.ans.Time), D_zC.ans.Data);
    set(p5,'LineWidth',2.5,'Linestyle','--')%'Color','red'
    hold on
%     D_zH=load(['D_zH_',building.zone(i).tag,'.mat']);
%     p6=plot(seconds(D_zH.ans.Time), D_zH.ans.Data);
%     set(p6,'LineWidth',2.5,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    yticks([0 1])
    grid on
   
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    p7=area(seconds(EnableD_C.ans.Time), 2.*EnableD_C.ans.Data)
    set(p7,'EdgeColor','none','FaceColor',[0.6 0.6 0.99],'FaceAlpha',.15) % 'LineWidth',2,'Linestyle','-',
    EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
    p8=area(seconds(EnableD_H.ans.Time), 2.*EnableD_H.ans.Data)
    set(p8,'EdgeColor','none','FaceColor',[.99 0.6 0.6],'FaceAlpha',.15) %'LineWidth',2,'Linestyle','-',
    %ylim([-0.1 2])
    
    if ~ismember(0,building.zone(i).z_additive_Sensor_fault_value)
    h1=plot(seconds(building.zone(i).z_additive_Sensor_fault_time),1.3,'o','Markersize',5);
    h1.LineWidth=10;
    h1.Color= [0.9 0.1 0.1]; 
    end
    if ~ismember(1,building.zone(i).z_mult_Sensor_fault_value)
    h1=plot(seconds(building.zone(i).z_mult_Sensor_fault_time),1.3,'o','Markersize',5);
    h1.LineWidth=10;
    h1.Color= [0.1 0.1 0.9]; 
    end
    
    
    h=legend([p1 p2 p5 p7 p8],['$|\epsilon_{{\rm{z}}_{', num2str(i) ,'}}(k)|$'],...
        ['$\overline{\epsilon}_{{\rm{z}}_{', num2str(i) ,'}}(k)$'],...
        ['$D_{{\rm{z}}_{', num2str(i) ,'}}(k)$'],...
        'Cooling','Heating');
    set(h,'Interpreter','latex','FontSize',16,'Location','northeast','Orientation','horizontal')
    set(gca,'FontSize',10,'fontweight','bold')

%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    subplot(4,1,2)
    Res_saC=load(['Res_saC_',building.zone(i).tag,'.mat']);
    Th_saC=load(['Th_saC_',building.zone(i).tag,'.mat']);
    p1=plot(seconds(Res_saC.ans.Time), Res_saC.ans.data,'.');
    set(p1,'MarkerSize',12,'Color','k')%,'Linestyle','-')
    hold on
    p2=plot(seconds(Th_saC.ans.Time), Th_saC.ans.data,'.');
    set(p2,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':')
%     Res_saH=load(['Res_saH_',building.zone(i).tag,'.mat']);
%     Th_saH=load(['Th_saH_',building.zone(i).tag,'.mat']);
%     p3=plot(seconds(Res_saH.ans.Time), Res_saH.ans.data,'.');
%     set(p3,'MarkerSize',12,'Color','k')%,'Linestyle','-')
%     hold on
%     p4=plot(seconds(Th_saH.ans.Time), Th_saH.ans.data,'.');
%     set(p4,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':')
    grid on
    xlim([xStart+seconds(60*60*morning) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-5 30])
    y=ylabel('($^oC$)');
    set(y,'Interpreter','latex','FontSize',17)
    box on
    title(['ARR: Supply Air for zone ',building.zone(i).tag])
%     h=legend(['$|\epsilon_{{\rm{sa}}_{', num2str(i) ,'}}(k)|$'],['$\overline{\epsilon}_{{\rm{sa}}_{', num2str(i) ,'}}(k)$']);
%     set(h,'Interpreter','latex','FontSize',16)
    xlim([xStart+seconds(60*60*morning) xEnd-seconds(60*60*8)])
%     xtickformat('dd:hh:mm:ss')  

    yyaxis right
    D_saC=load(['D_saC_',building.zone(i).tag,'.mat']);
    p5=plot(seconds(D_saC.ans.Time), D_saC.ans.Data);
    set(p5,'LineWidth',2.5,'Linestyle','--')%,'Color',[.3 0.6 0.3])
%     D_saH=load(['D_saH_',building.zone(i).tag,'.mat']);
%     p6=plot(seconds(D_saH.ans.Time), D_saH.ans.Data);
%     set(p6,'LineWidth',2.5,'Linestyle','--')%,'Color',[.3 0.6 0.3])
    ylim([-0.1 2])
    yticks([0 1])
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    p7=area(seconds(EnableD_C.ans.Time), 2.*EnableD_C.ans.Data)
    set(p7,'EdgeColor','none','FaceColor',[0.6 0.6 0.99],'FaceAlpha',.15) % 'LineWidth',2,'Linestyle','-','Color',[0.6 0.6 0.99])
    EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
    p8=area(seconds(EnableD_H.ans.Time), 2.*EnableD_H.ans.Data)
    set(p8,'EdgeColor','none','FaceColor',[.99 0.6 0.6],'FaceAlpha',.15) % ,'LineWidth',2,'Linestyle','-','Color',[.99 0.6 0.6])
   
    if ~ismember(0,building.zone(i).sa_additive_Sensor_fault_value)
    h2=plot(seconds(building.zone(i).sa_additive_Sensor_fault_time),1.3,'o','Markersize',5);
    h2.LineWidth=10;
    h2.Color= [0.9 0.1 0.1]; 
    end
    if ~ismember(1,building.zone(i).sa_mult_Sensor_fault_value)
    h2=plot(seconds(building.zone(i).sa_mult_Sensor_fault_time),1.3,'o','Markersize',5);
    h2.LineWidth=10;
    h2.Color= [0.1 0.1 0.9]; 
    end
    
    h=legend([p1 p2 p5 p7 p8],['$|\epsilon_{{\rm{sa}}_{', num2str(i) ,'}}(k)|$'],...
        ['$\overline{\epsilon}_{{\rm{sa}}_{', num2str(i) ,'}}(k)$'],...
        ['$D_{{\rm{sa}}_{', num2str(i) ,'}}(k)$'],...
        'Cooling','Heating');
    set(h,'Interpreter','latex','FontSize',16,'Location','northeast','Orientation','horizontal')
    set(gca,'FontSize',10,'fontweight','bold')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
    subplot(4,1,3)
    %figure
    %i=14
    Res_c_C=load(['Res_c_C_',building.zone(i).tag,'.mat']);
    Th_c_C=load(['Th_c_C_',building.zone(i).tag,'.mat']);
    p1=plot(seconds(Res_c_C.ans.Time), Res_c_C.ans.data,'.');
    set(p1,'MarkerSize',12,'Color','k')%,'Linestyle','-')
    hold on
    p2=plot(seconds(Th_c_C.ans.Time), Th_c_C.ans.data,'.');
    set(p2,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':')
    
    ylim([-5 40])
    y=ylabel('($^oC$)');
    set(y,'Interpreter','latex','FontSize',17)
    box on
    title(['ARR: Cooling Coil for zone ',building.zone(i).tag])
    grid on
    xlim([xStart+seconds(60*60*morning) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    box on
    
    yyaxis right
    D_cC=load(['D_c_C_',building.zone(i).tag,'.mat']);
    p5=plot(seconds(D_cC.ans.Time), D_cC.ans.Data);
    set(p5,'LineWidth',2.5,'Linestyle','--')%'Color','red'

    ylim([-0.1 2])
    yticks([0 1])
    grid on
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    p7=area(seconds(EnableD_C.ans.Time), 2.*EnableD_C.ans.Data)
    set(p7,'EdgeColor','none','FaceColor',[0.6 0.6 0.99],'FaceAlpha',.15) % 'LineWidth',2,'Linestyle','-',
    EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
    p8=area(seconds(EnableD_H.ans.Time), 2.*EnableD_H.ans.Data)
    set(p8,'EdgeColor','none','FaceColor',[.99 0.6 0.6],'FaceAlpha',.15) %'LineWidth',2,'Linestyle','-',

    if ~ismember(0,building.zone(i).c_C_additive_Sensor_fault_value)
    h3=plot(seconds(building.zone(i).c_C_additive_Sensor_fault_time),1.3,'o','Markersize',5);
    h3.LineWidth=10;
    h3.Color= [0.9 0.1 0.1]; 
    end
    if ~ismember(1,building.zone(i).c_C_mult_Sensor_fault_value)
    h3=plot(seconds(building.zone(i).c_C_mult_Sensor_fault_time),1.3,'o','Markersize',5);
    h3.LineWidth=10;
    h3.Color= [0.1 0.1 0.9]; 
    end
    
    h=legend([p1 p2 p5 p7 p8],['$|\epsilon_{{\rm{cc}}_{', num2str(i) ,'}}(k)|$'],...
        ['$\overline{\epsilon}_{{\rm{cc}}_{', num2str(i) ,'}}(k)$'],...
        ['$D_{{\rm{cc}}_{', num2str(i) ,'}}(k)$'],...
        'Cooling','Heating');
    set(h,'Interpreter','latex','FontSize',16,'Location','northeast','Orientation','horizontal')
   set(gca,'FontSize',10,'fontweight','bold')
   
    %%%%%%%%%%%%%%%%%
    
    subplot(4,1,4)
    %figure
    %i=1
    Res_c_H=load(['Res_c_H_',building.zone(i).tag,'.mat']);
    Th_c_H=load(['Th_c_H_',building.zone(i).tag,'.mat']);
    
    p3=plot(seconds(Res_c_H.ans.Time), Res_c_H.ans.data,'.');
    set(p3,'MarkerSize',12,'Color','k')%,'Linestyle','-')
    hold on
    p4=plot(seconds(Th_c_H.ans.Time), Th_c_H.ans.data,'.');
    set(p4,'MarkerSize',12,'Color',[0.5 0.5 0.7])%,'Linestyle',':') 
    
%     figure
%     load(['ae_C_H_',building.zone(i).tag,'.mat'])
%     plot(seconds(ans.Time), ans.data,'.');
%     hold on
%     load(['ae_C_H_sum_',building.zone(i).tag,'.mat'])
%     plot(seconds(ans.Time), ans.data,'.');
%     load(['x_C_H_',building.zone(i).tag,'.mat'])
%     plot(seconds(ans.Time), ans.data,'.');
    
    ylim([-5 30])
    y=ylabel('($^oC$)');
    set(y,'Interpreter','latex','FontSize',17)
    box on
    title(['ARR: Heating Coil for zone ',building.zone(i).tag])
    grid on
    xlim([xStart+seconds(60*60*morning) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    box on
    
    yyaxis right
    D_cH=load(['D_c_H_',building.zone(i).tag,'.mat']);
    p6=plot(seconds(D_cH.ans.Time), D_cH.ans.Data);
    set(p6,'LineWidth',2.5,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    yticks([0 1])
    grid on
 
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    p7=area(seconds(EnableD_C.ans.Time), 2.*EnableD_C.ans.Data)
    set(p7,'EdgeColor','none','FaceColor',[0.6 0.6 0.99],'FaceAlpha',.15) % 'LineWidth',2,'Linestyle','-',
    EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
    p8=area(seconds(EnableD_H.ans.Time), 2.*EnableD_H.ans.Data)
    set(p8,'EdgeColor','none','FaceColor',[.99 0.6 0.6],'FaceAlpha',.15) %'LineWidth',2,'Linestyle','-',
    
    if ~ismember(0,building.zone(i).c_H_additive_Sensor_fault_value)
    h4=plot(seconds(building.zone(i).c_H_additive_Sensor_fault_time),1.3,'o','Markersize',5);
    h4.LineWidth=10;
    h4.Color= [0.9 0.1 0.1]; 
    end
    if ~ismember(1,building.zone(i).c_H_mult_Sensor_fault_value)
    h4=plot(seconds(building.zone(i).c_H_mult_Sensor_fault_time),1.3,'o','Markersize',5);
    h4.LineWidth=10;
    h4.Color= [0.1 0.1 0.9]; 
    end
    
    h=legend([p3 p4 p6 p7 p8],['$|\epsilon_{{\rm{hc}}_{', num2str(i) ,'}}(k)|$'],...
        ['$\overline{\epsilon}_{{\rm{hc}}_{', num2str(i) ,'}}(k)$'],...
        ['$D_{{\rm{hc}}_{', num2str(i) ,'}}(k)$'],...
        'Cooling','Heating');
    set(h,'Interpreter','latex','FontSize',16,'Location','northeast','Orientation','horizontal')
    xlabel('Time (dd:hh:mm:ss)')
    set(gca,'FontSize',10,'fontweight','bold')
    
    
   hold off
   tightfig
   saveas(gcf,[newdir,'\Results\Panayiotis_Diagnosis_Plots\Detection_z',num2str(i),'_d', num2str(day)], 'pdf')

    
end
    
end
