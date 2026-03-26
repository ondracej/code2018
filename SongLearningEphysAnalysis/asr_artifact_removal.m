function [clean_data, artifact_times] = asr_artifact_removal(raw_data, Dthresh, SDthresh)
    % asr_artifact_removal.m ? Artifact Subspace Reconstruction (ASR)
    %
    %   Apply a simple ASR method to remove artifacts from multichannel data.
    %   Input is a channels ? samples matrix; output is cleaned data and
    %   indices of time points identified as artifacts.
    %
    %%%
    %%author__ = Corinna Lorenz
    %%contact__ = corinna@ini.ethz.ch
    %%date__ = 2025/10/01
    %%status__ = Done

    % Parameters
    covarianceMatrix = cov(raw_data');  % Estimate the covariance matrix
    [E, D] = eig(covarianceMatrix);     % Eigenvalue decomposition

    % Find principal components to retain (simple thresholding)
    threshold = median(diag(D)) * Dthresh;  % Threshold for detecting artifacts
    artifact_components = find(diag(D) > threshold);

    
    % Identify times with significant artifact presence
    artifact_indicator = sum((E(:, artifact_components)' * raw_data).^2, 1);
    artifact_threshold = mean(artifact_indicator) + SDthresh * std(artifact_indicator);
    artifact_times = find(artifact_indicator > artifact_threshold);

    % Remove artifact components
    E(:, artifact_components) = 0;
    clean_data = E * D * E' * raw_data;

end