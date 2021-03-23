## generate_spotfi_aoa.m : 
    * this file accepts csi index file for different positions <<fileID>>
    * outputs the cluster AoAs, plots and their properties such as tof, aoa variance etc
    * this file also needs ground truth AoA(optional) file <<groundTruth_file>>
    * outputs a csv file with ground truth aoa, aoa from cluster with minimum distance from ground truth, aoa selected by spotfi

## bosch_spotfi.m : 
    * this file accepts a csi.dat file and outputs the aoa for the whole file's csi

## measure_log_distance.m : 
    *This code accepts csi index file for different positions (fileID) and ground truth for locations at those indexes (groundTruth_file)and outputs a csv file with the estimated error for wifi rssi log model distance estimation.


##  RAPMusicGridMaxBackscatter.m: 
    *This code gets the aoa and tof using Music

##  func_denoise.m: 
    *Low pass filtering csi

## func_read_csi.m: 
    *read csi of the 1st tx antenna to 3 rx antenna. Outputs a 90x1 csi vector

## func_read_csi.m: 
    *outputs the three rx antennas rssi of the packets.

## func_rssi_reader.m : 
    *helper function for func_read_csi.m. It gets the rssi out of the binary file

## func_spotfi_read_csi.m : 
    *reader function to get csi streams for each rx antenna in separate vectors.




