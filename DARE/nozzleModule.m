function [nozzOut] = nozzleModule(combOut,nozzCond,combCond,atmCond)

global Ru engineMode

%% NOZZLE SETTINGS
Comb_Length = combCond{1}; % combustor length [m]
Comb_Area = combCond{2}; % combustor inlet area [m^2]
Nozzle_Length = nozzCond{1}; % nozzle length [m]
load(combCond{4}); % please upload area profile along with x-axis of the duct under investigation
load(nozzCond{3}); % please upload area profile along with x-axis of the duct under investigation
area_gradient = zeros;
[row, ~] = size(area_profile_comb_nozzle);
for m=2:1:row
    area_gradient(m,1) = area_profile_comb_nozzle(m,1);
    area_gradient(m,2) = area_profile_comb_nozzle(m,2) - area_profile_comb_nozzle(m-1,2);
end


nozzle_analysis_options = ["Expansion with the provided area profile", "Perfect expansion"];
choice = menu('Select an analysis option:', nozzle_analysis_options);
if choice == 1 && area_profile_comb_nozzle(end,1) < Comb_Length + nozzCond{2}
    error('The length info given in the area profile is not sufficient, please provide the area profile along with the full-lenght, update nozzle and combustor lengths, or select perfect expansion');
end
pressure_difference = input('Please enter the desired pressure difference (exit pressure - ambient pressure) in [%] for designing the nozzle: ');
if pressure_difference > 0
    fprintf('You entered a pressure difference of %.2f Pa. This is for underexpanded nozzle design\n', pressure_difference);
elseif pressure_difference < 0 && pressure_difference > -30
    fprintf('You entered a pressure difference of %.2f Pa. This is for overexpanded nozzle design\n', pressure_difference);
elseif pressure_difference < -30
    fprintf('For this overexpanded nozzle design, thrust production is not possible according to Sommerfield criterias');
end

%% CALLING THE CVODE SOLVER
% CALLING THE CVODE SOLVER
% addpath(pathCVODE);
startup_STB;

% MOLECULAR WEIGHT OF THE SPECIES
load(combCond{6}) % Load the molecular weight matrix

%% NUMERICAL SETUP

global module i reaction_key hydrogen_mfr h2_production_check h2_production_counter Mach_Mixture;
i = 0; % index of each numerical step
reaction_key = 1; % enabling the reactions
hydrogen_mfr = 0; % previous h2 mass fraction
h2_production_check = 0;  % numerical step counting for saving the previous hydrogen mass flow rate
h2_production_counter = 0; % number of numerical steps where h2 is re-produced during the solution
Mach_Mixture = 10;
nozzle_key = combOut{4};
options = CVodeSetOptions('RelTol',1.e-6,... % setting for the relative tolerance
    'AbsTol',[1.e-6; 1.e-6; 1.e-6; 1.e-6; 1.e-6; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-9; 1.e-6; 1.e-4],... % setting for the absolute tolerance
    'LinearSolver','Dense'); % setting for the solver type
options = CVodeSetOptions(options,'ErrorMessages',false); % finalizing the setting up the solver

