for j=1:5
load(['noise_' num2str(j) '.mat'])
zone=2;
plotARRs(zone,tout,Eout,Ebarout,Dout,Eouta,Ebarouta,Douta,Eouts,Ebarouts,Douts,Leng,TD)
fname=['noise_' num2str(j) '_arr_' int2str(zone)];
saveas(gcf,fname,'eps2c');
plotTemp(zone,tspan,str_z,x1,Uout,tout,yout,Leng)
fname=['noise_' num2str(j) '_T_' int2str(zone)];
saveas(gcf,fname,'eps2c')
end

%%

for j=1:5
load(['faultsize_' num2str(j) '.mat'])
zone=2;
plotARRs(zone,tout,Eout,Ebarout,Dout,Eouta,Ebarouta,Douta,Eouts,Ebarouts,Douts,Leng,TD)
fname=['faultsize' num2str(j) '_arr_' int2str(zone)];
saveas(gcf,fname,'eps2c');
plotTemp(zone,tspan,str_z,x1,Uout,tout,yout,Leng)
fname=['faultsize' num2str(j) '_T_' int2str(zone)];
saveas(gcf,fname,'eps2c')
end

%%

for j=1:5
load(['location_' num2str(j) '.mat'])
    zone=[1 2 3 4 5];
    
    for i=1:5
        plotARRs(zone(i),tout,Eout,Ebarout,...
            Dout,Eouta,Ebarouta,Douta,Eouts,Ebarouts,Douts,Leng,TD)
        fname=['location_' num2str(j) '_arr_' int2str(zone)];
        saveas(gcf,fname,'eps2c');
        plotTemp(zone(i),tspan,str_z,x1,Uout,tout,yout,Leng)
        fname=['location_' num2str(j) '_T_' int2str(zone)];
        saveas(gcf,fname,'eps2c')
    end
    
    
end

%%
clear i j zz
for j=2 %3:5
    zone=[1 2 3 4 5];
  for i=5 %3:5  
    load(['location_' num2str(j) '_' num2str(i) '.mat'])
    for zz=2 %1:5
    plotARRs(zone(zz),tout,Eout,Ebarout,...
            Dout,Eouta,Ebarouta,Douta,...
            Eouts,Ebarouts,Douts,Leng,TD)
    end
  end   
end

clear i j zz
for j=1:5 % mangitude
  for i=1:31 % location  
    load(['location_' num2str(j) '_' num2str(i) '.mat'])
    DET_time(i,:)=TD(1,1:5);
  end 
  Sce3(j,:);
  results(j).det=DET_time; 
end

save results_new.mat

load results_new.mat
clear TH R
for i=1:5 % zones
    for j=1:31 % locations
        if Sce3(j,i)==2.0
            TH(j,i)=0;
        else
            TH(j,i)=1;
        end
        for zz=1:5 % magnitudes
            if results(zz).det(j,i)==2.0
                R(zz).value(j,i)=0;
            else
                R(zz).value(j,i)=1;
            end
        end
    end
end
clear R.decision
for j=1:5% magnitude
    for i=1:31 % location
        for zz=1:5 %zone
            
            if R(j).value(i,zz)==TH(i,zz)
                R(j).decision(i,zz)=1;
            else
                R(j).decision(i,zz)=0;
            end
            if R(j).value(i,zz)==0 && TH(i,zz)==0
                R(j).class{i,zz}='TN';
            elseif R(j).value(i,zz)==1 && TH(i,zz)==0
                R(j).class{i,zz}='FP';
            elseif R(j).value(i,zz)==0 && TH(i,zz)==1
                R(j).class{i,zz}='FN';
            else
                R(j).class{i,zz}='TP';
            end
        end
    end
end

% Diangosis set of each agent
M=zeros(5,5);
M(1,:)=[1 1 1 0 0];
M(2,:)=[1 1 1 0 1];
M(3,:)=[1 1 1 1 1];
M(4,:)=[0 0 1 1 1];
M(5,:)=[0 1 1 1 1];

for j=1:5% magnitude
    V(j).false_alarms=zeros(31,5);
    for i=1:31 % location
        
        for z=1:5        
            a=find(M(z,:)==1);
            b=find(M(z,:)==0);
            if ~isempty(b)
                
                for k=1:length(b)
                    if R(j).value(i,b(k))==1
                        for c=1:length(a)
                            if R(j).value(i,a(c))==1
                                V(j).false_alarms(i,z) =1; % V(j).false_alarms(i,z) +1;
                            end
                        end
                    end
                end
            end
            clear a b
        end
    end
