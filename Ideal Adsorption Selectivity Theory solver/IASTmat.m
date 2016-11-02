clear 
clf
a = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%Data library
%
%Input in form
% 
% Single site
% 
% GasTempi   =   [Qmax    error;
%                 b       error;
%                 v       error];
% 
% Dual site
%
% GasTempii  =   [Qmax1   error    Qmax2   error;
%                 b2      error    b2      error;
%                 v2      error    v2      error];
            
eg1 = [19.23 0.1; 0.333  0.01; 1.02   0.001];
eg2 = [15.18 0.1; 0.0681 0.01; 1.0148 0.001];

ch4293i    =   [6.83799 0.03368;
                0.13101 7.85677E-4;
                1.1316 0.00705];
            
ch4293ii   =   [5.01129 0.33187  2.21325 0.35227;
                0.14008 0.00162  0.08605 0.00595;
                0.9103  0.02413  1.59862 0.0653];

c2h2293i   =   [7.13014 0.11502; 
                3.76136 0.24052; 
                1.30934 0.02669];

c2h2293ii  =   [3.76879 0.50903  3.29453 0.37475;
                2.37596 0.23111  8.22892 1.04198;
                0.89643 0.01959  1.99375 0.08272];
            
c2h4293i   =   [6.50669	0.09667;
                3.08306	0.15934;
                1.37934	0.02234];    
            
c2h4293ii  =   [3.02357	0.25302  4.05675 0.35146;
                6.90616	0.648    1.2438  0.08213;
                1.99426	0.06094  0.88572 0.02471];
            
c2h6293i   =   [5.8816	0.03423;
                6.01514	0.19017;
                1.31007	0.01321];          
             
c2h6293ii  =   [4.57207	0.08755  2.09719  0.12887;
                1.98789	0.12303  26.42934 2.19287;
                0.92921	0.01705  1.99212  0.04189];

co2298i    =   [8.54728 0.04471;
                0.93967 0.01856;
                1.16454 0.0193];
            
so2298i    =   [8.05312 0.05187;
                373.74913 100.16618;
                1.61144 0.06956];
            

% Define gas a and gas b
ga = so2298i;
gasa = 'SO2';
gb = co2298i;
gasb = 'CO2';
temp = '298 K';

%Steps config
maxP  = 1;
steps = 51;

%Define IAST variables
y1=0.0001;
y2=1-y1;

j = 1;
 a = zeros(150,16);
for p=logspace(-10,0,150)
    
%for p=0.01:maxP/steps:maxP
    
    %Calcultate isotherm a and errors
    isoa  = (ga(1)*ga(2)*p.^ga(3))/(1+(ga(2)*p.^ga(3)));
    isoap = ((ga(1)+ga(4))*(ga(2)+ga(5))*p.^(ga(3)+ga(6)))...
                        /(1+((ga(2)+ga(5))*p.^(ga(3)+ga(6))));
    isoam = ((ga(1)-ga(4))*(ga(2)-ga(5))*p.^(ga(3)-ga(6)))...
                        /(1+((ga(2)-ga(5))*p.^(ga(3)-ga(6))));  
    
    %Calculate isotherm b and errors
    isob  = (gb(1)*gb(2)*p.^gb(3))/(1+(gb(2)*p.^gb(3)));
    isobp = ((gb(1)+gb(4))*(gb(2)+gb(5))*p.^(gb(3)+gb(6)))...
                        /(1+((gb(2)+gb(5))*p.^(gb(3)+gb(6))));
    isobm = ((gb(1)-gb(4))*(gb(2)-gb(5))*p.^(gb(3)-gb(6)))...
                        /(1+((gb(2)-gb(5))*p.^(gb(3)-gb(6))));  
                    
    %Overall IAST calculation
IAST=@(x1) ((ga(1).*log(ga(2).*(p.*y1./x1)    .^ga(3) + 1))./ga(3)...
           -(gb(1).*log(gb(2).*(p.*y2./(1-x1)).^gb(3) + 1))./gb(3)...
          );

x1 = fzero(IAST,[1e-6,0.999999]);

x2=1.0-x1;
S=(x1/y1)/(x2/y2);

    %Upper bound IAST calculation
IASTp=@(x1) (((ga(1)+ga(4)).*log((ga(2)+ga(5)).*(p.*y1./x1)    ...
                           .^(ga(3)+ga(6)) + 1))./(ga(3)+ga(6))...
            -((gb(1)+gb(4)).*log((gb(2)+gb(5)).*(p.*y2./(1-x1))...
                           .^(gb(3)+gb(6)) + 1))./(gb(3)+gb(6))...
          );

x1p = fzero(IASTp,[1e-6,0.999999]);

x2p=1.0-x1p;
Sp=(x1p/y1)/(x2p/y2);

    %Lower bound IAST calculation
IASTm=@(x1) (((ga(1)-ga(4)).*log((ga(2)-ga(5)).*(p.*y1./x1)   ... 
                          .^(ga(3)-ga(6)) + 1))./(ga(3)-ga(6))...
           -((gb(1)-gb(4)).*log((gb(2)-gb(5)).*(p.*y2./(1-x1))...
                          .^(gb(3)-gb(6)) + 1))./(gb(3)-gb(6))...
          );

x1m = fzero(IASTm,[1e-6,0.999999]);

x2m=1.0-x1m;
Sm=(x1m/y1)/(x2m/y2);

a(j,:) = [p isoa isoap-isoa isoam-isoa ...
       isob isobp-isob isobm-isob ...
       x1   x1p-x1     x1m-x1     ...
       x2   x2p-x2     x2m-x2     ...
       S    Sp-S       Sm-S];

j = j + 1;
end

a = a(setdiff(1:size(a,1),1),:);

