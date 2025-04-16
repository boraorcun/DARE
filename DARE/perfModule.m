function perfModule(nozzOut,nozzCond,combCond,flightComb,atmCond)

global phi_stoch Ru engineMode

% MOLECULAR WEIGHT OF THE SPECIES
load(combCond{6}) % Load the molecular weight matrix
Cp_O2 = specific_heat_calculation_fun(atmCond{1}(1),'O2',Ru,MW(1)); % specific heat of O2 [kJ/kg/K]
Cp_N2 = specific_heat_calculation_fun(atmCond{1}(1),'N2',Ru,MW(2)); % specific heat of H2 [kJ/kg/K]
Cp_Air = atmCond{2}(1) * Cp_O2 + atmCond{2}(2) * Cp_N2; % specific heat of the ambient air [kJ/kg/K]
MW_Ambient_Air = MW(1) * atmCond{2}(1) + MW(2) * atmCond{2}(2); % molecular weight of the ambient air [mol/kg]
Rgas = Ru / MW_Ambient_Air; % gas constant for the specific gas [kJ/kg-K]
Cv_Air = Cp_Air - Rgas;
Gamma_Ambient_Air = Cp_Air / Cv_Air;
Speed_of_Sound = sqrt(Gamma_Ambient_Air * Rgas * atmCond{1}(1)); % speed of sound of the fuel-air mixture at the combustor inlet
Aircraft_Velocity = Speed_of_Sound * flightComb(1); % combustor inlet velocity [m/s]

%% PERFORMANCE CALCULATIONS
if nozzOut{2} >= combCond{1} + nozzCond{1} && nozzOut{1} == 1 
    Fuel_Consumption = nozzOut{3}(20) * phi_stoch * combCond{5}; % fuel consumption [kg/s]
    Uninstalled_Thrust = nozzOut{3}(19) * (nozzOut{3}(3) - atmCond{1}(2)) + nozzOut{3}(20) * nozzOut{3}(2) - (nozzOut{3}(20) - Fuel_Consumption) * Aircraft_Velocity; % Thrust calculation
    Specific_Impulse = Uninstalled_Thrust / Fuel_Consumption / 9.81; %Specific impulse [m/s]
    Specific_Thrust = Uninstalled_Thrust / (nozzOut{3}(20) - Fuel_Consumption) / 9.81; %Specific thrust  
    Air_Mass_Flow_Rate = nozzOut{3}(20) - Fuel_Consumption; % Air mass flow rate intaken into the engine duct [kg/s]
    H2_Heat_of_Combustion = 141584000; % heat of combustion of hydrogen burning with the air [W] 
    Thermal_Efficiency = (nozzOut{3}(20) * nozzOut{3}(2) * nozzOut{3}(2) - Air_Mass_Flow_Rate * Aircraft_Velocity * Aircraft_Velocity)/(2 * Fuel_Consumption * H2_Heat_of_Combustion); % thermal efficiency of the propulsion system
    Propulsion_Efficiency = (2 * Uninstalled_Thrust * Aircraft_Velocity)/(nozzOut{3}(20) * nozzOut{3}(2) * nozzOut{3}(2) - Air_Mass_Flow_Rate * Aircraft_Velocity * Aircraft_Velocity); % propulsion effiency of the propulsion system
    Overall_Efficiency = Thermal_Efficiency * Propulsion_Efficiency;
elseif nozzOut{1} == 2 
    Fuel_Consumption = nozzOut{3}(20) * phi_stoch * combCond{5}; % fuel consumption [kg/s]
    Uninstalled_Thrust = nozzOut{7} * (nozzOut{4} - atmCond{1}(2)) + nozzOut{3}(20) * nozzOut{3}(2) - (nozzOut{3}(20) - Fuel_Consumption) * Aircraft_Velocity; % Thrust calculation
    Specific_Impulse = Uninstalled_Thrust / Fuel_Consumption / 9.81; % Specific impulse [s]
    Specific_Thrust = Uninstalled_Thrust / (nozzOut{3}(20) - Fuel_Consumption) / 9.81; %S pecific thrust [s]
    Air_Mass_Flow_Rate = nozzOut{3}(20) - Fuel_Consumption; % Air mass flow rate intaken into the engine duct [kg/s]
    H2_Heat_of_Combustion = 141584000; % heat of combustion of hydrogen burning with the air [W] 
    Thermal_Efficiency = (nozzOut{3}(20) * nozzOut{3}(2) * nozzOut{3}(2) - Air_Mass_Flow_Rate * Aircraft_Velocity * Aircraft_Velocity)/(2 * Fuel_Consumption * H2_Heat_of_Combustion); % thermal efficiency of the propulsion system
    Propulsion_Efficiency = (2 * Uninstalled_Thrust * Aircraft_Velocity)/(nozzOut{3}(20) * nozzOut{3}(2) * nozzOut{3}(2) - Air_Mass_Flow_Rate * Aircraft_Velocity * Aircraft_Velocity); % propulsion effiency of the propulsion system
    Overall_Efficiency = Thermal_Efficiency * Propulsion_Efficiency;
end

    if strcmp(engineMode, 'RAM')
        name = 'Performance_Results_for_Ramjet_Engine.txt';
    else
        name = 'Performance_Results_for_Scramjet_Engine.txt';
    end
    fid = fopen(name, 'w'); % creating a file for recoding the performance analysis results
    fprintf(fid,'%s %d\n','Uninstalled Thrust [N]:',Uninstalled_Thrust);
    fprintf(fid,'%s %d\n','Fuel consumption [kg/s]:',Fuel_Consumption);
    fprintf(fid,'%s %d\n','ISP [s]:',Specific_Impulse);
    fprintf(fid,'%s %d\n','TSP [s]:',Specific_Thrust);
    fprintf(fid,'%s %d\n','Air mass flow rate [kg/s]:',Air_Mass_Flow_Rate);
    fprintf(fid,'%s %d\n','Thermal efficiency:',Thermal_Efficiency);
    fprintf(fid,'%s %d\n','Propulsion efficiency:',Propulsion_Efficiency);
    fprintf(fid,'%s %d\n','Overall efficiency:',Overall_Efficiency);
    try
        fprintf(fid,'%s %d\n','Nozzle exit pressure [Pa]:',nozzOut{4});
        fprintf(fid,'%s %d\n','Nozzle exit area [m^2]:',nozzOut{7});
        fprintf(fid,'%s %d\n','Nozzle length [m]:',nozzOut{8});
    end
    fclose(fid);

return