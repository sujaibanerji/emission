clc;
clear all;
awb = ncread('ECLIPSE_V6b_CLE_base_SO2.nc', 'emis_awb');
lat = ncread('ECLIPSE_V6b_CLE_base_SO2.nc', 'lat');
lon = ncread('ECLIPSE_V6b_CLE_base_SO2.nc', 'lon');
td = ncread('ECLIPSEv5_monthly_patterns.nc', 'agr_awb');
LAT = ncread('ECLIPSEv5_monthly_patterns.nc', 'lat');
LON = ncread('ECLIPSEv5_monthly_patterns.nc', 'lon');
Awb_2018 = ncread('edgar_HTAPv3_2018_SO2.nc', 'HTAPv3_8_1_Agricultural_waste_burning');
Lat = ncread('edgar_HTAPv3_2018_SO2.nc', 'lat');
Lon = ncread('edgar_HTAPv3_2018_SO2.nc', 'lon');
td_jf = td(:, :, 1:2);
td_jf_mean = nanmean(td_jf, 3);
awb_2015 = awb(:, :, 6);
awb_2020 = awb(:, :, 7);
awb_2025 = awb(:, :, 8);
Awb_per_year = (((awb_2020.*td_jf_mean) - (awb_2015.*td_jf_mean))./(5));
Awb_per_year_transpose = Awb_per_year'; %%%[conversion fromm 360x720 to 720x360]
[lat2,lon2] = cdtgrid(0.1);
Awb_per_year_interp = interp2(lon, lat, Awb_per_year_transpose, lon2, lat2);
lat3 = lat2(:, 1); %% storing lat information of the new mesh in line 20
lon3 = lon2(1, :); %% storing lon information of the new mesh in line 20
Awb_per_year_interpwcu = ((Awb_per_year_interp.*1000000)/3.154*10000000*100000000); %%[unit conversion kiloton/grid/year to kgm-2sec-1],wcu=withcorrectunits
Awb_per_year_interpwcutranspose = Awb_per_year_interpwcu';
Awb_jf_2018 = Awb_2018(:, :, 1:2);
Awb_jf_2018_mean = nanmean(Awb_jf_2018, 3);
Awb_jf_2018_wcu = ((Awb_jf_2018_mean.*1000)/(7948800*100000000));%%[unit conversion Megagram/grid/month to kgm-2sec-1]
Awb_jf_2020 = ((Awb_jf_2018_wcu) + (2*Awb_per_year_interpwcutranspose));
Awb_jf_2020_transpose = Awb_jf_2020';
Awb_jf_per_year2 = (((awb_2025.*td_jf_mean) - (awb_2020.*td_jf_mean))/(5));%%emission factor between 2020 and 2025
Awb_jf_per_year2transpose = Awb_jf_per_year2';
Awb_jf_per_year2interp = interp2(lon, lat, Awb_jf_per_year2transpose, lon2, lat2);%%regridding 50x50 to 10x10
Awb_jf_per_year2interpwcu = ((Awb_jf_per_year2interp.*1000000)/3.154*10000000*100000000);%%[unit conversion kiloton/grid/year to kgm-2sec-1]
Awb_jf_per_year2_interpwcutranspose = Awb_jf_per_year2interpwcu';
Awb_jf_2024 = ((Awb_jf_2020) + (4*Awb_jf_per_year2_interpwcutranspose));
Awb_jf_2024_transpose = Awb_jf_2024';

figure;
bottom=0;
top=10^16;
colormap(jet);
[X,Y]=meshgrid(lon3, lat3);
h1=pcolor(X, Y, (Awb_jf_2024_transpose));
set(h1,'EdgeColor','none')
set(gca,'Color','w')
caxis manual
caxis([bottom top]);
shading interp;
hold on;
geoshow('C:\Users\abc\Desktop\matlab\world_map_10_01_17.shp','Color','k','linewidth',2);
title('SO_2 from AWB for EDGAR JF 2024 in kg m^{-2} s^{-1}','fontsize',14,'fontweight','bold');
axis([67.5 97.5 7.5 37.5])
set(gca,'XTick',67.5:5:97.5,'fontweight','bold','fontsize',14)
set(gca,'YTick',7.5:5:37.5,'fontweight','bold','fontsize',14)
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
colorbar('Ticks',[0 1*10^15 2*10^15 3*10^15 4*10^15 5*10^15 6*10^15 7*10^15 8*10^15 9*10^15 10^16]);
cbarrow('up');