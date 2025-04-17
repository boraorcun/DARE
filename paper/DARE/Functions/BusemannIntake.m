function [M,S_i,S_s,alpha,A_i,A_s,Length,Area,Volume]=BusemannIntake(M_2,theta_23,t)

gamma = 1.4; 
A_e       = 4.86;
R         = sqrt(A_e/pi); % Specify the isolator inlet radius
R  = sqrt(4.86/(pi));


% Flow deflection angle

phi_23 = acot(tan(theta_23).*((gamma+1).*M_2.^2./(2*(M_2.^2.*sin(theta_23).^2-1))-1));

% Mach number variables

u_2 = M_2.*cos((theta_23)); v_2 = -M_2.*sin((theta_23));

u = u_2; v = v_2;
theta = theta_23-phi_23;
r=R/sin(theta);
delta_theta = 1e-3*pi/180; %in degrees

% figure(1)
% grid on
% hold on
% yyaxis right
% plot(r*cos((theta)),sqrt(u^2+v^2),'. r')
% ylabel('Mach Number')
% yyaxis left
% plot(r*cos((theta)),r*sin((theta)),'. b')
% ylabel('y [m]')
% xlabel('x [m]')
% set(gca,'linewidth',1.5)
% set(gca,'gridlinestyle',':')
% set(gca, 'GridAlpha', .5)
% box on
% set(gca,'fontsize',18)
x = r*cos((theta)); y = r*sin((theta)); M_xy = sqrt(u^2+v^2);

% while abs(u*sin(theta)+v*cos(theta))>1e-3



while abs(t-atand(abs(u*sin(theta)+v*cos(theta))/abs(u*cos(theta)-v*sin(theta))))>1e-3
    u1 = v+((gamma-1)/2)*u*v*(u+v*cot(theta))/(v^2-1);
    v1 = -u+(1+((gamma-1)/2)*v^2)*(u+v*cot(theta))/(v^2-1);
    r1 = r*u/v;
    
    u2 = (v+delta_theta*v1/2)+(gamma-1)/2*(u+delta_theta*u1/2)*(v+delta_theta*v1/2)...
        *((u+delta_theta*u1/2)+(v+delta_theta*v1/2)*cot(theta+delta_theta/2))/((v+delta_theta*v1/2)^2-1);
    v2 = -(u+delta_theta*u1/2)+(1+(gamma-1)/2*(v+delta_theta*v1/2)^2)*((u+delta_theta*u1/2)...
        +(v+delta_theta*v1/2)*cot(theta+delta_theta/2))/((v+delta_theta*v1/2)^2-1);
    r2 = (r+r1*delta_theta/2)*(u+delta_theta*u1/2)/(v+delta_theta*v1/2);
    
    u3 = (v+delta_theta*v2/2)+(gamma-1)/2*(u+delta_theta*u2/2)*(v+delta_theta*v2/2)...
        *((u+delta_theta*u2/2)+(v+delta_theta*v2/2)*cot(theta+delta_theta/2))/((v+delta_theta*v2/2)^2-1);
    v3 = -(u+delta_theta*u2/2)+(1+(gamma-1)/2*(v+delta_theta*v2/2)^2)*((u+delta_theta*u2/2)...
        +(v+delta_theta*v2/2)*cot(theta+delta_theta/2))/((v+delta_theta*v2/2)^2-1);
    r3 = (r+r2*delta_theta/2)*(u+delta_theta*u2/2)/(v+delta_theta*v2/2);
    
    u4 = (v+delta_theta*v3)+(gamma-1)/2*(u+delta_theta*u3)*(v+delta_theta*v3)...
        *((u+delta_theta*u3)+(v+delta_theta*v3)*cot(theta+delta_theta))/((v+delta_theta*v3)^2-1);
    v4 = -(u+delta_theta*u3)+(1+(gamma-1)/2*(v+delta_theta*v3)^2)*((u+delta_theta*u3)...
        +(v+delta_theta*v3)*cot(theta+delta_theta))/((v+delta_theta*v3)^2-1);
    r4 = (r+r3*delta_theta)*(u+delta_theta*u3)/(v+delta_theta*v3);
    
    theta = theta+delta_theta;
    u = u + delta_theta*(u1+2*u2+2*u3+u4)/6;
    v = v + delta_theta*(v1+2*v2+2*v3+v4)/6;
    r = r + delta_theta*(r1+2*r2+2*r3+r4)/6;
    
    if abs(u)<1e-2
        r_s = r; theta_s = theta; M_s = sqrt(u^2+v^2);
    end
    
    if abs(u)>1e1
    M = NaN; S_i = NaN; S_s = NaN; alpha = NaN; A_i = NaN; A_s = NaN;  Length = NaN; Area = NaN; Volume = NaN;
        return
    end
    
%     yyaxis right
%     plot(r*cos((theta)),sqrt(u^2+v^2),'. r')
%     yyaxis left
%     plot(r*cos((theta)),r*sin((theta)),'. b')

x = [x r*cos((theta))]; y = [y r*sin((theta))]; M_xy = [M_xy sqrt(u^2+v^2)];
end

if ~exist('r_s')
    M = NaN; S_i = NaN; S_s = NaN; alpha = NaN; A_i = NaN; A_s = NaN;  Length = NaN; Area = NaN; Volume = NaN;
    return
end

Length = max(x)-min(x); Area = pi*max(y)^2; Volume = trapz(max(x)-x,pi*y.^2);

M = sqrt(u^2+v^2);
alpha = pi-theta;

% Startability analysis
A_e = R^2*pi;
A_i = (r*sin((theta)))^2*pi;

A_kantrowitz = A_i*M*(2.4/(2+0.4*M^2))^(2.4/0.8)*(2.4*M^2/(0.4*M^2+2))^(-1.4/0.4)*(2.4/(2*1.4*M^2-0.4))^(-1/0.4);
A_isentropic = A_i*M*1.2^(2.4/0.8)*(1+0.4*M^2)^(-2.4/0.8);  
S_i = (A_e/A_isentropic-1)/(A_kantrowitz/A_isentropic-1);

A_s = pi*(r_s*sin(theta_s))*r_s;

A_kantrowitz = A_s*M_s*(2.4/(2+0.4*M_s^2))^(2.4/0.8)*(2.4*M_s^2/(0.4*M_s^2+2))^(-1.4/0.4)*(2.4/(2*1.4*M_s^2-0.4))^(-1/0.4);
A_isentropic = A_s*M_s*1.2^(2.4/0.8)*(1+0.4*M_s^2)^(-2.4/0.8);  
S_s = (A_e/A_isentropic-1)/(A_kantrowitz/A_isentropic-1);
end
