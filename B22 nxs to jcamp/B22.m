clear
clf
tic

inpath       = uigetdir('~/nexus/YY-Zr','Select input folder');
outpath      = uigetdir('~/B22/YY-Zr','Select output folder');

files = dir([inpath,'/*.nxs']);
for i = 1:1:size(files,1)
    if files(i).isdir == 0
        
        files(i).name = files(i).name(1:end-4);
        
        fileIN      = [inpath , '/' , files(i).name, '.nxs'];
        fileIN
        parms = '/entry1/instrument/interferometer/opus_parameters';
        data  = '/entry1/instrument/interferometer/ratio_absorbance';
        adata = '/ratio_data_absorbance';
        
        
        abs(:,1) = h5read(fileIN,[data,'/energy']);
        abs(:,2) = h5read(fileIN,[data,'/data']);
        
        time = h5read(fileIN,[parms,adata,'/time_of_measurement']);
        time{1,1} = time{1,1}(1:end-8);
        
        date = h5read(fileIN,[parms,adata,'/date_of_measurement']);
        date = datestr(datenum(date,'dd/mm/yyyy'),'yyyy/mm/dd');
        
        scale   = h5read(fileIN,[parms,adata,'/y_scaling_factor']);
        sampres = h5read(fileIN,[parms,'/acquisition/resolution']);
        
        inst = h5info(fileIN);
        inst = inst.Attributes(6).Value;
        
        sample = h5read(fileIN,[parms,'/sample/sample_name']);
        
        hold on
        plot(abs(:,1),abs(:,2))
        set(gca, 'XDir', 'reverse')
        
        
        fileOUT = fopen([outpath '/' , files(i).name, '.jdx'],'w');
        formatSpec = '%s \n';
        
        %% Print JCAMP file header to output file
        
        fprintf(fileOUT,formatSpec,...
            ['##TITLE=',sample{1,1}]);
        fprintf(fileOUT,formatSpec,...
            '##JCAMP-DX=5.01  $$ Matlab script');
        fprintf(fileOUT,formatSpec,...
            '##DATATYPE=INFRARED SPECTRUM');
        fprintf(fileOUT,formatSpec,...
            '##ORIGIN=Mathew Savage NXS to JCAMP script');
        fprintf(fileOUT,formatSpec,...
            '##OWNER=Schoder Group, Nottingham');
        fprintf(fileOUT,formatSpec,...
            ['##LONGDATE=',date]);
        fprintf(fileOUT,formatSpec,...
            ['##TIME=',time{1,1}]);
        fprintf(fileOUT,formatSpec,...
            '##DATA PROCESSING=');
        fprintf(fileOUT,formatSpec,...
            ['##SPECTROMETER/DATA SYSTEM=',inst{1,1}]);
        fprintf(fileOUT,formatSpec,...
            '##XUNITS=1/CM');
        fprintf(fileOUT,formatSpec,...
            '##YUNITS=ABSORBANCE');
        fprintf(fileOUT,formatSpec,...
            ['##RESOLUTION=',num2str(sampres)]);
        fprintf(fileOUT,formatSpec,...
            ['##FIRSTX=',num2str(min(abs(:,1)))]);
        fprintf(fileOUT,formatSpec,...
            ['##LASTX=',num2str(max(abs(:,1)))]);
        fprintf(fileOUT,formatSpec,...
            ['##FIRSTY',num2str(abs(1,2))]);
        fprintf(fileOUT,formatSpec,...
            ['##MAXX=',num2str(max(abs(:,1)))]);
        fprintf(fileOUT,formatSpec,...
            ['##MINX=',num2str(min(abs(:,1)))]);
        fprintf(fileOUT,formatSpec,...
            ['##MAXY=',num2str(max(abs(:,2)))]);
        fprintf(fileOUT,formatSpec,...
            ['##MINY=',num2str(min(abs(:,2)))]);
        fprintf(fileOUT,formatSpec,...
            '##XFACTOR=1.000000');
        fprintf(fileOUT,formatSpec,...
            ['##YFACTOR=',num2str(scale,'%4.6f')]);
        fprintf(fileOUT,formatSpec,...
            ['##NPOINTS=',num2str(size(abs,1))]);
        fprintf(fileOUT,formatSpec,...
            '##DELTAX=0.0');
        fprintf(fileOUT,formatSpec,...
            '##XYDATA=(X++(Y..Y))');
        
        %% Print _xy_ IR data to output file
        for j = 1:1:size(abs,1)
            fprintf(fileOUT,formatSpec,...
                [num2str(abs(j,1),'%7f'),'  ',num2str(abs(j,2),'%7f')]);
        end
        
        fprintf(fileOUT,formatSpec,...
            '##END=');
        
        
        fclose(fileOUT);
    end
end
toc
