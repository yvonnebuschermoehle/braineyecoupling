%% Figure 1B
% average power spectrum of eye velocity trials with standard error
load('/home/buschermoehle/Schreibtisch/github/source_data/1b.mat')
figure; box on; grid on; hold on; 
    plot(freq, power, 'LineWidth', 2, 'Color', '#384860'); 
    fill([freq, flip(freq)], [power-powerSE, flip(powerAVG+powerSE)], [56 72 96]/255, 'FaceAlpha',0.3, 'EdgeColor', 'none'); 
    xticks(0:2.5:20); xticklabels({'0', '', '5', '', '10', '', '15', '', '20'}); 
    xlim([0 20]);
    xlabel('Frequency [Hz]'); 
    ylabel('Power'); 
    title('Mean Power Spectrum');
    ylim([1 3])

%% Figure 1C
% histogram of intersaccadic intervals for all participants (N=22) over all
% trials 
load('/home/buschermoehle/Schreibtisch/github/source_data/1c.mat')
figure; hold on; box on; grid on; 
	h = histogram(intersaccadicintervals, 'Normalization', 'probability', 'FaceColor', '#384860'); 
	h.BinEdges = 0.05:0.05:1.5;
	title('All Subjects'); xlabel('Intervals [s]'); ylabel('Density'); 
	xticks(0:0.1:1.5); 
	xticklabels({'0', '', '0.2', '', '0.4', '', '0.6', '', '0.8', ...
		'', '1.0', '', '1.2', '', '1.4'});
	set(gca, 'TickDir', 'out'); 

%% Figure 2
% plot error over RI 
load('/home/buschermoehle/Schreibtisch/github/source_data/2.mat')
figure; hold on; box on; grid on; 
	scatter(RI, error, 'filled'); 
	xlabel('RI'); ylabel('Error'); 
	str = {'Spearman:', ['r = ' num2str(r)], ['p = ' num2str(p)]}; 
	text(2, 2, str)

%% Figure 3a
load('/home/buschermoehle/Schreibtisch/github/source_data/3.mat')
figure; tiledlayout(2,4)
for i = [1,3,5,7,2,4,6,8]
    nexttile; box on; grid on; hold on; 
	plot(freq, coherence.left_average(i,:), 'LineWidth', 2, 'Color', '#0072BD'); 
	fill([freq, flip(freq)], [coherence.left_average(i,:)-coherence.left_SE(i,:), flip(coherence.left_average(i,:)+coherence.left_SE(i,:))], [0 0.4470 0.7410], 'FaceAlpha',0.1, 'EdgeColor', 'none'); 
	plot(freq, coherence.right_average(i,:), 'LineWidth', 2, 'Color', '#EDB120'); 
	fill([freq, flip(freq)], [coherence.right_average(i,:)-coherence.right_SE(i,:), flip(coherence.right_average(i,:)+coherence.right_SE(i,:))], [0.9290 0.6940 0.1250], 'FaceAlpha',0.1, 'EdgeColor', 'none'); 
	plot(freq, coherence.all_average(i,:), 'LineWidth', 2, 'Color', '#A2142F'); 
	fill([freq, flip(freq)], [coherence.all_average(i,:)-coherence.all_SE(i,:), flip(coherence.all_average(i,:)+coherence.all_SE(i,:))], [0.6350 0.0780 0.1840], 'FaceAlpha',0.1, 'EdgeColor', 'none'); 
	xticks(0:2.5:30); xticklabels({'0', '', '5', '', '10', '', '15', '', '20'});
	yticks(0:0.05:0.3); yticklabels({'0', '', '0.1', '', '0.2', '', '0.3'}); 
	xlabel('Frequency [Hz]'); xlim([0 20]); 
	ylabel(coherence.label{i}); ylim([0 0.3]); 
end 

%% Figure 3b
load('/home/buschermoehle/Schreibtisch/github/source_data/3b.mat')
% set mask to NaN for non significant values for plotting purposes
stats.left_mask_double = double(stats.left_mask); 
stats.left_mask_double(stats.left_mask_double == 0) = NaN; 
stats.right_mask_double = double(stats.right_mask); 
stats.right_mask_double(stats.right_mask_double == 0) = NaN; 
figure; tiledlayout(2,4)
for i = [1,3,5,7,2,4,6,8]
    nexttile; box on; grid on; hold on; 
	plot(freq, stats.left_stat(i,:), 'LineWidth', 2, 'Color', '#0072BD'); 
    area(freq, 6*stats.left_mask_double(i,:), 'FaceColor', '#0072BD', 'FaceAlpha', 0.2, 'EdgeColor','none')
	plot(freq, stats.right_stat(i,:), 'LineWidth', 2, 'Color', '#EDB120'); 
    area(freq, 6*stats.right_mask_double(i,:), 'FaceColor', '#EDB120', 'FaceAlpha', 0.2, 'EdgeColor', 'none')
    yline(0)
	xticks(0:2.5:30); %xticklabels({'0', '', '5', '', '10', '', '15', '', '20'});
	yticks(-3:6); %yticklabels({'0', '', '0.1', '', '0.2', '', '0.3'}); 
	xlabel('Frequency [Hz]'); xlim([0 20]); 
	ylabel(stats.label{i}); ylim([-3 6]); 
end 

%% Figure 4
load('/home/buschermoehle/Schreibtisch/github/source_data/4.mat')

fig = figure; fig.Position = [971 136 547 888]; 
	for i = 1:4
        stats{i}.result = double(stats{i}.mask); 
		for k = 1:size(stats{i}.mask,1)
			for j = 1:size(stats{i}.mask,2)
				if stats{i}.mask(k,j) == 1
					stats{i}.result(k,j) = stats{i}.stat(k,j); 
				end 
			end 
		end 

		subplot(2,2,i, 'Parent', fig); hold on; 
			imagesc(stats{i}.freq, 1:230, stats{i}.result); 
			xlabel('Frequency in Hz'); ylabel('Parcel'); 
			title([label{i}]); 
			yline(115.5, 'Color', [1 1 1], 'LineWidth', 1.5); 
			ylim([1 230]); %xlim([0 length(stat.freq)]); 
			clim([-5 5]); colorbar; colormap(vik)
			xlim([0 15]); 
    end 

%% Figure 5
load('/home/buschermoehle/Schreibtisch/github/source_data/5c.mat')

figure; hold on; grid on; box on; 
    swarmchart(x, corr, 7, 'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.7); 
    yline(0.7); 
    xlabel('Participant'); ylabel('Correlation: ICA comp. & Eye Tracker '); 
    xticks(0:23); xticklabels({'', '', '2', '', '4', '', '6', '', '8', '', '10', '', '12', '', '14', '', '16', '', '18', '', '20', '', '22', ''}); 
    xlim([0 23]); 