%% NUMERICAL SOLUTION FOR NOZZLE
if strcmp( engineMode, 'RAM' )
    % NUMERICAL SOLUTION FOR RAMJET NOZZLE
    iout = 0; % number of iteration
    imax = 120000000; % maximum iteration number
    xout = 1 + Comb_Length;
    x = combOut{2}; x0 = Comb_Length;
    y = combOut{3}; y0 = y;
    module = 'nozzle';
    CVodeFree;
    y(2) = y(2) + 5; % ramjet solutions are valid only with ±5m/s velocity range at the throat of the combustor
    CVodeInit(@ramjet_combustor_nozzle, 'BDF', 'Newton', x0, y0, options); % initializing the CVODE solver for the solution of ramjet combustor and nozzle modules
    if choice == 1 && nozzle_key == true
        while iout < imax
            [status,x,y] = CVode(xout,'OneStep'); % running the numerical solution for the function of ramjet_combustor_nozzle which is defined above
            if Mach_Mixture <= 1
                performance_key = false;
                fprintf("Local Mach number decreased to the unity in the nozzle of the ramjet engine. Please reduce the injected amount of fuel or update the design parameters given above.")
                break;
            end
            if x > Nozzle_Length + Comb_Length
                performance_key = true;
                fprintf('Final solution = Density=%14.6e [kg/m^3], Velocity=%14.6e [m/s], Pressure=%14.6e [Pa], Temperature=%14.6e [K], MolecularWeight=%14.6e [mol/kg], Oxygen_mfr=%14.6e, Nitrogen_mfr=%14.6e, Hydrogen_mfr=%14.6e, OH_mfr=%14.6e, O_mfr=%14.6e, H_mfr=%14.6e, H2O_mfr=%14.6e, HO2_mfr=%14.6e, H2O2_mfr=%14.6e, N_mfr=%14.6e, NO_mfr=%14.6e, HNO_mfr=%14.6e, NO2_mfr=%14.6e, Area=%14.6e [m^2], m=%14.6e [kg/s]]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters at the end of the numerical solution
                fprintf("Your solution for the nozzle part is over. The system performance will be calculated.")
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
            xout = Nozzle_Length + Comb_Length;
        end
    elseif choice == 2 && nozzle_key == true
        Cp_O2 = specific_heat_calculation_fun(y(4),'O2',Ru,MW(1)); % specific heat of O2 [kJ/kg/K]
        Cp_N2 = specific_heat_calculation_fun(y(4),'N2',Ru,MW(2)); % specific heat of N2 [kJ/kg/K]
        Cp_H2 = specific_heat_calculation_fun(y(4),'H2',Ru,MW(3)); % specific heat of H2 [kJ/kg/K]
        Cp_OH = specific_heat_calculation_fun(y(4),'OH',Ru,MW(4)); % specific heat of OH [kJ/kg/K]
        Cp_O = specific_heat_calculation_fun(y(4),'O',Ru,MW(5)); % specific heat of O [kJ/kg/K]
        Cp_H = specific_heat_calculation_fun(y(4),'H',Ru,MW(6)); % specific heat of H [kJ/kg/K]
        Cp_H2O = specific_heat_calculation_fun(y(4),'H2O',Ru,MW(7)); % specific heat of H2O [kJ/kg/K]
        Cp_HO2 = specific_heat_calculation_fun(y(4),'HO2',Ru,MW(8)); % specific heat of HO2 [kJ/kg/K]
        Cp_H2O2 = specific_heat_calculation_fun(y(4),'H2O2',Ru,MW(9)); % specific heat of H2O2 [kJ/kg/K]
        Cp_N = specific_heat_calculation_fun(y(4),'N',Ru,MW(10)); % specific heat of N [kJ/kg/K]
        Cp_NO = specific_heat_calculation_fun(y(4),'NO',Ru,MW(11)); % specific heat of NO [kJ/kg/K]
        Cp_HNO = specific_heat_calculation_fun(y(4),'HNO',Ru,MW(12)); % specific heat of HNO [kJ/kg/K]
        Cp_NO2 = specific_heat_calculation_fun(y(4),'NO2',Ru,MW(13)); % specific heat of NO2 [kJ/kg/K]
        Cp_mixture = Cp_O2 * y(6) + Cp_N2 * y(7) + Cp_H2 * y(8) + Cp_OH * y(9) + Cp_O * y(10) + Cp_H * y(11) + Cp_H2O * y(12) + Cp_HO2 * y(13) + Cp_H2O2 * y(14) + Cp_N * y(15) + Cp_NO * y(16) + Cp_HNO * y(17) + Cp_NO2 * y(18);
        Rgas = Ru / y(5);
        Cv_mixture = Cp_mixture - Rgas;
        Gamma_Mixture = Cp_mixture / Cv_mixture;
        P0_Combustor_Exit = y(3) * (1+(Gamma_Mixture - 1)/2 * Mach_Mixture * Mach_Mixture)^((Gamma_Mixture - 1)/Gamma_Mixture);
        T0_Combustor_Exit = y(4) * (y(3) / P0_Combustor_Exit)^(Gamma_Mixture/(Gamma_Mixture - 1));
        P_Desired_Exit = atmCond{1}(2)  + atmCond{1}(2) * pressure_difference / 100;
        Mach_Nozzle_Exit = sqrt(((P_Desired_Exit / P0_Combustor_Exit)^(-(Gamma_Mixture - 1)/Gamma_Mixture) - 1) * (2/(Gamma_Mixture - 1)));
        T_Nozzle_Exit = T0_Combustor_Exit * (1 + (Gamma_Mixture - 1)/2 * Mach_Nozzle_Exit * Mach_Nozzle_Exit)^-1;
        Velocity_Nozzle_Exit = Mach_Nozzle_Exit * sqrt(Gamma_Mixture * Rgas * T_Nozzle_Exit);
        Area_Nozzle_Exit = Comb_Area * (1/Mach_Nozzle_Exit) * (2/(Gamma_Mixture + 1))^((Gamma_Mixture + 1)/(2*(Gamma_Mixture - 1))) * (1 + (Gamma_Mixture - 1)/2 * Mach_Nozzle_Exit * Mach_Nozzle_Exit)^((Gamma_Mixture + 1)/(2*(Gamma_Mixture - 1)));
        Combustor_Area_Diameter = sqrt(4 * Comb_Area / 3.14);
        Nozzle_Area_Diameter = sqrt(4 * Area_Nozzle_Exit / 3.14);
        Nozzle_Length = (Nozzle_Area_Diameter - Combustor_Area_Diameter) / 2 / tand(nozzCond{4});
        fprintf('Final solution: Exit Mach Number=%14.6e, Nozzle Exit Area=%14.6e [m^2], Nozzle Length=%14.6e [m]', Mach_Nozzle_Exit, Area_Nozzle_Exit, Nozzle_Length); % Calculated nozzle parameters for perfect expansion
        performance_key = true;
    end
elseif strcmp( engineMode, 'SCRAM' )
    % NUMERICAL SOLUTION FOR SCRAMJET NOZZLE
    iout = 0; % number of iteration
    imax = 120000000; % maximum iteration number
    xout = 0.4 + Nozzle_Length;
    x = combOut{2}; x0 = x;
    y = combOut{3}; y0 = y;
    module = 'nozzle';
    CVodeFree;
    CVodeInit(@scramjet_combustor_nozzle, 'BDF', 'Newton', x0, y0, options); % initializing the CVODE solver for the solution of scramjet combustor and nozzle modules
    if choice == 1 && nozzle_key == true
        while iout < imax
            [status,x,y] = CVode(xout,'OneStep'); % running the numerical solution for the function of scramjet_combustor_nozzle which is defined above
            if Mach_Mixture <= 1
                performance_key = false;
                fprintf("Local Mach number decreased to the unity in the scramjet engine duct. Please reduce the injected amount of fuel or update the design parameters given above.")
                break;
            end
            if x > Nozzle_Length + Comb_Length
                performance_key = true;
                fprintf('Final solution = Density=%14.6e [kg/m^3], Velocity=%14.6e [m/s], Pressure=%14.6e [Pa], Temperature=%14.6e [K], MolecularWeight=%14.6e [mol/kg], Oxygen_mfr=%14.6e, Nitrogen_mfr=%14.6e, Hydrogen_mfr=%14.6e, OH_mfr=%14.6e, O_mfr=%14.6e, H_mfr=%14.6e, H2O_mfr=%14.6e, HO2_mfr=%14.6e, H2O2_mfr=%14.6e, N_mfr=%14.6e, NO_mfr=%14.6e, HNO_mfr=%14.6e, NO2_mfr=%14.6e, Area=%14.6e [m^2], m=%14.6e [kg/s]]\n\n', y(1), y(2), y(3), y(4), y(5), y(6), y(7), y(8), y(9), y(10), y(11), y(12), y(13), y(14), y(15), y(16), y(17), y(18), y(19), y(20)); % Calculated parameters at the end of the numerical solution
                fprintf("Your solution for the nozzle part is over. The system performance will be calculated.")
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
            xout = Nozzle_Length + Comb_Length;
        end
    elseif choice == 2 && nozzle_key == true
        Cp_O2 = specific_heat_calculation_fun(y(4),'O2',Ru,MW(1)); % specific heat of O2 [kJ/kg/K]
        Cp_N2 = specific_heat_calculation_fun(y(4),'N2',Ru,MW(2)); % specific heat of N2 [kJ/kg/K]
        Cp_H2 = specific_heat_calculation_fun(y(4),'H2',Ru,MW(3)); % specific heat of H2 [kJ/kg/K]
        Cp_OH = specific_heat_calculation_fun(y(4),'OH',Ru,MW(4)); % specific heat of OH [kJ/kg/K]
        Cp_O = specific_heat_calculation_fun(y(4),'O',Ru,MW(5)); % specific heat of O [kJ/kg/K]
        Cp_H = specific_heat_calculation_fun(y(4),'H',Ru,MW(6)); % specific heat of H [kJ/kg/K]
        Cp_H2O = specific_heat_calculation_fun(y(4),'H2O',Ru,MW(7)); % specific heat of H2O [kJ/kg/K]
        Cp_HO2 = specific_heat_calculation_fun(y(4),'HO2',Ru,MW(8)); % specific heat of HO2 [kJ/kg/K]
        Cp_H2O2 = specific_heat_calculation_fun(y(4),'H2O2',Ru,MW(9)); % specific heat of H2O2 [kJ/kg/K]
        Cp_N = specific_heat_calculation_fun(y(4),'N',Ru,MW(10)); % specific heat of N [kJ/kg/K]
        Cp_NO = specific_heat_calculation_fun(y(4),'NO',Ru,MW(11)); % specific heat of NO [kJ/kg/K]
        Cp_HNO = specific_heat_calculation_fun(y(4),'HNO',Ru,MW(12)); % specific heat of HNO [kJ/kg/K]
        Cp_NO2 = specific_heat_calculation_fun(y(4),'NO2',Ru,MW(13)); % specific heat of NO2 [kJ/kg/K]
        Cp_mixture = Cp_O2 * y(6) + Cp_N2 * y(7) + Cp_H2 * y(8) + Cp_OH * y(9) + Cp_O * y(10) + Cp_H * y(11) + Cp_H2O * y(12) + Cp_HO2 * y(13) + Cp_H2O2 * y(14) + Cp_N * y(15) + Cp_NO * y(16) + Cp_HNO * y(17) + Cp_NO2 * y(18);
        Rgas = Ru / y(5);
        Cv_mixture = Cp_mixture - Rgas;
        Gamma_Mixture = Cp_mixture / Cv_mixture;
        P0_Combustor_Exit = y(3) * (1+(Gamma_Mixture - 1)/2 * Mach_Mixture * Mach_Mixture)^((Gamma_Mixture - 1)/Gamma_Mixture);
        T0_Combustor_Exit = y(4) * (y(3) / P0_Combustor_Exit)^(Gamma_Mixture/(Gamma_Mixture - 1));
        P_Desired_Exit = atmCond{1}(2)  + atmCond{1}(2) * pressure_difference / 100;
        Mach_Nozzle_Exit = sqrt(((P_Desired_Exit / P0_Combustor_Exit)^(-(Gamma_Mixture - 1)/Gamma_Mixture) - 1) * (2/(Gamma_Mixture - 1)));
        T_Nozzle_Exit = T0_Combustor_Exit * (1 + (Gamma_Mixture - 1)/2 * Mach_Nozzle_Exit * Mach_Nozzle_Exit)^-1;
        Velocity_Nozzle_Exit = Mach_Nozzle_Exit * sqrt(Gamma_Mixture * Rgas * T_Nozzle_Exit);
        Area_Nozzle_Exit = Comb_Area * (1/Mach_Nozzle_Exit) * (2/(Gamma_Mixture + 1))^((Gamma_Mixture + 1)/(2*(Gamma_Mixture - 1))) * (1 + (Gamma_Mixture - 1)/2 * Mach_Nozzle_Exit * Mach_Nozzle_Exit)^((Gamma_Mixture + 1)/(2*(Gamma_Mixture - 1)));
        Combustor_Area_Diameter = sqrt(4 * Comb_Area / 3.14);
        Nozzle_Area_Diameter = sqrt(4 * Area_Nozzle_Exit / 3.14);
        Nozzle_Length = (Nozzle_Area_Diameter - Combustor_Area_Diameter) / 2 / tand(nozzCond{4});
        fprintf('Final solution: Exit Mach Number=%14.6e, Nozzle Exit Area=%14.6e [m^2], Nozzle Length=%14.6e [m]', Mach_Nozzle_Exit, Area_Nozzle_Exit, Nozzle_Length); % Calculated nozzle parameters for perfect expansion
    end
end
%% Record output

nozzOut{1} = choice;
nozzOut{2} = x;
nozzOut{3} = y;
nozzOut{4} = P_Desired_Exit;
nozzOut{5} = T_Nozzle_Exit;
nozzOut{6} = Velocity_Nozzle_Exit;
nozzOut{7} = Area_Nozzle_Exit;

return