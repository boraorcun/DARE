function [combOut] = combustorModule(combIn,combCond,atmCond)

global Ru phi_stoch engineMode MW area_gradient Comb_Cross_Section_Geometry Comb_Area Comb_Length Cf

%% SCRAMJET/RAMJET COMBUSTOR AND NOZZLE MODULES MAIN PAGE

% Environmental conditions
O2_Mass_Concentration = atmCond{2}(1); % oxygen gas concentration in the air
N2_Mass_Concentration = atmCond{2}(2); % nitrojen gas concentration in the air

% DESIGN AND OPERATING CONDITIONS
Comb_Length = combCond{1}; % combustor length [m]
Comb_Area = combCond{2}; % combustor inlet area [m^2]
Comb_Cross_Section_Geometry = combCond{3};
ER = combCond{5}; % equilivalence ratio for the injected fuel
load(combCond{4}); % please upload area profile along with x-axis of the duct under investigation
Cf = 0.002;
area_gradient = zeros;
[row, ~] = size(area_profile_comb_nozzle);
for m=2:1:row
    area_gradient(m,1) = area_profile_comb_nozzle(m,1);
    area_gradient(m,2) = area_profile_comb_nozzle(m,2) - area_profile_comb_nozzle(m-1,2);
end

% CALLING THE CVODE SOLVER
startup_STB;

% MOLECULAR WEIGHT OF THE SPECIES
load(combCond{6}) % Load the molecular weight matrix

% PRE-COMBUSTION FLOW CONDITIONS
H2_Initial_Mass_Fraction = ER * phi_stoch; % initial mass fraction of the hydrogen fuel flow
N2_Initial_Mass_Fraction = (1 - H2_Initial_Mass_Fraction) * N2_Mass_Concentration; % initial mass fraction of the nitrogen
O2_Initial_Mass_Fraction = 1 - N2_Initial_Mass_Fraction - H2_Initial_Mass_Fraction; % initial mass fraction of the oxygen
MW_Comb_Inlet = MW(1) * O2_Initial_Mass_Fraction + MW(2) * N2_Initial_Mass_Fraction + MW(3) * H2_Initial_Mass_Fraction; % molecular weight of the fuel-air mixture in the pre-combustion flow conditions
Rgas = Ru / MW_Comb_Inlet; % gas constant for the specific gas [kJ/kg-K]
Cp_O2 = specific_heat_calculation_fun(combIn{3},'O2',Ru,MW(1)); % specific heat of O2 [kJ/kg-K]
Cp_N2 = specific_heat_calculation_fun(combIn{3},'N2',Ru,MW(2)); % specific heat of H2 [kJ/kg-K]
Cp_H2 = specific_heat_calculation_fun(combIn{3},'H2',Ru,MW(3)); % specific heat of N2 [kJ/kg-K]
Cp_Comb_Inlet = Cp_O2 * O2_Initial_Mass_Fraction + Cp_N2 * N2_Initial_Mass_Fraction + Cp_H2 * H2_Initial_Mass_Fraction;
Cv_Comb_Inlet = Cp_Comb_Inlet - Rgas;
Gamma_Comb_Inlet = Cp_Comb_Inlet / Cv_Comb_Inlet;
Speed_of_Sound = sqrt(Gamma_Comb_Inlet * Rgas * combIn{3}); % speed of sound of the fuel-air mixture at the combustor inlet
Velocity = Speed_of_Sound * combIn{1}; % combustor inlet velocity [m/s]
Density = combIn{2} / combIn{3} / Rgas; % density of the fuel-air mixture [kg/m^3]
Mass_Flow_Rate = Velocity * Density * Comb_Area; % combustor inlet mass flow rate [kg/s]
%% DEFINING INITIAL CONDITIONS FOR THE NUMERICAL SOLUTION
x0 = 0; % initial condition for the numerical solution
y0 = [Density; Velocity; combIn{2}; combIn{3}; MW_Comb_Inlet; O2_Initial_Mass_Fraction; N2_Initial_Mass_Fraction; H2_Initial_Mass_Fraction; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; Comb_Area; Mass_Flow_Rate]; % initial conditions for the numerical solution

