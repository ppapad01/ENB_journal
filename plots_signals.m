%% 
close all; 

currentFolder = pwd;
idcs   = strfind(currentFolder,'\');
newdir = currentFolder(1:idcs(end)-1);
addpath([newdir,'\Simulink\jsonlab'])

addpath([newdir,'\Simulink'])
addpath(pwd)

dat=loadjson([newdir,'\ePlus\ASHRAE9012016_SchoolPrimary_Denver.epJSON'])
run('DesignParameters.m')
run('faults_setting.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% state estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
i=2;
% n=400/1.5;
% 
% g=400;
% h=1.5;
% pole=-(1/g)*h; % observer pole
% h1=5;
% pole1=-(1/g)*h1; 
% h2=6;
% pole2=-(1/g)*h2;
%%
    figure('Name',['Estimation: Air Temperature for zone ',building.zone(i).tag])
    load(['Tz_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
%     hold on
%     load(['TzhatH_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data/n)
    hold on
    load(['Tzhat_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    %legend('Tz','TzhatH','TzhatC')
    legend('Tz','Tzhat')
    title(['Air Temperature Estimation for zone ',building.zone(i).tag])
%     ylim([0 30])

 %%   
    figure('Name',['Estimation: Cooling SA Temperature for zone ',building.zone(i).tag])
    load(['Tsa_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
%     hold on
%     load(['TsahatH_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data/n)
    hold on
    load(['Tsahat_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data(:,1))
    plot(ans.Time/3600, (ans.data(:,2)))
    grid on
    legend('Th,sa','Tc,sahat','Th,sahat')
    title(['SA Temperature Estimation for zone ',building.zone(i).tag])
%     ylim([0 30])
    
%%

    figure('Name',['Estimation: Cooling Coil Water Temperature for zone ',building.zone(i).tag])
    load(['Tc_C_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['Tchat_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data(:,1))
    plot(ans.Time/3600, ans.data(:,2))
    grid on
    legend('Tcc','Tc,sahat','Tcchat')
    title(['Cooling Coil Water Temperature Estimation for zone ',building.zone(i).tag])
%     ylim([0 30])
%%    
    figure('Name',['Estimation: Heating Coil Water Temperature for zone ',building.zone(i).tag])
    load(['Tc_H_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['TchatH_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data(:,1))
    plot(ans.Time/3600, ans.data(:,2))
    plot(ans.Time/3600, ans.data(:,3))
    plot(ans.Time/3600, ans.data(:,4))
    grid on
    legend('Thc','Tc,sahat','Tcchat','Th,sahat','Thchat')
    title(['Heating Coil Water Temperature Estimation for zone ',building.zone(i).tag])
% %     ylim([0 30])
%%    
 %%   
for i=4 %1:25
    figure('Name',['Estimation: Cooling SA Temperature for zone ',building.zone(i).tag])
    load(['Res_zC_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['Res_saC_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['Res_c_C_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['Res_c_H_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    %plot(ans.Time/3600, (ans.data(:,2)))
    grid on
    legend('Res_z','Res_sa','Res_c_C','Res_c_H')
    title(['SA Temperature Estimation for zone ',building.zone(i).tag])
end
%     ylim([0 30])
%%
%%%%%%%%%%%%%%%%%%%%%% plot estimation errors %%%%%%%%

    figure('Name',['Estimation Error : Air Temperature for zone ',building.zone(i).tag])
    Tz=load(['Tz_',building.zone(i).tag,'.mat']);
    ThatzH=load(['TzhatH_',building.zone(i).tag,'.mat']);
    ThatzC=load(['Tzhat_',building.zone(i).tag,'.mat']);
    plot(Tz.ans.Time/3600, abs(Tz.ans.data - ThatzH.ans.data/n))
    hold on
    
    plot(Tz.ans.Time/3600, Tz.ans.data-ThatzC.ans.data/n)
    grid on
    legend('|Tz - TzhatH|','|Tz - TzhatC|')
    title(['Air Temperature Estimation Error for zone ',building.zone(i).tag])
%     ylim([0 30])

    
    figure('Name',['Estimation Error : Cooling SA Temperature for zone ',building.zone(i).tag])
    Tsa=load(['Tsa_',building.zone(i).tag,'.mat']);
    TsahatH=load(['TsahatH_',building.zone(i).tag,'.mat']);
    TsahatC=load(['Tsahat_',building.zone(i).tag,'.mat']);
    plot(Tsa.ans.Time/3600, abs(Tsa.ans.data - TsahatH.ans.data/n))
    hold on  
    plot(Tsa.ans.Time/3600, abs(Tsa.ans.data - TsahatC.ans.data/n))
    grid on
    legend('|Tsa-TsahatH|','|Tsa-TsahatC|')
    title(['SA Temperature Estimation Error for zone ',building.zone(i).tag])
%     ylim([0 30])
    
    figure('Name',['Estimation Error: Cooling Coil Water Temperature for zone ',building.zone(i).tag])
    TcC=load(['Tc_C_',building.zone(i).tag,'.mat']);
    TchatC=load(['Tchat_',building.zone(i).tag,'.mat']);
    plot(TcC.ans.Time/3600, abs(TcC.ans.data-TchatC.ans.data/n))
    grid on
    legend('|Tc_C-TchatC|')
    title(['Cooling Coil Water Temperature Estimation Error for zone ',building.zone(i).tag])
%     ylim([0 30])
    
    figure('Name',['Estimation Error: Heating Coil Water Temperature for zone ',building.zone(i).tag])
    TcH=load(['Tc_H_',building.zone(i).tag,'.mat']);
    TchatH=load(['TchatH_',building.zone(i).tag,'.mat']);
    plot(TcH.ans.Time/3600, abs(TcH.ans.data-TchatH.ans.data/n))
    grid on
    legend('|Tc_H-TchatH|')
    title(['Heating Coil Water Temperature Estimation Error for zone ',building.zone(i).tag])
% %     ylim([0 30])

%%%%%%

    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_zC=load(['Res_zC_',building.zone(i).tag,'.mat']);
    plot(Res_zC.ans.Time/3600, Res_zC.ans.data) %/n
    %ylim([0 30])
    
    figure('Name',['a^(k)e: Cooling: Air Temperature for zone ',building.zone(i).tag])
    aeC=load(['aeC_',building.zone(i).tag,'.mat']);
    plot(aeC.ans.Time/3600, aeC.ans.data)
    
    figure('Name',['a: Cooling: Air Temperature for zone ',building.zone(i).tag])
    a=load(['a_',building.zone(i).tag,'.mat']);
    plot(a.ans.Time/3600, a.ans.data)
    
    figure('Name',['ae_sum: Cooling: Air Temperature for zone ',building.zone(i).tag])
    aeC_sum=load(['aeC_sum_',building.zone(i).tag,'.mat']);
    plot(aeC_sum.ans.Time/3600, aeC_sum.ans.data)
    
    figure('Name',['x: Cooling: Air Temperature for zone ',building.zone(i).tag])
    xC=load(['xC_',building.zone(i).tag,'.mat']);
    plot(xC.ans.Time/3600, xC.ans.data)
    
    figure('Name',['k: Cooling: Air Temperature for zone ',building.zone(i).tag])
    kC=load(['kC_',building.zone(i).tag,'.mat']);
    plot(kC.ans.Time/3600, kC.ans.data)
 %%   cooling residuals
    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_zC=load(['Res_zC_',building.zone(i).tag,'.mat']);
    plot(Res_zC.ans.Time/3600, Res_zC.ans.data) %/n
    hold on
    Th_zC=load(['Th_zC_',building.zone(i).tag,'.mat']);
    plot(Th_zC.ans.Time/3600, Th_zC.ans.data) %/n
    
    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_saC=load(['Res_saC_',building.zone(i).tag,'.mat']);
    plot(Res_saC.ans.Time/3600, Res_saC.ans.data) %/n
    hold on
    Th_saC=load(['Th_saC_',building.zone(i).tag,'.mat']);
    plot(Th_saC.ans.Time/3600, Th_saC.ans.data) %/n
    
    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_cC=load(['Res_c_C_',building.zone(i).tag,'.mat']);
    plot(Res_cC.ans.Time/3600, Res_cC.ans.data) %/n
    hold on
    Th_cC=load(['Th_c_C_',building.zone(i).tag,'.mat']);
    plot(Th_cC.ans.Time/3600, Th_cC.ans.data) %/n
    
    
   %%
   
       figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
    plot(Res_zH.ans.Time/3600, Res_zH.ans.data) %/n
    hold on
    Th_zH=load(['Th_zH_',building.zone(i).tag,'.mat']);
    plot(Th_zH.ans.Time/3600, Th_zH.ans.data) %/n
    
    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_saH=load(['Res_saH_',building.zone(i).tag,'.mat']);
    plot(Res_saH.ans.Time/3600, Res_saH.ans.data) %/n
    hold on
    Th_saH=load(['Th_saH_',building.zone(i).tag,'.mat']);
    plot(Th_saH.ans.Time/3600, Th_saH.ans.data) %/n
    
    figure('Name',['Res: Cooling: Air Temperature for zone ',building.zone(i).tag])
    Res_cH=load(['Res_c_H_',building.zone(i).tag,'.mat']);
    plot(Res_cH.ans.Time/3600, Res_cH.ans.data) %/n
    hold on
    Th_cH=load(['Th_c_H_',building.zone(i).tag,'.mat']);
    plot(Th_cH.ans.Time/3600, Th_cH.ans.data) %/n
    
    
 %%   
    close all
for day=1 
    xStart = day*seconds(60*60*24);
    xEnd = (day+1)*seconds(60*60*24); 
    
for i= 4 %: numel(building.zone)
    figure('Name',['ARRs: Cooling Operation for zone ',building.zone(i).tag],'Position', [100 100 700 500])
    mcC=load(['mc_C_',building.zone(i).tag,'.mat']);
    mcH=load(['mc_H_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(mcC.ans.Time), mcC.ans.Data);
    set(pole,'LineWidth',2.2,'Color','k','Linestyle','-')
    hold on
    pole=plot(seconds(mcH.ans.Time), mcH.ans.Data);
    set(pole,'LineWidth',2,'Color','k','Linestyle',':')
    h=legend(['$m_{{\rm{cC}}_{', num2str(i) ,'}}$'],['$m_{{\rm{CH}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
    pole=plot(seconds(mcH.ans.Time), zeros(size(mcH.ans.Data)));
    set(pole,'LineWidth',2,'Color','r','Linestyle',':')
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')
    
    figure
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(EnableD_C.ans.Time), EnableD_C.ans.Data)
    hold on
    pole=plot(seconds(EnableD_H.ans.Time), EnableD_H.ans.Data)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')
    legend('cooling','heating')
    ylim([-0.1 2])
    
end
end

 %%   
   % close all
for day=1 
    xStart = day*seconds(60*60*24);
    xEnd = (day+1)*seconds(60*60*24); 
    
for i= 4 %: numel(building.zone)
    figure('Name',['ARRs: Cooling Operation for zone ',building.zone(i).tag],'Position', [100 100 1000 800])
    
    %subplot(3,2,1)
    subplot(3,1,1)
    %yyaxis left
    %Tz=load(['Tz_',building.zone(i).tag,'.mat']);
    %Thatz=load(['Tzhat_',building.zone(i).tag,'.mat']);
    EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
    at=find(EnableD_C.ans.Data);
    en=EnableD_C.ans.Data(at);
    time=EnableD_C.ans.Time(at);
    T=seconds(Res_zC.ans.Time);
    
    Res_zC=load(['Res_zC_',building.zone(i).tag,'.mat']);
    
   
    
    Th_zC=load(['Th_zC_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_zC.ans.Time), Res_zC.ans.data,'.');
    set(pole,'LineWidth',2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_zC.ans.Time), Th_zC.ans.data,'.');
    set(pole,'LineWidth',2,'Color','b')%,'Linestyle',':')   
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-5 30])
    y=ylabel('($^oC$)','FontSize',12);
    set(y,'Interpreter','latex','FontSize',11)
    box on
    yyaxis right
    D_zC=load(['D_zC_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_zC.ans.Time), D_zC.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Cooling: Air Temperature for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{z}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{z}}_{', num2str(i) ,'}}$'],['$D_{{\rm{z}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
    %yyaxis left
%     p=plot(seconds(EnableD_C.ans.Time), EnableD_C.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','blue')
%     ylim([-0.1 2])
    
    %subplot(3,2,2)
    Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
    Th_zH=load(['Th_zH_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_zH.ans.Time), Res_zH.ans.Data,'.');
    set(pole,'LineWidth',2.2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_zH.ans.Time), Th_zH.ans.data,'.');
    set(pole,'LineWidth',2,'Color','r')%,'Linestyle',':')
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-5 30])
    y=ylabel('($^oC$)','FontSize',12);
    set(y,'Interpreter','latex','FontSize',11)
    box on
    yyaxis right
    D_zH=load(['D_zH_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_zH.ans.Time), D_zH.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Heating: Air Temperature for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{z}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{z}}_{', num2str(i) ,'}}$'],['$D_{{\rm{z}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
    %yyaxis left
%     EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
%     p=plot(seconds(EnableD_H.ans.Time), EnableD_H.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','red')
%     ylim([-0.1 2])
    
    subplot(3,1,2)
    %Tsa=load(['Tsa_',building.zone(i).tag,'.mat']);
    %Thatsa=load(['Tsahat_',building.zone(i).tag,'.mat']);
    Res_saC=load(['Res_saC_',building.zone(i).tag,'.mat']);
    Th_saC=load(['Th_saC_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_saC.ans.Time), Res_saC.ans.data,'.');
    set(pole,'LineWidth',2.2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_saC.ans.Time), Th_saC.ans.data,'.');
    set(pole,'LineWidth',2,'Color','b')%,'Linestyle',':')
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-2 30])
    box on
    yyaxis right
    D_saC=load(['D_saC_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_saC.ans.Time), D_saC.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Cooling: Supply Air for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{sa}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{sa}}_{', num2str(i) ,'}}$'],['$D_{{\rm{sa}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
%     EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
%     p=plot(seconds(EnableD_C.ans.Time), EnableD_C.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','blue')
%     ylim([-0.1 2])
    
    
    %subplot(3,2,4)
    %Tsa=load(['Tsa_',building.zone(i).tag,'.mat']);
    %ThatsaH=load(['TsahatH_',building.zone(i).tag,'.mat']);
    Res_saH=load(['Res_saH_',building.zone(i).tag,'.mat']);
    Th_saH=load(['Th_saH_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_saH.ans.Time), Res_saH.ans.data,'.');
    set(pole,'LineWidth',2.2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_saH.ans.Time), Th_saH.ans.data,'.');
    set(pole,'LineWidth',2,'Color','r')%,'Linestyle',':')
    grid on
    h=legend(['$\epsilon_{{\rm{sa}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{sa}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',16)
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-2 30])
    box on
    yyaxis right
    D_saH=load(['D_saH_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_saH.ans.Time), D_saH.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Heating: Supply Air for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{sa}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{sa}}_{', num2str(i) ,'}}$'],['$D_{{\rm{sa}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
%     EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
%     p=plot(seconds(EnableD_H.ans.Time), EnableD_H.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','red')
%     ylim([-0.1 2])
    
    subplot(3,1,3)
    %Tc_C=load(['Tc_C_',building.zone(i).tag,'.mat']);
    %Thatc=load(['Tchat_',building.zone(i).tag,'.mat']);
    Res_c_C=load(['Res_c_C_',building.zone(i).tag,'.mat']);
    Th_c_C=load(['Th_c_C_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_c_C.ans.Time), Res_c_C.ans.data,'.');
    set(pole,'LineWidth',2.2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_c_C.ans.Time), Th_c_C.ans.data,'.');
    set(pole,'LineWidth',2,'Color','b')%,'Linestyle',':')
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-2 30])
    box on
    yyaxis right
    D_cC=load(['D_cC_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_cC.ans.Time), D_cC.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Cooling: Coil for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{c}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{c}}_{', num2str(i) ,'}}$'],['$D_{{\rm{c}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
%     EnableD_C=load(['EnableD_C_',building.zone(i).tag,'.mat']);
%     p=plot(seconds(EnableD_C.ans.Time), EnableD_C.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','blue')
%     ylim([-0.1 2])
    
   % subplot(3,2,6)
    %Tc_H=load(['Tc_H_',building.zone(i).tag,'.mat']);
    %Thatc=load(['Tchat_',building.zone(i).tag,'.mat']);
    Res_c_H=load(['Res_c_H_',building.zone(i).tag,'.mat']);
    Th_c_H=load(['Th_c_H_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(Res_c_H.ans.Time), Res_c_H.ans.data,'.');
    set(pole,'LineWidth',2.2,'Color','k')%,'Linestyle','-')
    hold on
    pole=plot(seconds(Th_c_H.ans.Time), Th_c_H.ans.data,'.');
    set(pole,'LineWidth',2,'Color','r')%,'Linestyle',':')
    grid on
    h=legend(['$\epsilon_{{\rm{c}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{c}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',16)
    %xlabel('Time (hours)','FontSize',12)
    xlim([xStart+seconds(60*60*7) xEnd-seconds(60*60*8)])
    xtickformat('dd:hh:mm:ss')  
    ylim([-2 30])
    box on
    yyaxis right
    D_cH=load(['D_cH_',building.zone(i).tag,'.mat']);
    pole=plot(seconds(D_cH.ans.Time), D_cH.ans.Data);
    set(pole,'LineWidth',2,'Linestyle','--')%'Color','red'
    ylim([-0.1 2])
    title(['ARR: Heating: Coil for zone ',building.zone(i).tag])
    grid on
    h=legend(['$\epsilon_{{\rm{c}}_{', num2str(i) ,'}}$'],['$\overline{\epsilon}_{{\rm{c}}_{', num2str(i) ,'}}$'],['$D_{{\rm{c}}_{', num2str(i) ,'}}$']);
    set(h,'Interpreter','latex','FontSize',11,'Location','best','Orientation','horizontal')
%     EnableD_H=load(['EnableD_H_',building.zone(i).tag,'.mat']);
%     p=plot(seconds(EnableD_H.ans.Time), EnableD_H.ans.Data)
%     set(p,'LineWidth',2,'Linestyle',':','Color','red')
%     ylim([-0.1 2])
%     
    
   hold off
   tightfig
   saveas(gcf,[newdir,'\Results\Panayiotis_Diagnosis_Plots\Detection_z',num2str(i),'_d', num2str(day)], 'pdf')

    
end
    
end

%%

    figure('Name',['Res: Heating: Air Temperature for zone ',building.zone(i).tag])
    Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
    plot(Res_zH.ans.Time/3600, Res_zH.ans.data)
    %ylim([0 30])
    
    figure('Name',['ae: Heating: Air Temperature for zone ',building.zone(i).tag])
    aeH=load(['aeH_',building.zone(i).tag,'.mat']);
    plot(aeH.ans.Time/3600, aeH.ans.data)
    
    figure('Name',['ae_sum: Heating: Air Temperature for zone ',building.zone(i).tag])
    aeH_sum=load(['aeH_sum_',building.zone(i).tag,'.mat']);
    plot(aeH_sum.ans.Time/3600, aeH_sum.ans.data)
    
    figure('Name',['x: Heating: Air Temperature for zone ',building.zone(i).tag])
    xH=load(['xH_',building.zone(i).tag,'.mat']);
    plot(xH.ans.Time/3600, xH.ans.data)
    
    figure('Name',['k: Heating: Air Temperature for zone ',building.zone(i).tag])
    kH=load(['kH_',building.zone(i).tag,'.mat']);
    plot(kH.ans.Time/3600, kH.ans.data)
    
    
    figure('Name',['ARR: Heating: Air Temperature for zone ',building.zone(i).tag])
    %Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
    Tz=load(['Tz_',building.zone(i).tag,'.mat']);
    ThatzH=load(['TzhatH_',building.zone(i).tag,'.mat']);
    Th_zH=load(['Th_zH_',building.zone(i).tag,'.mat']);
    plot(Tz.ans.Time/3600, abs(Tz.ans.data - ThatzH.ans.data/n))
    hold on
    plot(Th_zH.ans.Time/3600, Th_zH.ans.data)
    grid on
    legend('Res_zH','Th_zH')
    title(['ARR: Heating: Air Temperature for zone ',building.zone(i).tag])
    % ylim([0 30])
 
 %%%
 
   figure('Name',['ARR: Cooling: SA Temperature for zone ',building.zone(i).tag])
    %Res_zH=load(['Res_zH_',building.zone(i).tag,'.mat']);
    Tsa=load(['Tsa_',building.zone(i).tag,'.mat']);
    Tsahat=load(['Tsahat_',building.zone(i).tag,'.mat']);
    Th_saC=load(['Th_saC_',building.zone(i).tag,'.mat']);
    plot(Tsa.ans.Time/3600, abs(Tsa.ans.data - Tsahat.ans.data/n))
    hold on
    plot(Th_saC.ans.Time/3600, Th_saC.ans.data)
    grid on
    legend('Res_saC','Th_saC')
    title(['ARR: Cooling: SA Temperature for zone ',building.zone(i).tag])
    % ylim([0 30])

%%%%
 
 

  %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
for i = 1 : numel(building.zone)
% 
%     % Valves
%     figure('Name',['Valves for ',building.zone(i).tag])
%     hold on
%     load(['mc_C_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     load(['mc_H_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     hold off
%     grid on
%     legend('mcC','mcH')
%     title(['Valves for ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)
%     % Tz
%     figure('Name',['Temperature for zone ',building.zone(i).tag])
%     load(['Tz_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     grid on
%     legend('Tz')
%     title(['Temperature for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)
    % Tz adaptive
    figure('Name',['Adaptive: Temperature for zone ',building.zone(i).tag])
    load(['Tz_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    legend('Tz')
    title(['Temperature for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)
    
    % Tz constant and adaptive
    figure('Name',['Temperature for zone ',building.zone(i).tag])
    load(['Tz_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    hold on
    load(['Tz_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    hold off
    legend('Tz','Tz_Ad')
    title(['Temperature for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)
  
    % Tz ref
    figure('Name',['Temperature reference for zone ',building.zone(i).tag])
    load(['Tz_ref_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    legend('Tz ref')
    title(['Temperature reference for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)    
%     % Zone error
%     figure('Name',['Temperature error for zone ',building.zone(i).tag])
%     load(['er_Tz_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     grid on
%     legend('Temperature error')
%     title(['Temperature error for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)  
%     % Tsa
%     figure('Name',['Supply air temperature for zone ',building.zone(i).tag])
%     load(['Tsa_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     grid on
%     legend('Tsa')
%     title(['Supply air temperature for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)   
%     % Tsa Adaptive
%     figure('Name',['Supply air temperature for zone ',building.zone(i).tag])
%     load(['Tsa_Ad_',building.zone(i).tag,'.mat'])
%     plot(ans.Time/3600, ans.data)
%     grid on
%     legend('Tsa')
%     title(['Supply air temperature for zone ',building.zone(i).tag])
%     
end 
for i = 1 : numel(building.zone)
    % Tc Cooling
    figure('Name',['Coil temperature for zone ',building.zone(i).tag])
    load(['Tc_C_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    legend('Tc')
    title(['Coil temperature for zone ',building.zone(i).tag])
end 
for i = 1 : numel(building.zone)
    % Tc Ref Cooling
    figure('Name',['Coil temperature for zone ',building.zone(i).tag])
    load(['Tc_C_ref_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    legend('Tc')
    title(['Coil temperature for zone ',building.zone(i).tag])

end

for i = 1 : numel(building.zone)
    % Tsa Ref Adaptive
    figure('Name',['Supply air temperature for zone ',building.zone(i).tag])
    load(['Tsa_ref_Ad_',building.zone(i).tag,'.mat'])
    plot(ans.Time/3600, ans.data)
    grid on
    legend('Tsa')
    title(['Supply air temperature for zone ',building.zone(i).tag])

end










return


figure('Name','coil gains')
load('coil_gains.mat')
i=4;
gains_nom=eval(['[building.zone(' , num2str(i) , ').Kec_C; building.zone(' , num2str(i) , ').Kc_C; building.zone(' , num2str(i) , ').Kcsa_C]'])
i = 3
xxx = [ones(numel(ans.Time),1)*gains_nom(1), ones(numel(ans.Time),1)*gains_nom(2),ones(numel(ans.Time),1)*gains_nom(3)]

plot(ans.Time/3600, abs(ans.data-xxx)*1000)
grid on
legend('coil gains')

figure('Name','coil gains H')
load('coil_gainsH.mat')
plot(ans.Time/3600, ans.data)
grid on
legend('coil gains H')


figure('Name','supply gains')
load('supply_gains.mat')
plot(ans.Time/3600, ans.data)
grid on
legend('supply gains')

i=4;
gains_nom=eval(['[building.zone(' , num2str(i) , ').Kesa_C; building.zone(' , num2str(i) , ').Ksa_C; building.zone(' , num2str(i) , ').K_C; building.zone(' , num2str(i) , ').Kma_C; building.zone(' , num2str(i) , ').Kf_C]'])

xxx = [ones(numel(ans.Time),1)*gains_nom(1), ones(numel(ans.Time),1)*gains_nom(2),ones(numel(ans.Time),1)*gains_nom(3), ones(numel(ans.Time),1)*gains_nom(4),ones(numel(ans.Time),1)*gains_nom(5)]

plot(ans.Time/3600, abs(ans.data-xxx)*1000)
grid on
legend('coil gains')

figure('Name','zone gains')
load('zone_gains.mat')
plot(ans.Time/3600, ans.data)
grid on
legend('zone error','zone ref','Neigh Multi','Neigh Corridor','Amb','Gains')
hold on
% 
% load('zone_gainsH.mat')
% plot(ans)

figure('Name','valves2')

hold on
load('mc.mat')
plot(ans.Time/3600, ans.data)
load('mcH.mat')
plot(ans.Time/3600, ans.data)
legend('mcC','mcH')
hold off
grid on

figure('Name','Ref C')
load('Tc_Ref_C_A.mat')
plot(ans.Time/3600, ans.data)
hold on
load('Tsa_Ref_C_A.mat')
plot(ans.Time/3600, ans.data)
grid on
legend('TcCref','TsaCref')

figure('Name','Ref H')
load('Tc_Ref_H_A.mat')
plot(ans.Time/3600, ans.data)
hold on
load('Tsa_Ref_H_A.mat')
plot(ans.Time/3600, ans.data)
grid on
legend('TcHref','TsaHref')

% figure(4)
% load('phiplus1.mat')
% plot(ans)
% 
% figure(5)
% load('phi.mat')
% plot(ans)
% 
% figure(6)
% load('zk.mat')
% plot(ans)
% 
% figure(7)
% load('m2.mat')
% plot(ans)
% 
% figure(8)
% load('eps.mat')
% plot(ans)
% 
% return
% load('Tsa.mat')
% plot(ans)
% load('Tc.mat')
% plot(ans)
% legend('Tc_ref','Tsa_ref','Tz','Tsa','Tc')
% hold off
% 
% figure(2)
% load('er_Tz.mat')
% plot(ans)
% hold on
% load('Tz_ref.mat')
% plot(ans)
% load('K_I.mat')
% plot(ans)
% legend('er_Tz','Tz_ref','K_I')
% hold off
% 
% 
% 
% 
% %%
% 
% figure(4)
% load('Tc_refH.mat')
% plot(ans)
% hold on
% load('Tsa_refH.mat')
% plot(ans)
% load('TzH.mat')
% plot(ans)
% load('TsaH.mat')
% plot(ans)
% load('TcH.mat')
% plot(ans)
% legend('Tc_refH','Tsa_refH','TzH','TsaH','TcH')
% hold off
% 
% figure(5)
% load('er_TzH.mat')
% plot(ans)
% hold on
% load('Tz_refH.mat')
% plot(ans)
% load('K_IH.mat')
% plot(ans)
% legend('er_TzH','Tz_refH','K_IH')
% hold off
% 
