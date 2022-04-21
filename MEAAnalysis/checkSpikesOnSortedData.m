function [] = checkSpikesOnSortedData()

dataDir = 'Z:\JanieData\Alina-MeaData\20211123\Spikeoutput\';

%Channel = 87;

%chanSet = [14 16 24 25 27 35 37 43 45 47 62 67 77];
%chanSet = [24 55 56 36 75];
%chanSet = [45 54 67 68];
%chanSet = [37 41 53 68 77 86];
%chanSet = [36 53 77];


chanSet = [41 42];

nChans = numel(chanSet);

for q = 1:nChans
    
    Channel = chanSet(q);
    
    %SaveName = '20210816-5HT1A-Ch87';
    %SaveName = '20210817-5HT2C-Ch78';
    %SaveName = '20210819-5HT1D-Ch77';
    %SaveName = '20210820-5HT-Ch75';
    %SaveName = '20210824-ACh-Ch87';
    %SaveName = ['20210902-NE-Ch' num2str(Channel) '-2'];
    %SaveName = ['20211110-NE-Ch' num2str(Channel) '-1'];
    
    %baselineMatfile = '20210824-1123_CH-32-33-41-42-47-58-62-65-67-68-75-76-78-87-_SpikeData__87.mat';
    %drugMatfile = '20210824-1134-ACh_CH-32-33-41-42-48-58-62-65-66-75-76-78-87-_SpikeData__87.mat';
    %recoveryMatfile = '20210824-1145-recovery_CH-32-33-42-48-62-65-68-72-75-76-82-87-_SpikeData__87.mat';
    
     baselineMatfile = ['20211123-1115_CH-41-42-_SpikeData__' num2str(Channel) '.mat'];
    drugMatfile = ['20211123-1115drug_CH-41-42-_SpikeData__' num2str(Channel) '.mat'];
    recoveryMatfile = ['20211123-1115rec_CH-41-42-_SpikeData__' num2str(Channel) '.mat'];

    %        baselineMatfile = ['20210824-1542_CH-24-33-44-55-56-58-63-68-75-_SpikeData__' num2str(Channel) '.mat'];
    %     drugMatfile = ['20210824-1553-ACh_CH-24-33-44-55-56-58-63-68-75-_SpikeData__' num2str(Channel) '.mat'];
    %     recoveryMatfile = ['20210824-1604-recovery_CH-24-31-52-55-56-63-75-_SpikeData__' num2str(Channel) '.mat'];
    %
    %%
    
    bD = load([dataDir baselineMatfile]);
    dD = load([dataDir drugMatfile]);
    rD = load([dataDir recoveryMatfile]);
    
    bD_fields = fieldnames(bD);
    dD_fields = fieldnames(dD);
    rD_fields = fieldnames(rD);
    
    %%
    eval(['bD_units = bD.' cell2mat(bD_fields) '(:,2);']);
    eval(['bD_timestamps_s = bD.' cell2mat(bD_fields) '(:,3);']);
    eval(['bD_spikeWaveforms = bD.' cell2mat(bD_fields) '(:,4:end);']);
    
    eval(['dD_units = dD.' cell2mat(dD_fields) '(:,2);']);
    eval(['dD_timestamps_s = dD.' cell2mat(dD_fields) '(:,3);']);
    eval(['dD_spikeWaveforms = dD.' cell2mat(dD_fields) '(:,4:end);']);
    
    eval(['rD_units = rD.' cell2mat(rD_fields) '(:,2);']);
    eval(['rD_timestamps_s = rD.' cell2mat(rD_fields) '(:,3);']);
    eval(['rD_spikeWaveforms = rD.' cell2mat(rD_fields) '(:,4:end);']);
    
    %% Find the Inds that are the correct spike sorting
    
    bD_chans_present = unique(bD_units);
    dD_chans_present = unique(dD_units);
    rD_chans_present = unique(rD_units);
    
    %%
    
    for f = 1:3
        
        switch f
            case 1
                chans_present = bD_chans_present;
              %  timestamps_s = bD_timestamps_s;
                spikeWaveforms = bD_spikeWaveforms;
                units = bD_units;
                fileTitle = baselineMatfile;
                
            case 2
                chans_present = dD_chans_present;
               % timestamps_s = dD_timestamps_s;
                spikeWaveforms = dD_spikeWaveforms;
                units = dD_units;
                fileTitle = drugMatfile;
            case 3
                chans_present = rD_chans_present;
               % timestamps_s = rD_timestamps_s;
                spikeWaveforms = rD_spikeWaveforms;
                units = rD_units;
                fileTitle = recoveryMatfile;
        end
        
        p = numSubplots(numel(chans_present));
        
        figH =  figure(102+f); clf
        for i = 1:numel(chans_present)
            
            subplot(p(1),p(2),i)
            
            chan1_inds = find(units ==chans_present(i));
            
            %these_timestamps_s = timestamps_s(chan1_inds);
            these_spikeWaveforms = spikeWaveforms(chan1_inds,:);
            
            plot(these_spikeWaveforms', 'k');
            axis tight
            ylim([-5e4 5e4])
            title(['Chan Ind: ' num2str(chans_present(i)) ' | n = ' num2str(size(these_spikeWaveforms,1)) ' spks']);
            
        end
        
        annotation(figH,'textbox',...
            [0.015 0.98 0.80 0.03],...
            'String',{fileTitle},...
            'LineStyle','none',...
            'FitBoxToText','off');
        
        saveName = [dataDir fileTitle(1:end-4) '__checkChans'];
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    end
    
    
end
end