%% SETING UP THE RECORDING
if strcmp( engineMode, 'RAM' )
    fid = fopen('Ramjet_Combustor_Nozzle_Modules_Solution.txt', 'w'); % creating a file for recoding the solution
    fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Iteration', 'Mach', 'Pressure [Pa]', 'Velocity [m/s]', 'Temperature [K]', 'Density [kg/m^3]', 'Speed of Sound [m/s]', 'Y_O2', 'Y_N2', 'Y_H2', 'Y_OH', 'Y_O', 'Y_H', 'Y_H2O', 'Y_NO', 'Y_N', 'Y_HO2', 'Y_H2O2', 'Y_HNO', 'Y_NO2', 'Mass flow rate [kg/s]', 'Area [m^2]', 'Axial location'); % setting up the header
    fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', 0, combIn{1}, combIn{2}, Velocity, combIn{3}, Density, Speed_of_Sound, O2_Initial_Mass_Fraction, N2_Initial_Mass_Fraction, H2_Initial_Mass_Fraction, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Mass_Flow_Rate, Comb_Area, 0); % saving the first initial values to the file
    fclose(fid); % closing the created recording file
elseif strcmp( engineMode, 'SCRAM' )
    fid = fopen('Scramjet_Combustor_Nozzle_Modules_Solution.txt', 'w'); % creating a file for recoding the solution
    fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Iteration', 'Mach', 'Pressure [Pa]', 'Velocity [m/s]', 'Temperature [K]', 'Density [kg/m^3]', 'Speed of Sound [m/s]', 'Y_O2', 'Y_N2', 'Y_H2', 'Y_OH', 'Y_O', 'Y_H', 'Y_H2O', 'Y_NO', 'Y_N', 'Y_HO2', 'Y_H2O2', 'Y_HNO', 'Y_NO2', 'Mass flow rate [kg/s]', 'Area [m^2]', 'Axial location'); % setting up the header
    fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', 0, combIn{1}, combIn{2}, Velocity, combIn{3}, Density, Speed_of_Sound, O2_Initial_Mass_Fraction, N2_Initial_Mass_Fraction, H2_Initial_Mass_Fraction, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Mass_Flow_Rate, Comb_Area, 0); % saving the first initial values to the file
    fclose(fid); % closing the created recording file
end
%% NUMERICAL SETUP
global module i reaction_key hydrogen_mfr h2_production_check h2_production_counter Mach_Mixture;
i = 0; % index of each numerical step
reaction_key = 1; % enabling the reactions
module = 'combustor'; % first solution will be done in combustor
hydrogen_mfr = 0; % previous h2 mass fraction
h2_production_check = 0;  % numerical step counting for saving the previous hydrogen mass flow rate
h2_production_counter = 0; % number of numerical steps where h2 is re-produced during the solution
Mach_Mixture = 10;
save numerical_setup.mat i reaction_key;
options = CVodeSetOptions('RelTol',1.e-6,... % setting for the relative tolerance
    'AbsTol',[1.e-6; 1.e-6; 1.e-6; 1.e-6; 1.e-6; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-6; 1.e-4],... % setting for the absolute tolerance
    'LinearSolver','Dense'); % setting for the solver type
options = CVodeSetOptions(options,'ErrorMessages',false); % finalizing the setting up the solver

%% NUMERICAL SOLUTION
iout = 0; % number of iteration
imax = 120000000; % maximum iteration number
xout = 0.4;

