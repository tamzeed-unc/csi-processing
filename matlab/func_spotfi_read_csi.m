function [csi_streams1,csi_streams2,csi_streams3]=func_spotfi_read_csi(fileName)
csi_trace = read_bf_file(fileName);
[m,n,d]=size(csi_trace)
plotCsi1=[];
plotCsi2=[];
plotCsi3=[];
% get_scaled_csi(csi_entry)
cnt=0;
for i= 1:m
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry);
    %%%% Ntx×Nrx×30
    [ms,ns,ds]=size(csi);
    
       rcv1=csi(1,1,:);
       plotCsi1=[plotCsi1;    rcv1(:).'];
       rcv2=csi(1,2,:);
       plotCsi2=[plotCsi2;    rcv2(:).'];
       rcv3=csi(1,3,:);
       plotCsi3=[plotCsi3;    rcv3(:).'];
       

        

    
end
cnt

% size(plotCsi);
csi_streams1=plotCsi1.';
csi_streams2=plotCsi2.';
csi_streams3=plotCsi3.';

end