end

%\mathcal{M}^{(1)}=\{\mathcal{E}^{(1)}, \mathcal{E}^{(2)}, \mathcal{E}^{(3)}\}
%\mathcal{M}^{(2)}=\{\mathcal{E}^{(1)}, \mathcal{E}^{(2)}, \mathcal{E}^{(3)}, \mathcal{E}^{(5)}\}
%\mathcal{M}^{(3)}=\{\mathcal{E}^{(1)}, \mathcal{E}^{(2)}, \mathcal{E}^{(3)}, \mathcal{E}^{(4)}, \mathcal{E}^{(5)}\}
%\mathcal{M}^{(4)}=\{\mathcal{E}^{(3)}, \mathcal{E}^{(4)}, \mathcal{E}^{(5)}\}
%\mathcal{M}^{(5)}=\{\mathcal{E}^{(2)}, \mathcal{E}^{(3)}, \mathcal{E}^{(4)}, \mathcal{E}^{(5)}\}

clear R.new R.newclass a
for j=1:31
    for i=1:5
       % R(j).new(i,:)=R(i).decision(j,:);
        for zz=1:5
            a=R(i).class{j,zz};
            R(j).newclass{i,zz}={a};
            if ismember(R(j).newclass{i,zz},'TN')
                R(j).new(i,zz)=1;
            elseif ismember(R(j).newclass{i,zz},'FP')
                R(j).new(i,zz)=2;
            elseif ismember(R(j).newclass{i,zz},'FN')
                R(j).new(i,zz)=3;
            else % TP
                R(j).new(i,zz)=4;
            end
        end
    end
end



% R(j).new(i,:)  j #of scenarios  i # magnitudes
% R(i).numTN   i #of magnitude

clear numTN numFP numFN numTP
    for j=1:31 % number of scenarios
        for i=1:5 % magnitudes       
        numTN_sce(j,i) = sum(R(j).new(i,:)==1);
        numFP_sce(j,i) = sum(R(j).new(i,:)==2);
        numFN_sce(j,i) = sum(R(j).new(i,:)==3);
        numTP_sce(j,i) = sum(R(j).new(i,:)==4);
        end
    end
    for i=1:5
        sum_sceTN(i) = sum(numTN_sce(:,i));
        sum_sceFP(i) = sum(numFP_sce(:,i));
        sum_sceFN(i) = sum(numFN_sce(:,i));
        sum_sceTP(i) = sum(numTP_sce(:,i));
    end
    
  numberofclasses_sce=[sum_sceTN' sum_sceFP' sum_sceFN' sum_sceTP']
    
    
    for j=1:31 % number of scenarios
        for i=1:5 % magnitudes 
        numTN_zone(j,i) = sum(R(j).new(:,i)==1);
        numFP_zone(j,i) = sum(R(j).new(:,i)==2);
        numFN_zone(j,i) = sum(R(j).new(:,i)==3);
        numTP_zone(j,i) = sum(R(j).new(:,i)==4);
        end
    end
    for i=1:5    
        sum_zoneTN(i) = sum(numTN_zone(:,i));
        sum_zoneFP(i) = sum(numFP_zone(:,i));
        sum_zoneFN(i) = sum(numFN_zone(:,i));
        sum_zoneTP(i) = sum(numTP_zone(:,i));
    end
    
    %percofclasses
    numberofclasses_zone=[sum_zoneTN; sum_zoneFP; sum_zoneFN; sum_zoneTP]
    
clear i; close all
for i=1:5
    figure(i)
    fH = gcf; colormap(jet(4));
    %bar3h(R(i).new)%,'stacked')
    %boxplot(R(i).new)
    bar(R(i).new,'FaceAlpha',0.6)
    title(['Scenario f=[' num2str(TH(i,:)) ']'])
    legend('zone 1', 'zone 2', 'zone 3', 'zone 4', 'zone 5')
    xticklabels({'2%','4%','8%','16%','32%'})
    yticklabels({'','','TN','','FP','','FN','','TP'})
    ylabel('Classfication Result')
    xlabel('Sensor Fault Magnitude')
    %applyhatch_plusC
    %applyhatch_plusC(fH, '|-.+\', 'rbmkg');
    %applyhatch(gcf,'|-.+\')%,1,[1 1 0 1 0 ],cool(5),200,3,2);
    
    hold on
%     plot(1,.5,'*')
%     plot(1,1.5,'o')


end



