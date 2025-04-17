function [dYdx, delete1, delete2] = combustorNozzleSolver(x,Y)
Ru = 8.314; % universal gas constant [kJ/mol/K]
dmdx = 0; % no mass addition is assumed for this problem
h0_added = 0; % since there is no mass addition, enthalpy of any added mass is zero
q_wall = 0; % the duct wall is assummed to be adiabatic
global module i reaction_key MW Mach_Mixture engineMode Comb_Length Comb_Area Comb_Cross_Section_Geometry area_gradient Cf;
delete1=0;
delete2=0;
%% THERMOPHYSICAL PROPERTIES OF THE SPECIES CALCULATION
[s, h, Cp] = thermophysical_properties_calculation_fun(Y, MW); % entropy, enthalpy, and specific heat matrixes of the species
%% CALCULATIONS FOR DUCT GEOMETRY
[Dh, Per_wall, dAdx] = geometric_calculation_fun(x,Comb_Cross_Section_Geometry,Comb_Length,Comb_Area,area_gradient);
%% SPECIES EQUATIONS
[omega, reaction_key] = reaction_rates_calculation_fun(reaction_key, Comb_Length, Y, x, MW, s, h);
dY_O2dx = omega(1) * MW(1) * Y(19) / Y(20); % derivative of the O2 mass fraction
dY_N2dx = omega(2) * MW(2) * Y(19) / Y(20); % derivative of the N2 mass fraction
dY_H2dx = omega(3) * MW(3) * Y(19) / Y(20); % derivative of the H2 mass fraction
dY_OHdx = omega(4) * MW(4) * Y(19) / Y(20); % derivative of the OH mass fraction
dY_Odx = omega(5) * MW(5) * Y(19) / Y(20); % derivative of the O mass fraction
dY_Hdx = omega(6) * MW(6) * Y(19) / Y(20); % derivative of the H mass fraction
dY_H2Odx = omega(7) * MW(7) * Y(19) / Y(20); % derivative of the H2O mass fraction
dY_HO2dx = omega(8) * MW(8) * Y(19) / Y(20); % derivative of the HO2 mass fraction
dY_H2O2dx = omega(9) * MW(9) * Y(19) / Y(20); % derivative of the H2O2 mass fraction
dY_Ndx = omega(10) * MW(10) * Y(19) / Y(20); % derivative of the N mass fraction
dY_NOdx = omega(11) * MW(11) * Y(19) / Y(20); % derivative of the NO mass fraction
dY_HNOdx = omega(12) * MW(12) * Y(19) / Y(20); % derivative of the HNO mass fraction
dY_NO2dx = omega(13) * MW(13) * Y(19) / Y(20); % derivative of the NO2 mass fraction
%% THERMOPHYSICAL PROPERTIES OF THE MIXTURE CALCULATION
h_mixture_derivative = h(1) * dY_O2dx + h(2) * dY_N2dx + h(3) * dY_H2dx + h(4) * dY_OHdx + h(5) * dY_Odx + h(6) * dY_Hdx + h(7) * dY_H2Odx + h(8) * dY_HO2dx + h(9) * dY_H2O2dx + h(10) * dY_Ndx + h(11) * dY_NOdx + h(12) * dY_HNOdx + h(13) * dY_NO2dx;
h_mixture = h(1) * Y(6) + h(2) * Y(7) + h(3) * Y(8) + h(4) * Y(9) + h(5) * Y(10) + h(6) * Y(11) + h(7) * Y(12) + h(8) * Y(13) + h(9) * Y(14) + h(10) * Y(15) + h(11) * Y(16) + h(12) * Y(17) + h(13) * Y(18);
Cp_mixture = Cp(1) * Y(6) + Cp(2) * Y(7) + Cp(3) * Y(8) + Cp(4) * Y(9) + Cp(5) * Y(10) + Cp(6) * Y(11) + Cp(7) * Y(12) + Cp(8) * Y(13) + Cp(9) * Y(14) + Cp(10) * Y(15) + Cp(11) * Y(16) + Cp(12) * Y(17) + Cp(13) * Y(18);
Rgas = Ru / Y(5); % universal gas constant of the mixture [kJ/kg/K]
Cv_mixture = Cp_mixture - Rgas; % specific heat (at the constant volume) of the mixture [kJ/kg/K]
Gamma_Mixture = Cp_mixture / Cv_mixture; % specific heat ratio
Speed_of_Sound = sqrt(Gamma_Mixture * Rgas * Y(4));
Mach_Mixture = Y(2) / Speed_of_Sound;
%% MOLECULAR WEIGHT OF THE MIXTURE EQUATION
dMWdx = - Y(5) * Y(5) * ((1/MW(1) * dY_O2dx) + (1/MW(2) * dY_N2dx) + (1/MW(3) * dY_H2dx) + (1/MW(4) * dY_OHdx) + (1/MW(5) * dY_Odx) + (1/MW(6) * dY_Hdx) + (1/MW(7) * dY_H2Odx) + (1/MW(8) * dY_HO2dx) + (1/MW(9) * dY_H2O2dx) + (1/MW(10) * dY_Ndx) + (1/MW(11) * dY_NOdx) + (1/MW(12) * dY_HNOdx) + (1/MW(13) * dY_NO2dx));
%% MAIN GOVERNING EQUATION SET
h_total = h_mixture + (Y(2) * Y(2) / 2); % total enthalpy
alpha = 1/Y(2) - (Y(2) * Y(5)/(Ru * Y(4))) + (Y(2)/(Y(4) * Cp_mixture));
dudx1 = (1 / Y(4) / Cp_mixture) * (-h_mixture_derivative);
dudx2 = (1 / Y(5)) * dMWdx;
dudx3 = (2 * Cf * Y(2) * Y(2) * Y(5))/(Ru * Y(4) * Dh);
dudx4 = (1/Y(19)) * dAdx;
dudx5 = ((1 - h_total / (Y(4) * Cp_mixture)) / Y(20)) * dmdx;
dudx6 = (q_wall * Per_wall)/(Y(4) * Cp_mixture * Y(20));
dudx7 = (h0_added * dmdx) / (Y(4) * Cp_mixture * Y(20));
dudx =  (1/alpha) * (dudx5 - dudx4 + dudx1 + dudx7 - dudx2 + dudx3 - dudx6); % derivative form of the velocity
drhodx1 = (1/Y(2)) * dudx;
drhodx2 = (1/Y(19)) * dAdx;
drhodx3 = (1/Y(20)) * dmdx;
drhodx = Y(1) * (drhodx3 - drhodx1 - drhodx2); % derivative form of the density
beta = Y(3) * Y(2) * Y(2) * Y(5) / (Ru * Y(4));
dpdx1 = (1 / Y(2)) * dudx;
dpdx2 = 2 * Cf / Dh;
dpdx = -beta * (dpdx1 + dpdx2); % derivative form of the pressure
dtdx1 = (1 / Y(3)) * dpdx;
dtdx2 = (1 / Y(1)) * drhodx;
dtdx3 = (1 / Y(5)) * dMWdx;
dtdx = Y(4) * (dtdx1 - dtdx2 + dtdx3); % derivative form of the temperature
%% RECORDING AND PRINTING THE SOLUTION

