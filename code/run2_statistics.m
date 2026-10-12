%% DOCUMENTATION 
% This script computes the statistics for the coherence values over all
% participants. Specifically, it 
    % (1) loads coherence for both tested conditions and all subjects (we use directed ramps vs
    %     mixed ramps)
    % (2) computes statistics using ft_freqstatistics

% input
    % coherence   connectivity structure 

%% Configuration

org.pathinput       = ''; % path to coherence results from script
org.pathresults     = ''; % path to store statistic results
Nsub                = 22; 

allsegments = {'leftramps' 'rightramps' 'all_half' 'all'}; 
allcond = {'vel', 'stimulus'}; 

%% Compute statistics
for isegment = 1:2 % 1=leftramps; 2=rightramps
    for icond = 1:2 % 1=vel; 2=stim
        
	    cond = allcond{icond};
        segment = allsegments{isegment}; 
    
	    isub = 1; dat1 = cell(1,Nsub); dat2 = cell(1,Nsub); 
    
	    for sub = 1:Nsub 
	    
		    subject					= ID_all{sub};
	    
		    % load "null" data & rename (here: all_half ramps aka "mixed
            % ramps")
		    load([org.pathinput, num2str(sub), '_coherence_all_half_raw.mat']); 
            null = coherence; clear coherence; 
    
		    % load data (here leftward or rightward ramps)
		    load([org.pathinput, num2str(sub), '_coherence_', segment, '_raw.mat'])
		    data = coherence; clear coherence; 
    
		    idx_cond1 = find(strcmp(null.labelcmb, cond)); % null data
		    idx_cond2 = find(strcmp(data.labelcmb, cond)); % real data
	    
            %% prepare data structures for ft_freqstatistics
		    conn					= null; 
		    conn					= rmfield(conn, 'labelcmb'); 
		    conn					= rmfield(conn, 'cohspctrm'); 
		    conn.cohspctrm			= null.cohspctrm(idx_cond1,:); 
		    conn.label				= null.labelcmb(idx_cond1,2); 
		    conn.dimord				= 'chan_freq'; 
		    dat1{isub}				= conn; clear conn; 
	    
		    conn					= data; 
		    conn					= rmfield(conn, 'labelcmb'); 
		    conn					= rmfield(conn, 'cohspctrm'); 
		    conn.cohspctrm			= data.cohspctrm(idx_cond2,:); 
		    conn.label				= data.labelcmb(idx_cond2,2); 
		    conn.dimord				= 'chan_freq'; 
		    dat2{isub}				= conn;
    
		    isub = isub +1; 
	    end 
    
	    cfg					= []; 
	    cfg.foilim			= [0 40]; 
	    cfg.keepindividual	= 'yes'; 
	    cfg.parameter		= 'cohspctrm'; 
	    conn_GA1 = ft_freqgrandaverage(cfg, dat1{1}, dat1{2}, dat1{3}, dat1{4}, dat1{5}, dat1{6}, dat1{7}, dat1{8}, dat1{9}, dat1{10}, ...
		    dat1{11}, dat1{12}, dat1{13}, dat1{14}, dat1{15}, dat1{16}, dat1{17}, dat1{18}, dat1{19}, dat1{20}, dat1{21},dat1{22}); 
	    
	    cfg					= []; 
        cfg.foilim			= [0 40]; 
	    cfg.keepindividual	= 'yes'; 
	    cfg.parameter		= 'cohspctrm'; 
	    conn_GA2 = ft_freqgrandaverage(cfg, dat2{1}, dat2{2}, dat2{3}, dat2{4}, dat2{5}, dat2{6}, dat2{7}, dat2{8}, dat2{9}, dat2{10}, ...
			    dat2{11}, dat2{12}, dat2{13}, dat2{14}, dat2{15}, dat2{16}, dat2{17}, dat2{18}, dat2{19}, dat2{20}, dat2{21},dat2{22}); 
	    
	    % Code JG
	    nsubj = size(conn_GA1.cohspctrm, 1);
        
	    cfg						= [];
	    cfg.method				= 'montecarlo';
	    cfg.frequency			= [0 20]; 
	    cfg.statistic			= 'ft_statfun_depsamplesT';
	    cfg.correctm			= 'cluster'; 
	    cfg.parameter			= 'cohspctrm';
	    cfg.alpha				= 0.05;
	    cfg.correcttail			= 'alpha'; % adapts the alpha value depending on one/ two sided test
	    cfg.minnbchan			= 0;          % minimum number of neighborhood frechannels that is required for a selected sample to be included in the clustering algorithm (default=0).
	    cfg.tail				= 0;          % -1, 1 or 0 (default = 0); one-sided or two-sided test
	    cfg.neighbours			= [];
	    cfg.numrandomization	= 5000;  % set this to 5000 for final statistics (correcting for multiple comparisons) set up design matrix
	    cfg.design				= [1:nsubj 1:nsubj; ones(1, nsubj) 2*ones(1, nsubj)];
	    cfg.uvar				= 1; 
	    cfg.ivar				= 2; 
	    stat = ft_freqstatistics(cfg, conn_GA2, conn_GA1);
    
	    %% mask results
	    stat.result = double(stat.mask); 
	    for i = 1:size(stat.mask,1)
		    for j = 1:size(stat.mask,2)
			    if stat.mask(i,j) == 1
				    stat.result(i,j) = stat.stat(i,j); 
			    end 
		    end 
	    end 

	    save([org.pathresults, 'stats_', segment, cond, '.mat'], 'stat');
    end 
end 