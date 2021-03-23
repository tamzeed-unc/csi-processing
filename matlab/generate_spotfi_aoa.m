%%%%%%%%%%%%%%%%%%%%
% % % % % % this file accepts csi index file for different positions <<fileID>>
% % % % % % outputs the cluster AoAs, plots and their properties such as tof, aoa variance etc
% % % % % % this file also needs ground truth AoA(optional) file <<groundTruth_file>>
% % % % % % outputs a csv file with ground truth aoa, aoa from cluster with minimum distance from ground truth, aoa selected by spotfi
%%%%%% dir= the directory you want your analzyed result
%%%%%%%%%%%%%%%%%%%%


clear all;
sd_enable=true;
only_cluster=true;

if(sd_enable==true)
    csi_stream_t=func_read_csi('/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/single.dat'); %This CSI file is a binary file
    fileID = '/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/obstacle/ground_truth_aoa,csi_index,timestamps/corresponding_csi_indices.csv';


    dir='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/obstacle/analysis/'
    groundTruth_file='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/sub_experiments/front_anchor_nodes/analysis/groundtruth_aoa.csv'
else
    csi_stream_t=func_read_csi('../../sample_data/raw_csi.dat');
    fileID = '../../sample_data/corresponding_csi_indices.csv';


    dir='../../sample_outputs/'
    groundTruth_file='../../ground_truth_aoa.csv'
end

%csi_streat_t is a 2D matrix; each row is for one packet; each row has 90 columns, first 30 is for rx1,tx1 (30 subcarriers); the next 30 is for rx2, tx1; next 30 is for rx3, tx1;
%actually, this is transposed. so, basically, each column is for one packet.

% output_aoa_file='/Volumes/SD1/EyeFiData/jul12/moving_single_multi_people_and_door/experiments/single/analysis2/aoa_zero_one_foot/demo.csv';
output_aoa_file=strcat(dir,'final_aoa.csv');
output_aoa_file=char(output_aoa_file);
A = csvread(fileID)
[mA,nA]=size(A) %mA contains number of rows in the index file, nA is 2 (since 2 columns)

mInd=1
fc = 5.63e9; % center frequency, we are operating at 5 GHz


M = 3;    % number of rx antennas
fs = 40e6; % channel bandwidth
c = 3e8;  % speed of light
d = 2.6e-2;  % distance between adjacent antennas in the linear antenna array
dTx = 2.6e-2; 
SubCarrInd = [-58,-54,-50,-46,-42,-38,-34,-30,-26,-22,-18,-14,-10,-6,-2,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58]; % WiFi subcarrier indices at which CSI is available
N = length(SubCarrInd); % number of subcarriers
subCarrSize = 128;  % total number fo
fgap = 312.5e3; % frequency gap in Hz between successive subcarriers in WiFi
lambda = c/fc;  % wavelength
T = 1; % number of transmitter antennas
AoAs=[];
ToFs=[];
array_total_count=[];
array_total_tof=[];
array_total_var_aoa=[];
array_total_var_tof=[];
Spotfi_AoA=[];

while(mInd<=mA)
    aoa1=[];
    aoa2=[];
    tof1=[];
    phase_pack=[];
    phase_pack2=[];
    phase_pack3=[];
    phase_san=[];
    phase_san2=[];
    phase_san3=[];
    for i=A(mInd,1):A(mInd,2) %for each row in the index file, interate start to end index
        A(mInd,1)
        A(mInd,2)
        csi_stream_single_pack=csi_stream_t(:,i); %get the 90 csi values of the ith packet

        sample_csi_trace = csi_stream_single_pack(1:90); %this is pretty much the same thing, but if there are multiple transimitters, it will take the first transmitter's values



    % % % % %     MUSIC algorithm requires estimating MUSIC spectrum in a grid. paramRange captures parameters for this grid
    % % % % %     For the following example, MUSIC spectrum is caluclated for 101 ToF (Time of flight) values spaced equally between -25 ns and 25 ns. MUSIC spectrum is calculated for for 101 AoA (Angle of Arrival) values between -90 and 90 degrees.
        paramRange = struct;
        paramRange.GridPts = [101 101 1]; % number of grid points in the format [number of grid points for ToF (Time of flight), number of grid points for angle of arrival (AoA), 1]
        paramRange.delayRange = [-50 50]*1e-9; % lowest and highest values to consider for ToF grid. 
        paramRange.angleRange = 90*[-1 1]; % lowest and values to consider for AoA grid.
        
        do_second_iter = 0; %This is for the second iteration, we do not do this
        paramRange.seconditerGridPts = [1 51 21 21];
        
        paramRange.K = floor(M/2)+1; % parameter related to smoothing.  %M is # of Rx
        paramRange.L = floor(N/2); % parameter related to smoothing.    %N is # of subcarriers
        paramRange.T = 1;
        paramRange.deltaRange = [0 0]; 

        maxRapIters = Inf;
        useNoise = 0;
        paramRange.generateAtot = 2;

    % %     ToF sanitization code (Algorithm 1 in SpotFi paper)
        csi_plot = reshape(sample_csi_trace, N, M);
        [PhsSlope, PhsCons] = removePhsSlope(csi_plot,M,SubCarrInd,N);
        ToMult = exp(1i* (-PhsSlope*repmat(SubCarrInd(:),1,M) - PhsCons*ones(N,M) ));
        csi_plot = csi_plot.*ToMult;
        relChannel_noSlope = reshape(csi_plot, N, M, T);
        sample_csi_trace_sanitized = relChannel_noSlope(:);

   

        % % % % % % % % 
        % % % % % % % % % 
    % % % 
    % % %     MUSIC algorithm for estimating angle of arrival
    % % %     aoaEstimateMatrix is (nComps x 2) matrix where nComps is the number of paths in the environment (which is 5 as below). First column is ToF in ns and second column is AoA in degrees as defined in SpotFi paper
        aoaEstimateMatrix = backscatterEstimationMusic(sample_csi_trace_sanitized, M, N, c, fc,...
                            T, fgap, SubCarrInd, d, paramRange, maxRapIters, useNoise, do_second_iter, ones(5))   
        tofEstimate = aoaEstimateMatrix(:,1); % ToF in nanoseconds% % figure()


        aoaEstomate = aoaEstimateMatrix(:,2) % AoA in degrees
        aoa1=[aoa1;aoaEstomate(:)]; %5 AoA per packet is appended 
        tof1=[tof1;tofEstimate(:)]; %5 ToF per packet is appended
