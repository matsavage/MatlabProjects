%% Create waterfall plot for I12 time series data

%% Define function
% Define function _I12water_ with input arguments, _x_, _out_ and _n_
% defining;
%
% * Input Q range
% * I12 processing output
% * Unique _xy_ position 

function []= I12sub(x,out,n)

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

%Subtract first pattern
for i = 2:1:size(data,2)
    data{2,i} = data{2,i} - data{2,1};
end

data{2,1} = data{2,1} - 0.9 * data{2,1};

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

%% Generate meshgrid to allow for surface plotting

%Generate meshgrid for 3d plot
[X,TIME] = meshgrid(x,time);



%% Plot waterfall 
%Colorbrewer map
% CT=cbrewer('seq', 'Blues', size(X,2)*4);
% colormap(CT);
 colormap(jet)
figure(2)
mesh(X,TIME,Y);
xlim([min(x),max(x)]);
ylim([min(min(TIME)),max(max(TIME))]);
xlabel('Q A-1');
ylabel('time (seconds)');

%% End program timer and display total elapsed time
toc
