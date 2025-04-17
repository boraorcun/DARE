function[s,h,Cp] = thermophysical_properties_calculation_fun(Y, MW)
    Ru = 8.314; % universal gas constant [kJ/mol/K]    
    %% ENTROPY CALCULATION
    S_O2 = entropy_calculation_fun(Y(4),'O2',Ru,MW(1)); % specific entropy of O2
    S_N2 = entropy_calculation_fun(Y(4),'N2',Ru,MW(2)); % specific entropy of N2
    S_H2 = entropy_calculation_fun(Y(4),'H2',Ru,MW(3)); % specific entropy of H2
    S_OH = entropy_calculation_fun(Y(4),'OH',Ru,MW(4)); % specific entropy of OH
    S_O = entropy_calculation_fun(Y(4),'O',Ru,MW(5)); % specific entropy of O
    S_H = entropy_calculation_fun(Y(4),'H',Ru,MW(6)); % specific entropy of H
    S_H2O = entropy_calculation_fun(Y(4),'H2O',Ru,MW(7)); % specific entropy of H2O
    S_HO2 = entropy_calculation_fun(Y(4),'HO2',Ru,MW(8)); % specific entropy of HO2
    S_H2O2 = entropy_calculation_fun(Y(4),'H2O2',Ru,MW(9)); % specific entropy of H2O2
    S_N = entropy_calculation_fun(Y(4),'N',Ru,MW(10)); % specific entropy of N
    S_NO = entropy_calculation_fun(Y(4),'NO',Ru,MW(11)); % specific entropy of NO
    S_HNO = entropy_calculation_fun(Y(4),'HNO',Ru,MW(12)); % specific entropy of HNO
    S_NO2 = entropy_calculation_fun(Y(4),'NO2',Ru,MW(13)); % specific entropy of NO2

    %% ENTHALPY OF FORMATION CALCULATION
    h_O2 = enthalpy_calculation_fun(Y(4),'O2',Ru,MW(1)); % enthalpy of O2
    h_N2 = enthalpy_calculation_fun(Y(4),'N2',Ru,MW(2)); % enthalpy of N2
    h_H2 = enthalpy_calculation_fun(Y(4),'H2',Ru,MW(3)); % enthalpy of H2
    h_OH = enthalpy_calculation_fun(Y(4),'OH',Ru,MW(4)); % enthalpy of OH
    h_O = enthalpy_calculation_fun(Y(4),'O',Ru,MW(5)); % enthalpy of O
    h_H = enthalpy_calculation_fun(Y(4),'H',Ru,MW(6)); % enthalpy of H
    h_H2O = enthalpy_calculation_fun(Y(4),'H2O',Ru,MW(7)); % enthalpy of H2O
    h_HO2 = enthalpy_calculation_fun(Y(4),'HO2',Ru,MW(8)); % enthalpy of HO2
    h_H2O2 = enthalpy_calculation_fun(Y(4),'H2O2',Ru,MW(9)); % enthalpy of H2O2
    h_N = enthalpy_calculation_fun(Y(4),'N',Ru,MW(10)); % enthalpy of N
    h_NO = enthalpy_calculation_fun(Y(4),'NO',Ru,MW(11)); % enthalpy of NO
    h_HNO = enthalpy_calculation_fun(Y(4),'HNO',Ru,MW(12)); % enthalpy of HNO
    h_NO2 = enthalpy_calculation_fun(Y(4),'NO2',Ru,MW(13)); % enthalpy of NO2

    %% SPECIFIC HEAT CALCULATION
    Cp_O2 = specific_heat_calculation_fun(Y(4),'O2',Ru,MW(1)); % specific heat of O2 [kJ/kg/K]
    Cp_N2 = specific_heat_calculation_fun(Y(4),'N2',Ru,MW(2)); % specific heat of N2 [kJ/kg/K]
    Cp_H2 = specific_heat_calculation_fun(Y(4),'H2',Ru,MW(3)); % specific heat of H2 [kJ/kg/K]
    Cp_OH = specific_heat_calculation_fun(Y(4),'OH',Ru,MW(4)); % specific heat of OH [kJ/kg/K]
    Cp_O = specific_heat_calculation_fun(Y(4),'O',Ru,MW(5)); % specific heat of O [kJ/kg/K]
    Cp_H = specific_heat_calculation_fun(Y(4),'H',Ru,MW(6)); % specific heat of H [kJ/kg/K]
    Cp_H2O = specific_heat_calculation_fun(Y(4),'H2O',Ru,MW(7)); % specific heat of H2O [kJ/kg/K]
    Cp_HO2 = specific_heat_calculation_fun(Y(4),'HO2',Ru,MW(8)); % specific heat of HO2 [kJ/kg/K]
    Cp_H2O2 = specific_heat_calculation_fun(Y(4),'H2O2',Ru,MW(9)); % specific heat of H2O2 [kJ/kg/K]
    Cp_N = specific_heat_calculation_fun(Y(4),'N',Ru,MW(10)); % specific heat of N [kJ/kg/K]
    Cp_NO = specific_heat_calculation_fun(Y(4),'NO',Ru,MW(11)); % specific heat of NO [kJ/kg/K]
    Cp_HNO = specific_heat_calculation_fun(Y(4),'HNO',Ru,MW(12)); % specific heat of HNO [kJ/kg/K]
    Cp_NO2 = specific_heat_calculation_fun(Y(4),'NO2',Ru,MW(13)); % specific heat of NO2 [kJ/kg/K]
    
    %% OUTPUTS
    s = [S_O2, S_N2, S_H2, S_OH, S_O, S_H, S_H2O, S_HO2, S_H2O2, S_N, S_NO, S_HNO, S_NO2];
    h = [h_O2, h_N2, h_H2, h_OH, h_O, h_H, h_H2O, h_HO2, h_H2O2, h_N, h_NO, h_HNO, h_NO2];
    Cp = [Cp_O2, Cp_N2, Cp_H2, Cp_OH, Cp_O, Cp_H, Cp_H2O, Cp_HO2, Cp_H2O2, Cp_N, Cp_NO, Cp_HNO, Cp_NO2];
end