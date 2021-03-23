
%Written by Tamzeed

function [csi_streams]=func_read_csi(fileName) 
csi_trace = read_bf_file(fileName); %read the binary file of CSI values
[m,n,d]=size(csi_trace); %m = # of packets, n = # of transmitters, d = # of subcarriers
plotCsi=[];
plotCsi_180=[];
plotCsi_270=[];
% get_scaled_csi(csi_entry)
cnt=0;
for i= 1:m
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry); %given from Intel
    %%%% Ntx×Nrx×30
    [ms,ns,ds]=size(csi); %ms = # of transmitters, ns = # of receivers, ds = # of subcarriers
%     if(ms==1)
%         cnt=cnt+1;
%     else
 %%%%%%%30*Nrx*Ntx
        B = permute((csi),[3 2 1]); %third index becomes first, first index becomes third
%         size(B);
        B =B(:);  %flattening out, now 1D array
%         B=abs(B);
        %%%1:30=rx1,tx1  %first 30 values give us rx1, tx1
        %%%31:60=rx2,tx1 % second 30 values give us rx2, tx1
        %%%61:90=rx3,tx1
        %%%91:120=rx1,tx2
        %%%%.....
%         i
        %%%%%%%
%         [m,n]=size( B.');
%         size(plotCsi)
%         if(n==90)
%             plotCsi_270=[plotCsi_270;    B.'];
%         end
%          if(n==180)
%             plotCsi_180=[plotCsi_180;    B.'];
%         end
        B=B(1:90);
        plotCsi_180=[plotCsi_180;    B.'];

        
    end
    

    
% end
cnt

[s_270,m]=size(plotCsi_270)
[s_180,n]=size(plotCsi_180)
if(s_270>s_180)
    plotCsi=plotCsi_270.';
end
if(s_180>s_270)
    plotCsi=plotCsi_180.';
end
csi_streams=plotCsi;

end