% % %     aoa2=[aoa2;aoaEstomate(2)];
        
    end
    n_cluster=5; % number of clusters
    X=[aoa1.';tof1.']; %X has 2 rows: first row has AoA (5 AoA per packet); second row has ToF (5 ToF per packet)
    X=X.';
    
    
    idx = kmeans(X,n_cluster) %idx is a 1D matrix containing the cluster ID

    fig=figure;
    gscatter(X(:,1),X(:,2)+60,idx);
    figName=strcat(dir,'image');
    figName=strcat(figName,string(mInd));
    figName=strcat(figName,'.png')
    
    saveas(fig,char(figName));
    
    
    % figure()
    % hist(aoa1)
    X=[X.';idx.'];

    X=X.';
    [m,n]=size(X)
    total_count=[];
    total_tof=[];
    total_var_aoa=[];
    total_var_tof=[];
    mean_aoa=[];
    for i=1:n_cluster
        n_count=0;
        n_tof=0;
        n_var_aoa=[];
        n_var_tof=[];

        for j=1:m
            if(X(j,3)==i) %X(j,3) is cluster ID
                n_count=n_count+1;
                n_tof=n_tof+(X(j,2)+50); % ToF is measured from -50 to 50. So, we add 50 to get above 0
                n_var_aoa=[n_var_aoa;X(j,1)];
                n_var_tof=[n_var_tof;X(j,2)];

            end
        end
        total_count=[total_count;    n_count];
        n_tof=n_tof/n_count; %average ToF for this cluster
        total_tof=[total_tof;n_tof];
        total_var_aoa=[total_var_aoa;   var(n_var_aoa)];
        total_var_tof=[total_var_tof; var(n_var_tof)];
        mean_aoa=[mean_aoa;mean(n_var_aoa)];
    end

    %normalizing ToF, AoA
    total_count=total_count/max(total_count)
    total_tof=total_tof/max(total_tof)
    total_var_aoa=total_var_aoa/max(total_var_aoa)
    total_var_tof=total_var_tof/max(total_var_tof)

    score=[];
    for i=1:n_cluster
        score(i)=5*total_count(i)-2*abs(total_tof(i))-total_var_aoa(i)-(total_var_tof(i)); %total_count(i) is number of points in this cluster; the cluster gets penalized if the average ToF is higher, there is more variance in AoA, ToF of the cluster

    end
    [val, idx] = max(score)
    Spotfi_AoA=[Spotfi_AoA;    mean_aoa(idx)];
    AoAs=[AoAs;mean_aoa.'];
    array_total_count=[array_total_count;total_count.'];
    array_total_tof=[array_total_tof;total_tof.'];
    array_total_var_aoa=[array_total_var_aoa;total_var_aoa.'];
    array_total_var_tof=[array_total_var_tof;total_var_tof.'];
    
    mInd=mInd+1;
end
filenames={'cluster_aoas.csv','cluster_total_count.csv','cluster_tof.csv','cluster_var_aoa.csv','cluster_var_tof.csv'}
filenames=string(filenames)
[mf,nf]=size(filenames)
dirFileNames=[];
for i=1:nf
    strtemp=filenames(i);
    filename=strcat(dir,strtemp)
    dirFileNames=[dirFileNames;filename];
    
end
% dirFileNames(1)
% csvwrite(char(dirFileNames(1)),AoAs);
% csvwrite(char(dirFileNames(2)),array_total_count);
% csvwrite(char(dirFileNames(3)),array_total_tof);
% csvwrite(char(dirFileNames(4)),array_total_var_aoa);
% csvwrite(char(dirFileNames(5)),array_total_var_tof);



%%%%%%optional%%%%%
%%%%getting the aoa from the cluster that is close to ground truth
if(only_cluster==false)
    ground_truth = csvread(groundTruth_file)
    [mA,nA]=size(ground_truth)
    [r_aoa,c_aoa]=size(AoAs)
    selectAoAList=[];
    for k=1:mA
        selectAoA=1;
        minV=100000
        for j=1:c_aoa
            diff=abs(AoAs(k,j)-ground_truth(k))
            if(diff<minV)
                selectAoA=AoAs(k,j);
                minV=diff;
            end
        end
        selectAoAList=[selectAoAList;selectAoA];

    end
    selectAoAList
    csv_write_final=[ground_truth.'; selectAoAList.';Spotfi_AoA.'];
    csv_write_final=csv_write_final.';
    csv_header={'ground truth' 'min_dist AoA' 'Spotfi AoA'};

    fid = fopen(output_aoa_file, 'w') ;
    fprintf(fid, '%s,', csv_header{1,1:end-1}) ;
    fprintf(fid, '%s\n', csv_header{1,end}) ;
    fclose(fid) ;

    % filename=strcat(dir,'cluster_aoas.csv');
    dlmwrite(output_aoa_file,csv_write_final,'-append')
end
