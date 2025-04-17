function[Hydraulic_Diameter, Wall_Perimeter, Area_gradient] = geometric_calculation_fun(x,type,Comb_Length,Area,area_gradient)
    
    if strcmp( type, 'circular' )
        Radius = sqrt(Area/pi);
        Hydraulic_Diameter = 2 * Radius;
        Wall_Perimeter = pi * Hydraulic_Diameter;
    end
    
    Area_gradient = interp1(area_gradient(:,1),area_gradient(:,2),x,'linear','extrap');
    
end