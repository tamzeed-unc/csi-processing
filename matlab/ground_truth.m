clear all
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number 1 mic%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %#source
n_source=2;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%making convoluted
% % % [ym1,fs1]=audioread('audio/tamz.wav');
% % % [m1,n1]=size(ym1);
% % % 
% % % [yh1,fs1]=audioread('audio/rin.wav');
% % % [m2,n2]=size(yh1);
% % % yh1=yh1(1:m1);
% % % fs=fs1;
% % % 
% % % xlen = length(yh1);                   
% % % t = (0:xlen-1)/fs;                  
% % 
% % % % define the analysis and synthesis parameters
% % % wlen = 1024;
% % % hop = 256;
% % % nfft = 10*wlen;
% % 
% % 
% % % 
% % % % freq_yh1=spectrogram(yh1);
% % % % freq_ym1=spectrogram(ym1);
% % % [freq_yh1, f, t_stft] = stft(yh1, wlen, hop, nfft, fs);
% % % [freq_ym1, f, t_stft] = stft(ym1, wlen, hop, nfft, fs);
% % % 
% % % 
% % % S1=0.8*yh1+0.3*ym1;
% % % S2=0.4*yh1+0.7*ym1;
% % % 
% % % % S1=ym1;
% % % % S2=ym1;
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
yr1=audioread('audio/source1.wav');
yr2=audioread('audio/source2.wav');
yr1=yr1(:,1);
yr2=yr2(:,1);
yr1=downsample(yr1,11);
yr2=downsample(yr2,11);


%%%%REAL COLVOLUTED
[S,fs1]=audioread('audio/mixing.wav');
% 
% 
% 
size(S)
S=downsample(S,11);


fs=fs1/11;
S1=S(:,1);
S2=S(:,2);
[m1,n1]=size(S1);
% 
xlen = length(S1);                   
t = (0:xlen-1)/fs;                  

% define the analysis and synthesis parameters
wlen = 2048;
hop = wlen/2;
nfft = wlen*10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[freq_yr1, f, t_stft] = stft(yr1, wlen, hop, nfft, fs);
[freq_yr2, f, t_stft] = stft(yr2, wlen, hop, nfft, fs);


[freq_s1, f, t_stft] = stft(S1, wlen, hop, nfft, fs);
[freq_s2, f, t_stft] = stft(S2, wlen, hop, nfft, fs);

[ms1,ns1]=size(freq_s1)
size(freq_yr1)
%ms1=number of freq
%ns1= number of sample

freq_y = zeros(ns1, 2, ms1);
freq_real = zeros(ns1, 2, ms1);
real_p=zeros(ms1);
cntB=0;
corInd=[];
for i=1:ms1
    f_s1=freq_s1(i,:);
    f_s2=freq_s2(i,:);
    S=[f_s1;f_s2];
    M=S;
    arguments = {}; 

    arguments = {arguments{:}, 'verbose', true}; % execute in verbose mode

    [X, H, iter, W] = robustica(M, arguments);
    freq_y(:,1,i)=X(1,:);
    freq_y(:,2,i)=X(2,:);
    
    
    
%     if (i==100)
% 
        YF1=freq_yr1(i,:);
        YF2=freq_yr2(i,:);
        
%         if(i==100)
%             figure(1)
%             plot(abs(YF1))
%             figure(2)
%             plot(abs(YF2))
%             figure(3)
%             plot(abs(X(1,:)))
%             figure(4)
%             plot(abs(X(2,:)))
%             size(abs(YF1))
%             size(abs(X(1,:)))
%         end
        cor1=corrcoef(abs(YF1),abs(X(1,:)))
        cor2=corrcoef(abs(YF2),abs(X(1,:)))
        if(cor1(1,2)<cor2(1,2))
            
            real_p(i)=1;
        else
           
            real_p(i)=2;
            
        end
        if(cor1(1,2)<.5)
            if(cor2(1,2)<.5)
                figure(1)
                plot(abs(YF1))
                figure(2)
                plot(abs(YF2))
                figure(3)
                plot(abs(X(1,:)))
                figure(4)
                plot(abs(X(2,:)))
                size(abs(YF1))
                size(abs(X(1,:)))
                cor1
                cor2
                corInd=[corInd;i];
                
                cntB=cntB+1;
                break;
            end
                
        end
        
% %         
% %         break;
% %     end
% %     
% % 
% %         if(i==3000)
% %             break;
% %         end
% %     
end
cntB
corInd
% 
% % % [all_perm,perm_indices]=get_permutation(freq_y,ns1,2,ms1,8);
% % % 
% % % 
 mP=size(real_p);
% % cnt=0
% % for i=1:ms1
% %     fprintf('%d %d %d\n',perm_indices(i),real_p(i),i);
% %     if(perm_indices(i)~=real_p(i))
% % %         perm_indices(i)
% % %         real_p(i)
% % %         fprintf('%d %d\n',perm_indices(i),real_p(i));
% %         cnt=cnt+1;
% % %         i
% %     end
% % end
% % cnt
% 
% 
% 
% 
% n_sources=2;
% all_perm_base=linspace(1,n_sources,n_sources);
% all_perm=perms(all_perm_base)
% for i=1:mP
%     perm_ind_row=all_perm(real_p(i),:);
%     for j=1:n_sources
%         freq_real(:,j,i)=freq_y(:,perm_ind_row(j),i);
%     end   
% end
% size(freq_real(:,j,:))
% % 
% % % C = reshape(C,[],size(freq_real(:,j,:),2),1);
% % % size(C)
% n_source=2;
% t_y=zeros(260352,n_source);
% for i=1:n_source
%     
%     C = freq_real(:,i,:);
%     C=permute(C,[3 1 2]);
%     % size(C)
%     C=C(:,:,1);
%     size(C)
%     [x_istft, t_istft] = istft(C, wlen, hop, nfft, fs);
%     size(x_istft)
%     t_y(:,i)=x_istft.';
%  
%     size(t_y(:,i))
%   
%     
% end
% 
% figure()
% plot(S1)
% size(S1)
% figure()
% plot(S2)
% figure()
% plot(t_y(:,1))
% figure()
% plot(t_y(:,2))
% figure()
% plot(yr2)
% figure()
% plot(yr1)
% 
% 
% 
% soundsc(t_y(:,2),44100)
% % soundsc(t_y(:,1),44100)
% % r = snr(t_y(:,1),t_y(:,2))
% % r = snr(t_y(:,2),t_y(:,1))
% 
% 
% 
% r = snr(S1,yr2)
% r = snr(t_y(:,1),yr1(1:260096))
% % 
% % % 
% % % 
% % % 
% % % 
