% Tranformar u/v to rho viento diario
dir = 'G:/Ascat_daily/frc/';

for year = 2008:2012
    nc_file = [dir, 'newperush_frc_ascatdaily_', num2str(year) , '.nc'];
    disp(nc_file)

    ncload(nc_file, 'sustr', 'svstr');
    userie = zeros(size(sustr,2) * size(svstr,3) , size(svstr,1));
    vserie = zeros(size(sustr,2) * size(svstr,3) , size(svstr,1));
    
    for i = 1:size(sustr, 1)
        u =sustr(i,:,:); u =squeeze(u); u =u2rho_2d(u); u =reshape(u,[],1);
        userie(:,i) = u;
    
        v =svstr(i,:,:); v =squeeze(v); v =v2rho_2d(v); v =reshape(v,[],1);
        vserie(:,i) = v;
    end
    
    save([dir, 'sustr', num2str(year), '.txt'], 'userie', '-ascii');
    save([dir, 'svstr', num2str(year), '.txt'], 'vserie', '-ascii');
end


% Tranformar u/v to rho viento climatologico
dir = 'G:/Ascat_clim/frc/';
nc_file = [dir, 'newperush_frc_ascatclim_2008_2012.nc'];
ncload(nc_file, 'sustr', 'svstr');

userie = zeros(size(sustr,2) * size(svstr,3) , size(sustr,1));
vserie = zeros(size(sustr,2) * size(svstr,3) , size(sustr,1));

for i = 1:size(sustr, 1)
u =sustr(i,:,:); u =squeeze(u); u =u2rho_2d(u); u =reshape(u,[],1);
userie(:,i) = u;
v =svstr(i,:,:); v =squeeze(v); v =v2rho_2d(v); v =reshape(v,[],1);
vserie(:,i) = v;
end

save([dir, 'sustr', '.txt'], 'userie', '-ascii');
save([dir, 'svstr', '.txt'], 'vserie', '-ascii');