if strcmp( engineMode, 'RAM' )
    CVodeInit(@combustorNozzleSolver, 'BDF', 'Newton', x0, y0, options); % initializing the CVODE solver for the solution of ramjet combustor and nozzle modules

    while iout < imax
        [status,x,y] = CVode(xout,'OneStep'); % running the numerical solution for the function of ramjet_combustor_nozzle which is defined above
        if Mach_Mixture >= 0.99 && x > Comb_Length - 1 && x < Comb_Length + 1
            nozzle_key = true;
            fprintf('Final solution = Density=%14.6e [kg/m^3], Velocity=%14.6e [m/s], Pressure=%14.6e [Pa], Temperature=%14.6e [K], MolecularWeight=%14.6e [mol/kg], Oxygen_mfr=%14.6e, Nitrogen_mfr=%14.6e, Hydrogen_mfr=%14.6e, OH_mfr=%14.6e, O_mfr=%14.6e, H_mfr=%14.6e, H2O_mfr=%14.6e, HO2_mfr=%14.6e, H2O2_mfr=%14.6e, N_mfr=%14.6e, NO_mfr=%14.6e, HNO_mfr=%14.6e, NO2_mfr=%14.6e, Area=%14.6e [m^2], m=%14.6e [kg/s]]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters at the end of the numerical solutioN
            fprintf("Your solution for the combustor component is over. Sonic conditions are reached near the throat. The solution of the nozzle will be performed.\n");
            fprintf("WARNING: The sonic conditions are reached at x = %6.2d\n", x);
            break;
        end
        if Mach_Mixture < 0
            nozzle_key = false;
            fprintf("An error occured in the solution. Please update the input and/or design conditions.");
            break;
        end
        if Mach_Mixture >= 0.99 && Comb_Length - 1 > x
            nozzle_key = false;
            fprintf("The injected amount of fuel is too much. Please reduce the equilivalence ratio for the same flight and inlet conditions.");
            break;
        elseif Mach_Mixture < 0.99 && x > Comb_Length + 1
            nozzle_key = false;
            fprintf("The injected amount of fuel is insufficient. Please increase slightly the equilivalence ratio for the same flight and inlet conditions for reaching sonic conditions at the throat of the combustor.");
            break;
        end
        statistics_cvode = CVodeGetStats; % extracting the statistics of the solution
        fprintf('x = %0.2e   order = %1d  numerical step = %0.2e',x, statistics_cvode.qlast, statistics_cvode.hlast);
        if(status == 2)
            fprintf(' ... Root found  %d   %d\n',si.RootInfo.roots(1), si.RootInfo.roots(2));
        else
            fprintf('\n');
        end
        fprintf('solution = [ %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e %14.6e %14.6e]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters in the numerical solution
        if(status == 0)
            iout = iout+1; % increasing the number of iteration
        end
        xout = Comb_Length;
    end
elseif strcmp( engineMode, 'SCRAM' )
    CVodeInit(@combustorNozzleSolver, 'BDF', 'Newton', x0, y0, options); % initializing the CVODE solver for the solution of scramjet combustor and nozzle modules

    while iout < imax
        [status,x,y] = CVode(xout,'OneStep'); % running the numerical solution for the function of scramjet_combustor_nozzle which is defined above
        if Mach_Mixture <= 1
            nozzle_key = false;
            fprintf("Local Mach number decreased to the unity in the scramjet engine duct. Please reduce the injected amount of fuel or update the design parameters given above.")
            break;
        end
        if x > Comb_Length
            nozzle_key = true;
            fprintf('Final solution = Density=%14.6e [kg/m^3], Velocity=%14.6e [m/s], Pressure=%14.6e [Pa], Temperature=%14.6e [K], MolecularWeight=%14.6e [mol/kg], Oxygen_mfr=%14.6e, Nitrogen_mfr=%14.6e, Hydrogen_mfr=%14.6e, OH_mfr=%14.6e, O_mfr=%14.6e, H_mfr=%14.6e, H2O_mfr=%14.6e, HO2_mfr=%14.6e, H2O2_mfr=%14.6e, N_mfr=%14.6e, NO_mfr=%14.6e, HNO_mfr=%14.6e, NO2_mfr=%14.6e, Area=%14.6e [m^2], m=%14.6e [kg/s]]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters at the end of the numerical solutioN
            fprintf("Your solution for the combustor component is over. The solution of the nozzle will be performed.")
            break;
        end
        statistics_cvode = CVodeGetStats; % extracting the statistics of the solution
        fprintf('x = %0.2e   order = %1d  numerical step = %0.2e',x, statistics_cvode.qlast, statistics_cvode.hlast);
        if(status == 2)
            fprintf(' ... Root found  %d   %d\n',si.RootInfo.roots(1), si.RootInfo.roots(2));
        else
            fprintf('\n');
        end
        fprintf('solution = [ %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e  %14.6e %14.6e %14.6e]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters in the numerical solution
        if(status == 0)
            iout = iout+1; % increasing the number of iteration
        end
        xout = Comb_Length;

        plot(x,y(4),'b .','MarkerSize',10)
        pause(1e-5)
    end
end

%% RECORD OUTPUT

combOut{1} = status;
combOut{2} = x;
combOut{3} = y;
combOut{4} = nozzle_key;

return