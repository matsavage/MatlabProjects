clear
clf

format long

%File access
fileIN = fopen('./l2s3-h.eps','r');
formatSpec = '%f %f %f %f %f %c %c';
a = textscan(fileIN,formatSpec,'Headerlines',118);
fclose(fileIN);

%Convert HSV to RGB colourspace
colourhsv = [a{1,5} a{1,4} a{1,3}];
colourrgb =  colourhsv; %hsv2rgb(colourhsv);

% a{:,2} = a{:,2}-min(a{:,2});
% a{:,2} = a{:,2}/max(a{:,2});
% 
% a{:,3} = a{:,3}-min(a{:,3});
% a{:,3} = a{:,3}/max(a{:,3});
% 
% a{:,4} = a{:,4}-min(a{:,4});
% a{:,4} = a{:,4}/max(a{:,4});

%Organise and scale co-ordinates
  xy = [a{1,1} a{1,2}];

% Expanded scale
  xy(:,1) = xy(:,1)-2;
  xy(:,1) = xy(:,1)/4.33;

  xy(:,2) = xy(:,2)/4.33;
% Default scale
%   xy(:,1) = xy(:,1)-2;
%   xy(:,1) = xy(:,1)/5;
% 
%   xy(:,2) = xy(:,2)/5;
  
%rgb = (colourrgb(:,1)+(colourrgb(:,2)*256)+(colourrgb(:,3)*65536));

output = [xy colourrgb];
grey = [0 0 0 0 0];
line = [0 0 0 0 0];
for b = 1:length(output)
    if output(b,4) == 0
        row = output(b,:);
        grey = [grey;row];
    else
        row = output(b,:);
        line = [line;row];
    end
end
grey = grey(setdiff(1:size(grey,1),1),:);
line = line(setdiff(1:size(line,1),1),:);

line(:,5) = line(:,5)-min(line(:,5));
line(:,5) = line(:,5)/max(line(:,5));
%line(:,5) = line(:,5)/line(:,3);

%output(:,[3,4,5]) = abs(output(:,[3,4,5]))
% colmap=0;
% for b = 1:length(output)
%     c = mean(output(b,[3,4,5]));
%     colmap = [colmap;c];
% end

% colmap = colmap(setdiff(1:size(colmap,1),1),:);

%output(:,6) = mean(output(:,[3,4,5]));
hold on
 CT=cbrewer('seq', 'Blues', 8);
 colormap(CT);
scatter(grey(:,1),grey(:,2),40,[0.85 0.85 0.85],'.');
scatter(line(:,1),line(:,2),40,line(:,5),'.');
 xlim([0.4,3]);
 ylim([0.4,3]);
%   xlim([0,13]);
%   ylim([0,13]);
 axis square;
 set(gca,'YTick',[0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0]);
 set(gca,'XTick',[0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0]);
 grid on;
 box on;
 xlabel('Internal contact distance');
 ylabel('External contact distance');

 %colorbar
 
dlmwrite('line-l2s3-c.txt',line,'precision',7);
dlmwrite('grey-l2s3-c.txt',grey,'precision',7);
saveas(gcf,'try.eps','eps2c');