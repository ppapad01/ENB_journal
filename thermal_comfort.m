% clear all
% close all
% clc;
% 
% Ta=18:0.01:30;

function [PMV, PPD] = thermal_comfort(Ta)

W=0; % external work
p_a=1.62;
t_r=25; % mean radiant temperature
V=0.2; %0.1; % air velocity
M=63.8; % metavolic rate of typing (W/m^2) = 1.1 met
I_cl=0.35; % clothing level

E=0.001;
e=2.7182;

%%%%
if I_cl <= 0.5
    f_cl=1.0+0.2*I_cl;
else
    f_cl=1.05+0.1*I_cl;
end

R_cl= 0.155*I_cl;
h_c= 12.1*(V)^(0.5);


t_cl= 35.7 -0.0275*(M-W)-R_cl.*((M-W)-3.05.*(5.73-0.007.*(M-W)-p_a)...
    -0.42.*((M-W)-58.15) -0.0173.*M.*(5.87-p_a) -0.0014.*M.*(34-Ta));


PMV =(0.303*e^(-0.036*M)+0.028)...
    *((M-W)-3.96*E^(8)*f_cl.*((t_cl+273).^(4)-(t_r+273).^(4))...
    -f_cl*h_c.*(t_cl-Ta)...
    -3.05*(5.73-0.007*(M-W)-p_a) -0.42*((M-W)-58.15)...
    -0.0173*M*(5.87-p_a) -0.0014.*M.*(34-Ta));

PPD =100-95*e.^(-(0.3353*(PMV).^(4)+0.2179*(PMV).^(2)));



 
end
