% % % % 
% clear all;
% csi_stream_t=func_read_csi('data/lab/jul2/pixel/c_n_h_p_aoa_0.dat');
csi_stream_single_pack=csi_stream_t(:,4);

figure()
% plot(angle(csi_stream_single_pack(1:30)))
% 
% figure()
% plot(angle(csi_stream_single_pack(31:60)))
% 
% figure()
% plot(angle(csi_stream_single_pack(61:90)))
index=linspace(1,30,30);
figure()
plot(index,unwrap(angle(csi_stream_single_pack(1:30))),'b',index,unwrap(angle(csi_stream_single_pack(31:60))),'r',index,unwrap(angle(csi_stream_single_pack(61:90))),'k')

rel_1_2_all=[];


for i=1:30
    rel_1_2=angle((csi_stream_single_pack(i:i)*conj(csi_stream_single_pack(30+i:30+i))));
    rel_1_2_all=[rel_1_2_all;rel_1_2];
end
figure()
plot(rel_1_2_all)

rel_2_3_all=[];
for i=31:60
    rel_1_2=angle((csi_stream_single_pack(30+i:30+i)*conj(csi_stream_single_pack(i:i))));
    rel_2_3_all=[rel_2_3_all;rel_1_2];
end
figure()
plot(rel_2_3_all)
figure()
plot(index,unwrap(rel_1_2_all),'b',index,unwrap( rel_2_3_all),'k')
% 
% %%%calculating relative phase between rx1 rx2 for all packets for one
% %%%subcarrier
% ret=[];
% for i=1:300
%     csi_stream_single_pack=csi_stream_t(:,i);
% %     rel_1_2=angle((csi_stream_single_pack(31:31)*conj(csi_stream_single_pack(61:61))));
%     rel_1_2=angle(csi_stream_single_pack(1:1));
%     ret=[ret;rel_1_2];
%    
% end
% figure()
% plot(unwrap(ret))
% figure()
% plot((ret))
% 



