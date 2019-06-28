[LAT,LON] = meshgrid(-88:4:88,2:4:358);
LAT=LAT';
LON=LON';
MASK = load('glo_4deg.maskorig_ascii');
MASK85 = MASK;
MASK85(LAT>85) = 0;

write_ww3file(['glo_4deg.mask85_ascii'],MASK85);
