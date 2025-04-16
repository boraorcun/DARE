function [inOut] = intakeModule(inCond,flightComb,atmCond)

global gamma

%% Intake leading edge truncation
if inCond{2} ~= 0
    shock_angle = oblique_angle_calc(flightComb(1),'mach',inCond{2},'theta');
    M_1 = sqrt(1/(sind(shock_angle-inCond{2}))^2*((gamma-1)*flightComb(1)^2*sind(shock_angle)^2+2)/(2*gamma*flightComb(1)^2*sind(shock_angle)^2-(gamma-1)));
else
    M_1 = flightComb(1);
end

%% Isentropic compression

k = linspace(1.1,2,10); % Initial estimate on intake efficiency

macth_value = 1;

while macth_value>1e-3

    if macth_value~=1
    k   =   linspace(k(kf_ind-1),k(kf_ind+1),10);
    end

    for j = 1:length(k)
        % Intake efficiency
        if inCond{2} ~= 0
            TPR(j)  = ((6*flightComb(1)^2*sind(shock_angle)^2)/(flightComb(1)^2*sind(shock_angle)^2+5))^3.5*(6/(7*flightComb(1)^2*sind(shock_angle)^2-1))^2.5;
        end

        TPR(j) = TPR(j)*((gamma+1)*k(j)^2/((gamma-1)*k(j)^2+2)).^(gamma/(gamma-1))*((gamma+1)/...
            (2*gamma*k(j)^2-gamma+1))^(1/(gamma-1));

        % Upstream shock number
        M_2(j) = sqrt(inCond{1}^2*(2*gamma*k(j)^2-gamma+1)*((gamma-1)*k(j)^2+2)+4*(k(j)^2-1)*...
            (gamma.*k(j)^2+1))/((gamma+1)*k(j));

        % Conical shock angle
        theta_23(j) = asin(k(j)./M_2(j));
        if imag(theta_23(j)) ~= 0
            M(j) = NaN; S_s(j) = NaN;%S_i(j) = NaN; alpha = NaN; A_i(j) = NaN; A_s(j) = NaN;
        else
            % Compute the Busemann intake
            [M(j),S_i(j),S_s(j),~,~,~,Length(j),Area(j),Volume(j)]=BusemannIntake(M_2(j),theta_23(j),inCond{2});
        end
    end
    [macth_value,kf_ind] = min(abs(M-M_1)); k_final = k(kf_ind);

end

%% Intake module output

inOut{1} = inCond{1}; % Inakte exit Mach number
inOut{2} = TPR(kf_ind)*atmCond{1}(2)*((1+(gamma-1)*0.5*flightComb(1)^2)/(1+(gamma-1)*0.5*inOut{1}^2))^(gamma/(gamma-1)); % Inakte exit pressure
inOut{3} = atmCond{1}(3)*((1+(gamma-1)*0.5*flightComb(1)^2)/(1+(gamma-1)*0.5*inOut{1}^2)); % Inakte exit temperature

%% Data Recording

Intake(1)   = M(kf_ind);
Intake(2)   = inCond{1};
Intake(3)   = k(kf_ind);
Intake(4)   = TPR(kf_ind);
Intake(5)   = S_s(kf_ind);
Intake(6)  = Length(kf_ind);
Intake(7)  = Area(kf_ind);
Intake(8)  = Volume(kf_ind);

save Intake Intake

return