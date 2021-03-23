function [peak_start,peak_end]=func_peak_detect(csi_stream,th)
%     
%     mean(csi_stream)
%     mode(csi_stream)
%     plot(csi_stream)

%     csi_stream=diff(csi_stream);
    gap=400;
    start_i=-1;
    end_i=-1;
    low_count=0;
    peak_start=[];
    peak_end=[];
    [m,n]=size(csi_stream)
    k_ind=1;
    csi_stream=abs(csi_stream);
    peaks=[];
%     for i=2:
%         if(csi_stream(i)>csi_stream(i-1)&csi_stream(i)>csi_stream(i+1))
%             peaks=[peaks;csi_stream(i)];
%             
%         end
%         
%     end
%     
%     mn=mean(peaks)
%     mode(peaks);
%     th=mn;
    
    for i=1:n
%         csi_stream(i)
%  s       low_count
        if(csi_stream(i)>th & start_i==-1)
            
            start_i=i
            low_count=0;          
        end
        if(csi_stream(i)>th & start_i~=-1)
            end_i=i;
            low_count=0;          
        end
        if(csi_stream(i)<th)
            
            low_count=low_count+1;
        end
        if(low_count>gap & start_i~=-1)
            low_count
            duration=end_i-start_i
            if(duration>500)
                peak_start(k_ind)=start_i;
                peak_end(k_ind)=end_i;
                k_ind=k_ind+1;
            end
            start_i=-1;
            end_i=-1;
            low_count=0;
      
            
        end
        
    end
    
    peak_start
    peak_end
end
