%% Create waterfall plot for I12 time series data

%% Define function
% Define function _I12water_ with input arguments, _x_, _out_ and _n_
% defining;
%
% * Input Q range
% * I12 processing output
% * Unique _xy_ position 

function []= I12save2(x,out,n)

%% Sort data with _xy_ position from main output
 % Generate variable for data from unique _xy_ position
data = {0};
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

%% Sort _x_ axis and _time_ axes for |meshgrid()|

%Create time axis
time = zeros(size(data,2),1);
for i = 1:1:size(data,2)
    time(i,1) = data{5,i};
end

Y = zeros(size(data,2),size(data{11,1},1));
for i = 1:1:size(data,2)
    Y(i,:) = data{2,i}';
    
end

runs = zeros(size(data,2),1);
for i = 1:1:size(data,2)
    runs(i,:) = data{1,i}';
    
end

filehead = [0 , runs' ; 0 , time'];

filedata = [x ; zeros(size(data,2),size(x,2))]';
for i = 1:1:size(data,2)
    filedata(:,i+1) = data{2,i};
end

fileout = [filehead ; filedata];

dlmwrite(['./100C/',num2str(data{1,1}) ' - ' num2str(data{1,size(data,2)}) '.txt'],...
          fileout,'precision',7,'delimiter',',');

%% End program timer and display total elapsed time
toc
