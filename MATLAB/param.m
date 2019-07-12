close all; clear all; clc
path = 'D:/ROMS_SIMULATIONS/peru02km/';
year= 2009:2011;
vtransform = 1;
ncname = dir([path '*.nc']);
ncload ([path,ncname(1).name],'lon_rho','lat_rho','mask_rho','h','temp');
dim2 = size(temp,2); dim3 = size(temp,3); dim4 = size(temp,4);
N = dim2;
ZM = [-1 -5 -10 -20 -30 -50 -75 -100]; % Profundidades a calcular
load ([path 'xy.txt']);
x = xy(:,1);
y = xy(:,2);

prenom1 = 'roms_avg_Y';
prenom2 = 'M';
prenom3 = '.newperushtopoP.nc';

% prenom1 = 'roms_avg_Y';
% prenom2 = 'M';
% prenom3 = '.AscatMerClim.nc';

get_Uclim
get_Vclim
get_Wclim
get_TEMPclim

dlmwrite([path 'zlevels.txt'],ZM')
