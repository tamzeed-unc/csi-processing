pca_comp=5;
file_name='/Users/tamzeedislam/Documents/projects/wideo/dataset/csi/cp/lab_12_march_mahathir/wave_1/csi.dat'
csi_stream_t=down_sample_func_read_csi(file_name);
real_csi=abs(csi_stream_t);

figure(1)
plot(abs(real_csi(1,:)))


denoised_csi=func_denoise(real_csi.',1,100,6);
figure(2)
plot(denoised_csi(:,pca_comp))

denoised_csi_high_freq=func_denoise(real_csi.',40,100,6);
figure(3)
plot(denoised_csi_high_freq(:,pca_comp))
denoised_csi_high_freq=denoised_csi_high_freq(:,pca_comp);

% diff_csi=diff(abs(real_csi(1,:)))
diff_csi=diff(denoised_csi(:,pca_comp));
diff_csi=diff_csi(1000:end-1000);
figure(4)
plot(abs(diff_csi))


figure(5)
plot(abs(real_csi(:,:)))

[peak_start,peak_end]=func_peak_detect(abs(diff_csi(1:end)).',.25);
denoised_csi_high_freq_cut=denoised_csi_high_freq(1000:end-1000);

% % spectrogram(denoised_csi_high_freq_cut(peak_start(1):peak_start(1)+1000), 64,[],[],100, 'yaxis')
% file_name_split=split(file_name, '.')
% time_stamp_file_name=strcat(file_name_split(1),'.csv')
% dlmwrite(char(time_stamp_file_name),peak_start,'delimiter',',')
