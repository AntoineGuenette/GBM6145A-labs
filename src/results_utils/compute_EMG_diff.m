function diff = compute_EMG_diff(avg_B, avg_D)

    arguments
        avg_B (1,1) double
        avg_D (1,1) double
    end

    % Convert inputs to numeric values
    vals = {avg_B, avg_D};
    nums = zeros(2,1);
    for k = 1:2
        v = vals{k};
        if isstring(v) || ischar(v)
            nums(k) = str2double(v);
        else
            nums(k) = double(v);
        end

        % Handle non-numeric or failed conversions
        if isempty(nums(k)) || isnan(nums(k))
            diff = "N/A";
            return;
        end
    end
    
    % Extract baseline and device means
    baseline_mean = nums(1);
    device_mean   = nums(2);
    
    % Handle zero baseline case
    if baseline_mean == 0
        diff = "N/A";
        return;
    end
    
    % Compute relative difference in percent
    diff_val = (device_mean - baseline_mean) / baseline_mean * 100;
    
    % Format output as string with two decimals
    diff = sprintf('%.2f', diff_val);
    
end