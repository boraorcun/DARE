classdef testDARE_Examples < matlab.unittest.TestCase
    methods (Test)

        function test_RAM_1(testCase)
            cd('../Ramjet/1');
            run('DARE_RamExample1.m');
        end
        function test_RAM_2(testCase)
            cd('../../Ramjet/2');
            run('DARE_RamExample2.m');
        end

        function test_SCRAM_(testCase)
            cd('../../Scramjet/1');
            run('DARE_ScramExample1.m');
        end

        function test_SCRAM_2(testCase)
            cd('../../Scramjet/2');
            run('DARE_ScramExample2.m');
        end

        function tests_run(testCase)
            for k=1:1:4
                if k==1
                    cd('../../Ramjet/1');
                    name = ' First Ramjet Example ===';
                elseif k==2
                    cd('../../Ramjet/2');
                    name = ' Second Ramjet Example ===';
                elseif k==3
                    cd('../../Scramjet/1');
                    name = ' First Scramjet Example ===';
                elseif k==4
                    cd('../../Scramjet/2');
                    name = ' Second Scramjet Example ===';
                end
                
                % Automatically detect which performance file exists
                if exist('Performance_Results_for_Ramjet_Engine.txt','file')
                    fname = 'Performance_Results_for_Ramjet_Engine.txt';
                elseif exist('Performance_Results_for_Scramjet_Engine.txt','file')
                    fname = 'Performance_Results_for_Scramjet_Engine.txt';
                else
                    error('No performance results file found in this folder.');
                end
            
                % Read and parse lines
                lines = readlines(fname);
                lines = strtrim(lines);
                lines = lines(lines ~= "");
    
                names  = strings(numel(lines),1);
                values = zeros(numel(lines),1);
    
                for i = 1:numel(lines)
                    parts = split(lines(i),':');
                    if numel(parts) == 2
                        names(i)  = strtrim(parts(1));
                        values(i) = str2double(strtrim(parts(2)));
                    end
                end
    
                % Display table nicely
                T = table(names, values, 'VariableNames',{'Parameter','Value'});
                disp(' ');
                example_name = strcat('=== Performance values for',name);
                disp(example_name);
                disp(T);
                disp('===========================');
                disp(' ');
            end
        end
    end
end
