function [output, outputID] = oblique_angle_calc(param1, inputID1, param2, inputID2, gam)
%oblique_angle_calc - Function to relate beta, theta and mach number
% Calculates either beta, theta or mach number in terms of the weak oblique
% relationship when given the other two parameters.
%
%   Parameters:
%       output, param1, param2: Can be either beta [deg], theta [deg], or
%                               mach number.
%       gam: Heat capacity ratio; for air as ideal gas, gamma = 1.4
%
%       outputID, inputID1, inputID2: Can be either beta, theta, or mach.
%                                     Must be a string in all lowercase
%                                     letters.
% Example:
%   oblique_angle_calc(2, 'mach', 15, 'theta') would return [45.3, 'beta'] 
%
% Author: Jason Ryan
% Date: 12/06/2013
% Last Revised: 12/15/13
%
%% Initialize Inputs
if strcmp(inputID1,inputID2)
    error('Need two different input types, e.g.: mach beta')
end
if nargin == 4
    gam = 1.4;
end
switch inputID1
    case 'beta'
        beta = param1;
    case 'mach'
        mach = param1;
    case 'theta'
        theta = param1;
    otherwise
        error('Input ID #1 is invalid; Use beta, mach or theta.')
end
switch inputID2
    case 'beta'
        beta = param2;
    case 'mach'
        mach = param2;
    case 'theta'
        theta = param2;
    otherwise
        error('Input ID #2 is invalid; Use beta, mach or theta.')
end
%% Create Output
if ~exist('beta','var')
    outputID = 'beta';
    f = @(b) 2*cotd(b)*(mach^2*sind(b)^2 - 1)/(mach^2*(gam + cosd(2*b)) + 2) - tand(theta);    
    output = secant_method(f);
    
    % Error advising
    if isnan(output)
                
        title('Beta w/ Varying Mach Number @ Current Theta')
        plot(mach,0,'rs'),hold on
        xlim([(mach - 2) 12])
        mach = mach:0.1:11;
        
        for j = 1:length(mach)
            f = @(b) 2*cotd(b)*(mach(j)^2*sind(b)^2 - 1)/(mach(j)^2*(gam + cosd(2*b)) + 2) - tand(theta);    
            beta(j) = secant_method(f);
        end           
        
        cnt = 1;
        indReal = zeros(size(beta));
        for i = 1:length(beta)
            if ~isnan(beta(i)) && beta(i) >= 0
                indReal(cnt) = i;
                cnt = cnt + 1;
            end
        end
        indReal(indReal==0) = [];
        
        area(mach(indReal),beta(indReal))        
        legend('Current Operating Conditions','Oblique Shock Area')
        xlabel('Mach'),ylabel('Beta')
        
        error('This weak oblique shock will not occur at current operating conditions')
    end
    
elseif ~exist('mach','var')
    outputID = 'mach';
    
    output = sqrt((2*(cotd(beta)+tand(theta)))/(sind(2*beta)-tand(theta)*(gam+cosd(2*beta))));
        
    % Error advising
    if ~isreal(output)
        
        betaOrig = beta;
        
        subplot(2,1,1)
        title('Mach Number w/ Varying Beta @ Current Theta')
        plot(beta,0,'rs'),hold on
        xlim([(beta - 2) 90])
        
        beta = 0:90;
        mach = sqrt((2*(cotd(beta)+tand(theta)))./(sind(2*beta)-tand(theta)*(gam+cosd(2*beta))));
        
        cnt = 1;
        indReal = zeros(size(mach));
        for i = 1:length(mach)        
            if isreal(mach(i))
                indReal(cnt) = i;
                cnt = cnt + 1;
            end
        end
        indReal(indReal==0) = [];
                
        area(beta(indReal),mach(indReal))        
        legend('Current Operating Conditions','Oblique Shock Area')
        xlabel('Beta'),ylabel('Mach')
        
        subplot(2,1,2)
        title('Mach Number w/ Varying Theta @ Current Beta') 
        plot(theta,0,'rs'),hold on
        xlim([-2 (theta + 2)])
        theta = 0:45;
        beta = betaOrig;
        mach = sqrt((2*(cotd(beta)+tand(theta)))./(sind(2*beta)-tand(theta)*(gam+cosd(2*beta))));
        
        cnt = 1;
        indReal1 = zeros(size(mach));
        for i = 1:length(mach)        
            if isreal(mach(i))
                indReal1(cnt) = i;
                cnt = cnt + 1;
            end
        end
        indReal1(indReal1==0) = [];
        
        area(theta(indReal1),mach(indReal1))
        legend('Current Operating Conditions','Oblique Shock Area')
        xlabel('Theta'),ylabel('Mach')
        
        error('This weak oblique shock will not occur at current operating conditions')
    end    
    
elseif ~exist('theta','var')
    outputID = 'theta';
    output = atand(2*cotd(beta)*(mach^2*sind(beta)^2 - 1)/(mach^2*(gam + cosd(2*beta)) + 2));
    
    % Error advising
    if output < 0
        
        betaOrig = beta;
        
        subplot(2,1,1)
        title('Theta w/ Varying Beta @ Current Mach Number')
        plot(beta,0,'rs'),hold on
        xlim([(beta - 2) 90])
        betaZero = asind(1/mach);
        beta = betaZero:90;
        theta = atand(2*cotd(beta).*(mach^2*sind(beta).^2 - 1)./(mach^2*(gam + cosd(2*beta)) + 2));
        
        area(beta,theta)        
        legend('Current Operating Conditions','Oblique Shock Area')
        xlabel('Beta'),ylabel('Theta')
        
        subplot(2,1,2)
        title('Theta w/ Varying Mach Number @ Current Beta') 
        plot(mach,0,'rs'),hold on
        xlim([(mach - 2) 15+2])
        machZero = 1/sind(betaOrig);
        mach = machZero:15;
        beta = betaOrig;
        theta = atand(2*cotd(beta)*(mach.^2*sind(beta)^2 - 1)./(mach.^2*(gam + cosd(2*beta)) + 2));
        
        area(mach,theta)
        legend('Current Operating Conditions','Oblique Shock Area')
        xlabel('Mach'),ylabel('Theta') 
        
        error('This weak oblique shock will not occur at current operating conditions')
    end
    
end
end
%% Subfunctions
function out = secant_method(f)
xp = 0:90;
y = zeros(size(xp));
for j = 1:length(xp);
    y(j) = f(xp(j));
end
[~,maxInd] = max(y);
% Initialize for secant method
tol = 0.0001;
b = zeros(1,10);
b(1) = 5;
b(2) = xp(maxInd-1);
% Secant method
i = 2;
while abs(b(i) - b(i - 1)) > tol
    i = i + 1;       
    b(i) = b(i-1) - (f(b(i-1)))*((b(i-1) - b(i-2))/(f(b(i-1)) - f(b(i-2))));
end
out = b(i);
end