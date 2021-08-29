close all; 
clear all
currentFolder = pwd;
readepJSONout

%%
global PER Scenario
sc=[2 4 8 16 32 64 128];
zone=10;
for Scenario= 1:7
PER= (sc(Scenario))/100;
faults_setting
addpath([currentFolder,'\Results_fz10_sensor_',num2str(Scenario)'])

D_zC=load([currentFolder,'\Results_fz10_sensor_',num2str(Scenario),'\D_zC_',building.zone(zone).tag,'.mat']);
D(1,Scenario)=D_zC.ans.Data(end);
DL(1,Scenario)=D_zC.ans.Data(end);
clear D_zC
for k=1:length(building.zone(zone).neighbour)
    D_zC=load([currentFolder,'\Results_fz10_sensor_',num2str(Scenario),'\D_zC_',regexprep(building.zone(zone).neighbour{k},'_',''),'.mat']);
    D(k+1,Scenario)=D_zC.ans.Data(end);
    clear D_zC
end
D_saC=load([currentFolder,'\Results_fz10_sensor_',num2str(Scenario),'\D_saC_',building.zone(zone).tag,'.mat']);
DL(2,Scenario)=D_saC.ans.Data(end);
D_c_C=load([currentFolder,'\Results_fz10_sensor_',num2str(Scenario),'\D_c_C_',building.zone(zone).tag,'.mat']);
DL(3,Scenario)=D_c_C.ans.Data(end);
D_c_H=load([currentFolder,'\Results_fz10_sensor_',num2str(Scenario),'\D_c_H_',building.zone(zone).tag,'.mat']);
DL(4,Scenario)=D_c_H.ans.Data(end);
%plot(D_zC.ans.Time,D_zC.ans.Data)
end
%%
clear B ind
for l=1:length(building.zone)
B{l}=building.zone(l).tag;
end
for l=1:length(building.zone)
    for m=1:length(building.zone(l).neighbour)
        
[~,ind(l,m)]=ismember(regexprep(building.zone(l).neighbour{m},'_',''),B)
    end
end

%%

figure
fH = gcf; colormap(jet(4));
clear i; 
for i=1:length(building.zone(zone).neighbour)+1 % number of Agents 
     subplot(length(building.zone(zone).neighbour)+1,1,i)
     %for i=1:6 % number of scenarios
     bar(D(i,:),'FaceAlpha',0.6)
    %end
    %title(['Scenario f=[' num2str(TH(i,:)) ']'])
    %yticklabels('Agent 1', 'Agent 2', 'Agent 3', 'Agent 4', 'Agent 5')
    xticklabels({'2%','4%','8%','16%','32%','64%','128%'})
    if i==1
     y=ylabel(['$D_{{\rm{z}}_{', num2str(zone) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    else
     y=ylabel(['$D_{{\rm{z}}_{', num2str(ind(zone,i-1)) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    end
    set(y,'Interpreter','latex','FontSize',17)
    
    box on
    
    %applyhatch_plusC
    %applyhatch_plusC(fH, '|-.+\', 'rbmkg');
    %applyhatch(gcf,'|-.+\')%,1,[1 1 0 1 0 ],cool(5),200,3,2);  
    hold on

end
xlabel('Sensor Fault Magnitude (% of the desired temperature)')
    %set(h,'Interpreter','latex','FontSize',16,'Location','northeast','Orientation','horizontal')
    %set(gca,'FontSize',10,'fontweight','bold')
%end

%%
figure
fH = gcf; colormap(jet(4));
clear i; 
for i=1:4 % number of Agents 
    subplot(4,1,i)
    bar(DL(i,:),'FaceAlpha',0.6)
    xticklabels({'2%','4%','8%','16%','32%','64%','128%'})
    if i==1
     y=ylabel(['$D_{{\rm{z}}_{', num2str(zone) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    elseif i==2
     y=ylabel(['$D_{{\rm{sa}}_{', num2str(zone) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    elseif i==3
     y=ylabel(['$D_{{\rm{cc}}_{', num2str(zone) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    else 
     y=ylabel(['$D_{{\rm{hc}}_{', num2str(zone) ,'}}$'])
     set(get(gca,'YLabel'),'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right')
    end
    set(y,'Interpreter','latex','FontSize',17)
    box on
    hold on
end
xlabel('Sensor Fault Magnitude (% of the desired temperature)')