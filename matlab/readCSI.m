function [csi_sqr,csi_abs,csi_complex]=readCSI(file_name)
csi_trace = read_bf_file('csi_03_01/0.dat');
[m,n,d]=size(csi_trace)
plotCsi={};

% for i= 1:m
%     csi_entry = csi_trace{i};
%     csi = get_scaled_csi(csi_entry);
%     [ms,ns,ds]=size(csi);
%     tempCsi={};
%     for j=1:ds
%         csi_1=csi(1,1,j);
%         tmp=csi_1*csi_1;
%         tempCsi=[tempCsi;abs(csi_1)]   ;     
%     end
%     
%     plotCsi=[plotCsi;    tempCsi.'];
%     
%     
% end
% 
% 
% [mc,nc]=size(plotCsi)
% c=cell2mat(plotCsi);
% % x = linspace(1,mc,mc)
% % plot(x,c(:,1),x,c(:,2))
% % plot(x,c(:,1))
% avgCSI=[];
% m=50
% for i =1:mc
%     sum=m*c(i,30);
%     nm=m;
%     for j=1:m
%         if(i-j>0)
%             sum=sum+(m-j+1)*c(i-j,1);
%             nm=nm+(m-j+1);
%         end
%         
%     end
%     
%     sum=sum/nm;
%  
%     avgCSI=[avgCSI;sum];
%     
% end
% [mc,nc]=size(avgCSI)