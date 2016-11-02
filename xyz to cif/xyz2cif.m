clear

%File access
fileIN = fopen(['./' input('Input File:\n', 's') '.xyz'],'r');
formatSpec = '%s %f %f %f';
l = fgetl(fileIN);
a = textscan(fileIN,formatSpec,'Headerlines',1);
fclose(fileIN);

disp([char(10) l ' Atoms found in input' char(10)]);

 [atoms,~,idx] = unique(a{:,1}); 
 counts = accumarray(idx(:),1,[],@sum);  

 counts = transpose(counts);
 atoms = transpose(atoms);
 b = '';
 %atoms = {counts ; atoms}
 for n = 1:length(counts),
 b = [b, ' ', atoms{1,n}, num2str(counts(1,n))];
 %c = [c b];
 end
 
 disp(['Chemical formula:' char(10) b char(10)]);

%Generate unit cell dimensions
ca = max([a{:,2}]) - min([a{:,2}]);
cb = max([a{:,3}]) - min([a{:,3}]);
cc = max([a{:,4}]) - min([a{:,4}]);
   
%Scale all coordinates to fractional
a{:,2} = a{:,2}-min(a{:,2});
a{:,2} = a{:,2}/max(a{:,2});

a{:,3} = a{:,3}-min(a{:,3});
a{:,3} = a{:,3}/max(a{:,3});

a{:,4} = a{:,4}-min(a{:,4});
a{:,4} = a{:,4}/max(a{:,4});

disp(['Cell dimensions:' char(10)...
      ' a = ' num2str(ca,'%.5f') ' Å'...
      ' b = ' num2str(cb,'%.5f') ' Å'...
      ' c = ' num2str(cc,'%.5f') ' Å' char(10)...
      ' V = ' num2str((ca)*(cb)*(cc),'%.2f') ' Å^3' char(10)]);
 
%Current date
date = now;
date = datestr(date,29);

%Output header data
fileOUT = fopen(['./CIFs/' input('Output File:\n','s') '.cif'],'w');
formatSpec = '%s \n';

    fprintf(fileOUT,formatSpec,...
        'data_xyz2cif');
    fprintf(fileOUT,formatSpec,...
       ['_audit_creation_date               ' date]);
    fprintf(fileOUT,formatSpec,...
        '_audit_creation_method             "Matlab xyz to cif script"');
    fprintf(fileOUT,formatSpec,...   
        '_symmetry_Int_Tables_number        1');
    fprintf(fileOUT,formatSpec,...
       ['_cell_length_a                     ' num2str(ca,'%.5f')]);
    fprintf(fileOUT,formatSpec,...
       ['_cell_length_b                     ' num2str(cb,'%.5f')]);
    fprintf(fileOUT,formatSpec,...
       ['_cell_length_c                     ' num2str(cc,'%.5f')]);
    fprintf(fileOUT,formatSpec,...
       [''...
        'loop_'                             char(10)...
        '_symmetry_equiv_pos_site_id'       char(10)...
        '_symmetry_equiv_pos_as_xyz'        char(10)...
        '   1   x,y,z'                      char(10)...
        ''                                  char(10)...
        'loop_'                             char(10)...
        '_atom_site_label'                  char(10)...
        '_atom_site_type_symbol'            char(10)...
        '_atom_site_fract_x'                char(10)...
        '_atom_site_fract_y'                char(10)...
        '_atom_site_fract_z'                char(10)...
        '_atom_site_occupancy']);

%Output atom list
b = a{1:1};
[nrows,ncols] = size(a{:,2});
formatSpec = '%s \n';
for row = 1:nrows
    t = [b{row,1} char(9) b{row,1}    char(9)...
        num2str(a{1,2}(row,1),'%.5f') char(9)...
        num2str(a{1,3}(row,1),'%.5f') char(9)...
        num2str(a{1,4}(row,1),'%.5f') char(9)...
        num2str(1)];
    fprintf(fileOUT,formatSpec,t);
end

  fclose(fileOUT);