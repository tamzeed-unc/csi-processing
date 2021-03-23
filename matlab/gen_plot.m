
pca_comp=2;
target_len=800; %gesture size
label = '/drink';
label_num=10;
folder_name='16-11-18'


thr=.02
check_done=2

if(check_done==0)
    
    file = dir(strcat('data/',folder_name,label,'/*.dat'));
% for file = files'
  

    csi_stream_t=func_read_csi(strcat('data/',folder_name,label,'/',file.name));
    real_csi=abs(csi_stream_t);
end

figure()
plot(abs(real_csi(1,:)))

noisy=abs(real_csi(1,:)).'
noisy_cut=noisy(4500:10000)
figure()
plot(noisy_cut)



denoised_csi=func_denoise(real_csi.',30,100,6);
figure()
plot(denoised_csi(:,pca_comp))

denoised_csi_high_freq_old=func_denoise(real_csi.',1,100,6);

denoised_csi_high_freq=denoised_csi_high_freq_old(:,pca_comp)


diff_csi_old=diff(denoised_csi(:,pca_comp));
diff_csi=diff_csi_old(100:end-100);
figure()
plot(abs(diff_csi))

denoised_csi_cut=denoised_csi_high_freq(4500:10000);
figure()
plot(denoised_csi_cut)




