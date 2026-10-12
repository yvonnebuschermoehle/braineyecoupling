%% DOCUMENTATION
% This script should be run on the preprocessed data (see input data below)
% and computes: 
    % (1) The beamformer filters for all source grid points
    % (2) the main timeseries per parcel 
    % (3) the coherence between the eye measures and parcel timeseries 

% input (always as fieldtrip structures)
    % hdm           individual headmodel (e.g. singleshell) 
    % trialData     preprocessed MEG data in rampwise trials without ICA
    % trialDataICA  preprocessed MEG data in rampwise trials with ICA
    % sm            individual sourcemodel
    % leadfield     individual leadfield
    % eyeData       eyelink data in rampwise trials (synchronized to
    %               trialData) containing eye measures of interest (here:
    %               eye velocity and stimulus position)
    % fi            indices of source grid points belonging to some parcel
    % fiParcel      indicies of source grid points per parcel
    % hcp_int       HCP interpolated on sourcegrid 
% output 
    % coherence     one coherence structure per participant and set of
    %               ramps (e.g. rightward ramps)  

org.pathinput = ''; % path to input files    
org.pathresults = ''; % path to store coherence results 
Nsub = 22; % number of participants 

%% load general files
load([pathinput, 'fi.mat']); 
load([pathinput, 'fiParcel.mat']); 
load([pathinput, 'hcp_int.mat']); 

for isub = 1:Nsub

%% load individual data
    load([pathinput, num2str(isub), '_hdm.mat']); 
    load([pathinput, num2str(isub), '_trialData.mat']); 
    load([pathinput, num2str(isub), '_trialDataICA.mat']); 
    load([pathinput, num2str(isub), '_sm.mat']); 
    load([pathinput, num2str(isub), '_leadfield.mat']); 
    load([pathinput, num2str(isub), '_eyeData.mat']); 

%% INVERSE PROBLEM/ SOURCE ANALYSIS

    cfg             = []; 
    cfg.channel     = {'MEG'}; 
	cfg.covariance  = 'yes'; 
    avg_MEG         = ft_timelockanalysis(cfg, trialData);

	% compute beamformer filters (on all trials) based on data without ICA
	cfg							= [];
	cfg.channel					= {'MEG'};
	cfg.headmodel				= hdm;
	cfg.grad					= trialData.grad;
	cfg.method					= 'lcmv';
	cfg.lcmv.lambda				= '5%';
	cfg.lcmv.keepfilter			= 'yes';
	cfg.lcmv.fixedori			= 'no';
	cfg.lcmv.weightnorm			= 'unitnoisegain'; 
	cfg.sourcemodel.pos			= sm.pos(fi{1, 1},:);
	cfg.sourcemodel.leadfield	= leadfield.leadfield;
	source						= ft_sourceanalysis(cfg, avg_MEG);

%% EYTRACT MAIN TIME SERIES PER PARCEL

	load([org.pathresults_hdm_res,'source3.mat']); % loads beamformer filters based on NOT ICA-cleaned data

    % iterate over all parcels pd hcp atlas
	lastParcel = 0; 
	for itarg = 1:length(hcp_int.tissuelabel)

		disp(itarg)
		fitmp = fiParcel{1,itarg}; 

		% concatenate beamformer filters for Parcel 
		bf = cat(1, source.avg.filter{lastParcel+1:lastParcel+length(fitmp)});
	    
        % apply 3d bf-filter to trialData (with ICA)
		for itrial = 1:length(trialDataICA.trial)
			source_ts.trial{itrial} = bf * trialDataICA.trial{itrial}(1:length(trialDataICA.label),:); 
		end 
	    
        % concatenate all trials in time dimension 
		source_ts_all = cat(2, source_ts.trial{:}); 
	
		% compute SVD on concatenated source timeseries
		[u,~,~] = svd(source_ts_all, 'econ');
	
		parcel_ts = [];
		parcel_ts.label = hcp_int.tissuelabel(itarg); 
		parcel_ts.time = trialDataICA.time;
		
        % compute trialwise timeseries with strongest maximum eigenvalue
        % characterizing the entire parcel
        for i=1:length(trialDataICA.trial)
			parcel_ts.trial{i} = u(:,1)' * bf * trialDataICA.trial{i}(1:length(trialDataICA.label),:); 
        end
        
        % append this parcel to all other parcels
		if itarg == 1
			parcel_ts_all = parcel_ts; 
			parcel_ts_all.sampleinfo = trialDataICA.sampleinfo; 
		else
			cfg			= []; 
			parcel_ts_all	= ft_appenddata(cfg, parcel_ts_all, parcel_ts); 
		end 

		lastParcel = lastParcel+length(fitmp); 
	end 

%% combine data to final data structures

	% concatenate data (eye channels and source timeseries in same data
    % structure)
	cfg = []; 
	combData = ft_appenddata(cfg, eyeData, parcel_ts_all); 
	combData.sampleinfo = trialDataICA.sampleinfo; 

	% define leftward ramps
	cfg = [];
	cfg.latency = [combData.time{1}(1) combData.time{1}(954)]; 
	segData1 = ft_selectdata(cfg, combData); 
    
    % define rightward ramps
	cfg = [];
	cfg.latency = [combData.time{1}(955) combData.time{1}(1908)]; 
	segData2 = ft_selectdata(cfg, combData); 

	% Unify timelines in order to combine trials as wished
	segData1.time = segData2.time; 
	segData1.sampleinfo = segData2.sampleinfo; 

	cfg = []; 
	segData = ft_appenddata(cfg, segData1, segData2); 
    
    % flag trials to 
	segflag = [ones(length(combData.trial), 1); 2*ones(length(combData.trial), 1)];

    for iseg = 1:4 % iterate over different ramptypes

        switch iseg
		    case 1 % leftward ramps
			    trl = find(segflag == 1); 
			    seg_str = 'leftramps'; 
		    case 2 % rightward ramps
			    trl = find(segflag == 2);
			    seg_str = 'rightramps'; 
		    case 3 % all ramps
			    trl = 'all'; 
			    seg_str = 'all'; 
            case 4 % half of all trials (every second ramp)
			    trl = 1:2:length(segflag); 
			    seg_str = 'all_half'; 
        end 
        
%% Coherence analysis

		% compute freqeuncy spectrum
		cfg				= [];
		cfg.output		= 'fourier';
		cfg.method		= 'mtmfft';
		cfg.trials		= 'all';        % include all valid trials
		cfg.taper		= 'hanning'; 
		cfg.foilim		= [0 40]; 
		cfg.keeptrials	= 'yes'; 
		cfg.channel		= 'all';
		cfg.pad			= 'nextpow2';
		freq			= ft_freqanalysis(cfg, segData);

		cfg = []; 
		cfg.channel = 'all'; 
		cfg.channelcmb = {}; 
        for i = 1:length(eyeData.label)
			channelcmb = [i*ones(230, 1) (length(eyeData.label)+1:length(eyeData.label)+230)']; 
			cfg.channelcmb = cat(1, cfg.channelcmb, combData.label(channelcmb)); 
        end
		cfg.method = 'coh';
		coherence = ft_connectivityanalysis(cfg, freq);

        % save coherence data structure
	    save([org.pathresults, num2str(sub), '_/coherence', seg_str,'.mat'], 'coherence');

    end 
end 