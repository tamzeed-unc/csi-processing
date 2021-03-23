% % % This code accepts csi index file for different positions <<fileID>>
% % % and ground truth for locations at those indexes <<groundTruth_file>>
% % % outputs a csv file with the estimated error for wifi rssi log model distance estimation.



clear all;
sd_enable=false;
if(sd_enable==true)
    rssi_stream_t=func_read_rssi('/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/single.dat');
    fileID = '/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/aoa_zero_one_foot/ground_truth_aoa,csi_index,timestamps/jul12_single_aoa0_1_foot_index_matlab.csv';
    output_dir='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/front_anchor_nodes/analysis/';
    groundTruth_file='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/aoa_zero_one_foot/ground_truth_aoa,csi_index,timestamps/groundtruth_position.csv'
else
    rssi_stream_t=func_read_rssi('../../sample_data/raw_csi.dat');
    fileID = '../../sample_data/corresponding_csi_indices.csv';
    output_dir='../../sample_outputs/';
    groundTruth_file='../../corresponding_ground_truth_locations.csv'
end


% output_aoa_file='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/analysis2/aoa_zero_one_foot/demo.csv';
% output_aoa_file=strcat(output_dir,'wifi_final_dist.csv');
% output_aoa_file=char(output_aoa_file);
A = csvread(fileID)
[mA,nA]=size(A)

mInd=1
mean_a=[];
mean_b=[];
mean_c=[];
while(mInd<=mA)
    
    start_ind=A(mInd,1);
    end_ind=A(mInd,2);
    rssi_a=rssi_stream_t(1,:);
    mean_a=[mean_a;mean(rssi_a(start_ind:end_ind))];
    
    rssi_b=rssi_stream_t(2,:);
    mean_b=[mean_b;mean(rssi_b(start_ind:end_ind))];
    
    rssi_c=rssi_stream_t(3,:);
    mean_c=[mean_c;mean(rssi_c(start_ind:end_ind))];
    
    mInd=mInd+1;
    
end
[sz1,sz2]=size(mean_a);
groundTruth_file
ground_truth=csvread(groundTruth_file);
Rss_0=-13.824;
environment=2;
r_0=3;
total_error=0;
total_sample=0;
err_array=[];
for i=1:sz1
    Rss_i=-mean_b(i);
    num=(Rss_0-Rss_i);
    denom=10*environment;
    power_term=num/denom;
    r=r_0*power(10,power_term)
    ground_truth(i,1)
    ground_truth(i,2)
    
    ground_truth_distance=sqrt(ground_truth(i,1)*ground_truth(i,1)+ground_truth(i,2)*ground_truth(i,2))
    err=abs(ground_truth_distance-r);
    err_array=[err_array;err];
    total_sample=total_sample+1;
    total_error=total_error+err;
    

end
mean_error=total_error/total_sample
output_file=strcat(output_dir,'/mean_wifi_distance_error.csv');
output_file=char(output_file);
dlmwrite(output_file,mean_error,'delimiter',',','-append');

median(err_array)
output_file=strcat(output_dir,'/median_wifi_distance_error.csv');
output_file=char(output_file);
dlmwrite(output_file,median(err_array),'delimiter',',','-append');


