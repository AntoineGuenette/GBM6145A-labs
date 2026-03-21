function diff = compute_non_EMG_diff(val_1, val_2, val_3, val_4, task_group)

    % Pack values in a cell array for easier handling
    vals = {val_1, val_2, val_3, val_4};

    % Helper: test if a value is 'Unknown'
    isUnknown = @(v) (ischar(v) && strcmp(v,'Unknown')) || ...
                     (isstring(v) && v=="Unknown");

    % If any value is the string 'Unknown' -> 'N/A'
    for k = 1:4
        if isUnknown(vals{k})
            diff = 'N/A';
            return;
        end
    end

    % Convert to numeric array
    nums = zeros(4,1);
    for k = 1:4
        v = vals{k};
        if isstring(v) || ischar(v)
            nums(k) = str2double(v);
        else
            nums(k) = v;
        end

        if isempty(nums(k)) || isnan(nums(k))
            diff = 'N/A';
            return;
        end
    end

    % Build baseline/device groups according to task_group
    switch task_group
        case 2
            baseline_vals = nums(1:2);
            device_vals   = nums(3:4);
        case 3
            baseline_vals = nums(1:3);
            device_vals   = nums(4);
        otherwise
            diff = 'N/A';
            return;
    end

    % Compute means
    baseline_mean = mean(baseline_vals);
    device_mean   = mean(device_vals);

    % Avoid division by zero
    if baseline_mean == 0
        fprintf("Baseline mean is 0\n");
        diff = 'N/A';
        return;
    end

    % Compute percentage difference
    diff_val = abs(baseline_mean - device_mean) / baseline_mean * 100;

    % Format to 2 decimals as string
    diff = sprintf('%.2f', diff_val);
end
