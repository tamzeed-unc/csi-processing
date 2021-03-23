pca_comp=8;
% file_name='/Users/tamzeedislam/Documents/projects/wideo/dataset/csi/cp/lab_12_march_mahathir/walk_1/csi.dat'
% file_split_date=split(file_name, '/');
% char(file_split_date(10))
% % if(char(file_split_date(10))=='jan2')
% %     pca_comp=7;
% % end
% csi_stream_t=down_sample_func_read_csi(file_name);
% real_csi=abs(csi_stream_t);

figure(1)
plot(abs(real_csi(1,:)))


denoised_csi=func_denoise(real_csi.',1,100,6);
figure(2)
plot(denoised_csi(:,pca_comp))

denoised_csi_high_freq=func_denoise(real_csi.',40,100,6);
figure(3)
plot(denoised_csi_high_freq(:,pca_comp))
denoised_csi_high_freq=denoised_csi_high_freq(:,pca_comp);

diff_csi=diff(denoised_csi(:,pca_comp));
diff_csi=diff_csi(1000:end-1000);

figure(4)
plot(abs(diff_csi))

denoised_csi_high_freq_cut=denoised_csi_high_freq(1000:end-1000);

[peak_start,peak_end]=func_peak_detect(abs(diff_csi(1:end)).',.1);


% % spectrogram(denoised_csi_high_freq_cut(peak_start(1):peak_start(1)+1000), 64,[],[],100, 'yaxis')
file_name_split=split(file_name, '.')
time_stamp_file_name=strcat(char(file_name_split(1)),'.csv')
dlmwrite(char(time_stamp_file_name),peak_start,'delimiter',',')
peak_start=csvread(time_stamp_file_name);
[number_of_activities,m]= size(peak_start)

folder_name=strcat(char(file_name_split(1)),'/csi_segment')
status=mkdir(folder_name)
for i =1:m
    act_csi=denoised_csi_high_freq_cut(peak_start(i):peak_start(i)+1000);
    file_name_csi=strcat(folder_name,'/','csi_', int2str(i), '.csv')
    dlmwrite(file_name_csi,act_csi,'delimiter',',');
end