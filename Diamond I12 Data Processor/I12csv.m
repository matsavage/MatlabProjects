
data = {0};
n = 3;
%
j = 1;
%Organise output
for i = 1:1:size(out,2)
    if out{8,i} == n
        for k = 1:1:size(out,1)
            data{k,j} = out{k,i};
        end
        j = j + 1;
    end
end

% for i = 2:1:size(data,2)
%     data{2,i} = data{2,i} - data{2,1};
% end
% 
% data{2,1} = data{2,1} - 0.9 * data{2,1};

for i = 1:1:size(data,2)
       
        tdir =  ['./I12-3/', num2str(n),'-',num2str(data{1,i}), '.csv'];
    
        fileOUT = fopen(tdir,'w');
        formatSpec = '%s \n';
        
        time = 735930 + data{5,i};
        
       date = datestr(datenum(date),'yyyy/mm/dd');
       time = datestr(data{5,i}*1.1574074e-05, 'HH:MM:SS.FFF');

        %% Print _xy_ IR data to output file
        for j = 1:1:size(data{2,i},1)
            fprintf(fileOUT,formatSpec,...
                [num2str(x(1,j),'%7f'),',',num2str(data{2,i}(j,1),'%7f')]);
        end

        
        fclose(fileOUT);
end
toc
