function [isoOut] = isolatorModule(isoIn)

global gamma engineMode 

if strcmp( engineMode, 'RAM' )

    % Normal shock relations
    isoOut{1} = ((1 + (gamma - 1)*(isoIn{1}^2)/2)/(gamma*(isoIn{1}^2) - (gamma - 1)/2))^(1/2);
    isoOut{2} = isoIn{2}*(1 + (2*gamma)*((isoIn{1}^2) - 1)/(gamma + 1));
    isoOut{3} = isoIn{3}*((1 + (2*gamma)*((isoIn{1}^2) - 1)/(gamma + 1))*(2 + (gamma - 1)*(isoIn{1}^2))/((gamma + 1)*(isoIn{1}^2)));

elseif strcmp( engineMode, 'SCRAM' )

    isoOut = isoIn;

end

return

