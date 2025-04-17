function[Cp] = specific_heat_calculation_fun(T,specie,Ru,MW_specie)
    fopen all;
    fclose all;
    R = Ru/MW_specie;
    fileIDE = fopen('janaf_table.txt');
    Msh = textscan(fileIDE,'%s %s %s %s %s','headerlines',0);
    Nsh = Msh{1,1};
    counter = 1;
    for i = 1:4:10000
        if strcmp(Nsh(i),specie) == 1
            break
        end
        counter = counter+1;
    end
    m = (counter*4 - 3);
    fileID = fopen('janaf_table.txt');
    Csh = textscan(fileID,'%f %f %f %f %f','headerlines',m);
    Dsh = zeros(3,5);
    n=3;
    for k=1:5
        Ash = Csh{1,k};
            if k == 5
               n=2;
            end
        for i=1:n
           Dsh(i,k) = Ash(i,1);  
        end
    end
    if T >= 1000
        Cp = R*(Dsh(1,1) + Dsh(1,2)*T + Dsh(1,3)*T^2 + Dsh(1,4)*T^3 + Dsh(1,5)*T^4);
    else
        Cp = R*(Dsh(2,3) + Dsh(2,4)*T + Dsh(2,5)*T^2 + Dsh(3,1)*T^3 + Dsh(3,2)*T^4);
    end
end