%Output to screen
% label   = 'Output';
%  vheader = sprintf('ROW%d ', 1:size(a,1)) ;
  hheader = ['Pressure isoa isoap isoam isob isobp isobm '...
             'x1 x1p x1m x2 x2p x2m S Sp Sm'];
%  printmat(a, label, vheader, hheader);
 
 fig = figure(1);
 %Plot output
subplot(2,2,1);
hold on
 %Selectivity plot
 s1  =  plot(a(:,1), a(:,14),'o-b','LineWidth',1,'MarkerSize',2);
 s1p =  plot(a(:,1), a(:,14)+a(:,15),'.b','LineWidth',1);
 s1m =  plot(a(:,1), a(:,14)+a(:,16),'.b','LineWidth',1);
 %s1 = errorbar(a(:,1),a(:,14),a(:,15),a(:,16));
 
 %Formatting
 xlim([a(1)-0.05,a(end,1)+0.05]);
 ylim([min(a(:,14)-0.1*max(a(:,14))),...
       max(a(:,14))+(max(a(:,14))*0.2)]);
 sLeg = legend(s1,{'Selectivity'});
 set(sLeg,'Location','NorthWest');
 tstring = [gasa ' vs ' gasb ' ' temp ' Selectivity'];
 sTitle = title(tstring);
 ylabel('Selectivity');
 xlabel('Pressure (Bar)');
 
% %X1 and X2 plot
% subplot(3,2,3);
% hold on
% %Isotherm 1
% m1  =  plot(a(:,1), a(:,8),'o-b','LineWidth',1,'MarkerSize',2);
% m1p =  plot(a(:,1), a(:,8)+a(:,9),'.b','LineWidth',1);
% m1m =  plot(a(:,1), a(:,8)+a(:,10),'.b','LineWidth',1);
% %Isotherm 2
% m2  =  plot(a(:,1), a(:,11),'o-r','LineWidth',1,'MarkerSize',2);
% m2p =  plot(a(:,1), a(:,11)+a(:,12),'.r','LineWidth',1);
% m2m =  plot(a(:,1), a(:,11)+a(:,13),'.r','LineWidth',1);
% % errorbar(a(:,1),a(:,2),a(:,3),a(:,4));
% % errorbar(a(:,1),a(:,5),a(:,6),a(:,7));
% % t = uitable('Position',[125 450 295 75],...
% %             'Data',[ga,gb],...
% %             'ColumnName',{'Gas 1','S. Error','Gas 2','S. Error'},...
% %             'RowName',{'Qmax','b','v'},...
% %             'ColumnWidth',{60});
% 
% 
%   %Formatting
%  mTitle = title('X1 and X2 plot');
%  ylabel('Adsorption (mmol/g)')
%  xlabel('Pressure (bar)');
%  xlim([a(1)-0.05,a(end,1)+0.05]);
%  ylim([min(min(a(:,[8,11])))-(min(min(a(:,[8,11])))*0.2),...
%        max(max(a(:,[8,11])))+(max(max(a(:,[8,11])))*0.2)]);
%  mLeg = legend([m1 m2],{gasa,gasb});
%  set(mLeg,'Location','NorthWest')
 
 %Isotherms plot
subplot(2,2,3);
hold on
%Isotherm 1
i1  =  plot(a(:,1), a(:,2),'o-b','LineWidth',1,'MarkerSize',2);
i1p =  plot(a(:,1), a(:,2)+a(:,3),'.b','LineWidth',1);
i1m =  plot(a(:,1), a(:,2)+a(:,4),'.b','LineWidth',1);
%Isotherm 2
i2  =  plot(a(:,1), a(:,5),'o-r','LineWidth',1,'MarkerSize',2);
i2p =  plot(a(:,1), a(:,5)+a(:,6),'.r','LineWidth',1);
i2m =  plot(a(:,1), a(:,5)+a(:,7),'.r','LineWidth',1);
% errorbar(a(:,1),a(:,2),a(:,3),a(:,4));
% errorbar(a(:,1),a(:,5),a(:,6),a(:,7));
% t = uitable('Position',[125 450 295 75],...
%             'Data',[ga,gb],...
%             'ColumnName',{'Gas 1','S. Error','Gas 2','S. Error'},...
%             'RowName',{'Qmax','b','v'},...
%             'ColumnWidth',{60});


  %Formatting
 iTitle = title('Adsorption isotherms');
 ylabel('Adsorption (mmol/g)')
 xlabel('Pressure (bar)');
 xlim([a(1)-0.05,a(end,1)+0.05]);
 ylim([-0.5,max(max(a(:,[2,5])))+(max(max(a(:,[2,5])))*0.2)]);
 iLeg = legend([i1 i2],{gasa,gasb});
 set(iLeg,'Location','NorthWest')

 %Output to file
 subDir = 'Output'; 
 txtOutString = ['./' subDir '/' tstring '.txt'];
 dlmwrite(txtOutString,hheader,'delimiter','');
 dlmwrite(txtOutString,a,'delimiter',' ','-append');

 b=[a(:,16) -a(:,15)];
 b = mean(b,2);
 sht = [a(:,1) a(:,14) b];
 shtLbl = 'P S Se';
  
 txtOutStringSht = ['./' subDir '/' tstring '-Sht.txt'];
 dlmwrite(txtOutStringSht,shtLbl,'delimiter','');
 dlmwrite(txtOutStringSht,sht,'delimiter',' ','-append');
 
 %Save Figure
 epsOutString = ['./' subDir '/' tstring '.eps'];
 saveas(gcf,epsOutString,'eps2c');
 epsOutString = ['./' subDir '/current.eps'];
 saveas(gcf,epsOutString,'eps2c');
 

 
