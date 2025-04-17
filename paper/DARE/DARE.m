close all
clear all
clc

% Dependencies

pathCVODE = 'FIX ME';
pathAtmos = './StandardAtm';
pathFunc = './Functions';

addpath(pathAtmos)
addpath(pathCVODE)
addpath(pathFunc)

%% Global parameters

global Ru gamma phi_stoch

Ru = 8.314; % universal gas constant [kJ/mol-K]
gamma = 1.4;
phi_stoch = 0.0283; % the stoichiometric ratio of the hydrogen fuel in the combustion with air


%% Flight conditions

% Cruise conditions

flightComb(1) = 6; % Flight Mach number
flightComb(2) = 25; % Altitude [km]

% Atmospheric coditions 

[T_Inf,P_Inf,rho_Inf] = atmos(flightComb(2));

atmCond{1}(1)=T_Inf;
atmCond{1}(2)=P_Inf;
atmCond{1}(3)=rho_Inf;

% Air composition

atmCond{2}(1)=0.21; % O2 concentration
atmCond{2}(2)=0.79; % N2 concentration

%% Engine design conditons

% Intake design conditions

inCond{1} = 2; % Inlet exit Mach number
inCond{2} = 6; % Inlet truncation angle
inCond{3} = 4; % Inlet exit area

% Engine operation mode

global engineMode 

engineMode = 'SCRAM'; % RAM and SCRAM

% Combustion design conditions

combCond{1} = 6; % combustor length [m]
combCond{2} = 4; % combustor inlet area [m^2]
combCond{3} = 'circular'; % Combustor shape
combCond{4} = './Dependencies/area_duct_profile.mat'; % Combustor duct profile
combCond{5} = 0.2; % Equivalence Ratio [-]
combCond{6} = './Dependencies/MW_H2_Air.mat'; % Path to the molecular weight matrix

% Nozzle expansion ratio

nozzCond{1} = 20; % Nozzle Length [m]
nozzCond{2} = 0.5; % Must be higher than 30% (NER=0.3) according to Summerfield (Fernandez et al., 2013)
nozzCond{3} = './Dependencies/area_duct_profile.mat'; % Nozzle duct profile
nozzCond{4} = 15; % Nozzle divergence angle (for conical nozzles and must be defined for perfect expansion selection)

%% Engine design and analysis
% Intake Module 

[inOut] = intakeModule(inCond,flightComb,atmCond);

% Isolator Module

[isoOut] = isolatorModule(inOut);

% Combustor Module

[combOut] = combustorModule(isoOut,combCond,atmCond);

% Nozzle Module

[nozzOut] = nozzleModule(combOut,nozzCond,combCond,atmCond);


%% Performance Parameters

% Estimate performance parameters

perfModule(nozzOut,nozzCond,combCond,flightComb,atmCond)
    
