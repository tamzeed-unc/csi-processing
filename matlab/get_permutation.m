function [all_perm,perm_indices]=get_permutation(freq_y,n_samples,n_sources,n_freq,thr_nbr)

% n_samples=5;
% n_sources=2;
% n_freq=5;
% thr_nbr=3;
% 
% freq_y = zeros(n_samples, n_sources, n_freq);
% size(freq_y)
% freq_y

perm_mat=zeros(n_sources, n_freq);
size(perm_mat)

%initialize
for i =1:n_sources
    perm_mat(i,1)=i;
end

%maximize
max_cor=int32(intmin('int64'));
max_perm_ind=-1;
all_perm_base=linspace(1,n_sources,n_sources);
all_perm=perms(all_perm_base)
[mP,nP]=size(all_perm);
perm_indices=zeros(n_freq,1);
base_ind=-1;
for i=1:mP
    if all_perm(i,:)==all_perm_base
        base_ind=i;
        break
    end
end

%%%
perm_indices(1)=base_ind;


%%%changeXXXXXX
perm_indices(1)=1;



[mF,nF,dF]=size(freq_y);
vect_real=zeros(mF,nF,dF);
vect_real(:,1,1)=freq_y(:,2,1);
vect_real(:,2,1)=freq_y(:,1,1);



for f=2:n_freq
    %get the permutation here
    
    max_cor=int32(intmin('int64'));

    for p=1:mP
         sum_corr=0;
        
         for i=1:n_sources
            current_ind=all_perm(p,i);
            current_s=freq_y(:,current_ind,f);
%             nbr_s=freq_y(:,nbr_ind,g);
            [tempAbs,meanEnv]=avgEnvelope(f, vect_real, i);
%             size(tempAbs)
%             tempAbs=permute(meanEnv,[2 1]);
%             p
%             f
%             i
            cor=corrcoef(abs(current_s),meanEnv.');
            sum_corr=sum_corr+ cor(1,2);
         end
         if(sum_corr>max_cor)
            max_cor=sum_corr;
            max_perm_ind=p;
         end
           
               
    end 
    current_ind=all_perm(max_perm_ind,:);
    for k=1:n_sources
%         fprintf('here %d %d %d\n',f,k,current_ind(k));
       
        vect_real(:,k,f)=freq_y(:,current_ind(k),f);
    end
    

       
    
    perm_indices(f)=max_perm_ind;    
    end
perm_indices;
end

%%%%neighbour correlation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for f=2:n_freq
%     %get the permutation here
%     max_cor=int32(intmin('int64'));
%     for p=1:mP
%         sum_corr=0;
%         for gi=1:thr_nbr
%             if(f-gi>0)
%                  for i=1:n_sources
%                     %a=freq_y(:,permutaed index,f);
%                     g=f-gi;
%                    
%                     current_ind=all_perm(p,i);
%                     nbr_ind=all_perm(perm_indices(g),i);
%                     current_s=freq_y(:,current_ind,f);
%                     nbr_s=freq_y(:,nbr_ind,g);
%                     if(f==15)
%                         current_ind
%                         nbr_ind
%                         cor=corrcoef(abs(current_s),abs(nbr_s))
%                     end
%                     cor=corrcoef(abs(current_s),abs(nbr_s));
%                     sum_corr=sum_corr+ cor(1,2);
%                 end
%             end
%                
%         end 
% %         if(f==15)
% %             p 
% %             sum_corr
% %         end
%         
%         if(sum_corr>max_cor)
%             max_cor=sum_corr;
%             max_perm_ind=p;
%         end
%     end
%     perm_indices(f)=max_perm_ind;    
% end
% perm_indices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