if strcmp( engineMode, 'SCRAM' )
    if dAdx < 0.0000001 && x < Comb_Length && strcmp(module, 'combustor') % adjustment for backward numerical solution
        i = i + 1; % index of each numerical step
        fid = fopen('Scramjet_Combustor_Nozzle_Modules_Solution.txt', 'at'); % creating a file for recoding the solution
        fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', i, Mach_Mixture, Y(3), Y(2), Y(4), Y(1), Speed_of_Sound, Y(6), Y(7), Y(8), Y(9), Y(10), Y(11), Y(12), Y(16), Y(15), Y(13), Y(14), Y(17), Y(18), Y(20), Y(19), x); % saving the first initial values to the file
        fclose(fid); % closing the created recording file
    elseif strcmp(module, 'nozzle')
        i = i + 1; % index of each numerical step
        fid = fopen('Scramjet_Combustor_Nozzle_Modules_Solution.txt', 'at'); % creating a file for recoding the solution
        fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', i, Mach_Mixture, Y(3), Y(2), Y(4), Y(1), Speed_of_Sound, Y(6), Y(7), Y(8), Y(9), Y(10), Y(11), Y(12), Y(16), Y(15), Y(13), Y(14), Y(17), Y(18), Y(20), Y(19), x); % saving the first initial values to the file
        fclose(fid); % closing the created recording file
    end

elseif strcmp( engineMode, 'RAM' )
    if dAdx < 0.0000001 && x < Comb_Length && strcmp(module, 'combustor') % adjustment for backward numerical solution
        i = i + 1; % index of each numerical step
        fid = fopen('Ramjet_Combustor_Nozzle_Modules_Solution.txt', 'at'); % creating a file for recoding the solution
        fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', i, Mach_Mixture, Y(3), Y(2), Y(4), Y(1), Speed_of_Sound, Y(6), Y(7), Y(8), Y(9), Y(10), Y(11), Y(12), Y(16), Y(15), Y(13), Y(14), Y(17), Y(18), Y(20), Y(19), x); % saving the first initial values to the file
        fclose(fid); % closing the created recording file
    elseif strcmp(module, 'nozzle')
        i = i + 1; % index of each numerical step
        fid = fopen('Ramjet_Combustor_Nozzle_Modules_Solution.txt', 'at'); % creating a file for recoding the solution
        fprintf(fid, '%d\t%.6f\t%.6e\t%.2f\t%.2f\t%.6e\t%.2f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n', i, Mach_Mixture, Y(3), Y(2), Y(4), Y(1), Speed_of_Sound, Y(6), Y(7), Y(8), Y(9), Y(10), Y(11), Y(12), Y(16), Y(15), Y(13), Y(14), Y(17), Y(18), Y(20), Y(19), x); % saving the first initial values to the file
        fclose(fid); % closing the created recording file
    end
end


%% OUTPUT
dYdx = [drhodx
    dudx
    dpdx
    dtdx
    dMWdx
    dY_O2dx
    dY_N2dx
    dY_H2dx
    dY_OHdx
    dY_Odx
    dY_Hdx
    dY_H2Odx
    dY_HO2dx
    dY_H2O2dx
    dY_Ndx
    dY_NOdx
    dY_HNOdx
    dY_NO2dx
    dAdx
    dmdx
    ];
end