function diff = compute_CAI_diff(avg_J, avg_D)

% Numerical conversion
vals = {avg_J, avg_D};
nums = zeros(2,1);
for k = 1:2
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

baseline_mean = nums(1);  % JAECO
device_mean   = nums(2);  % DynAReach

if baseline_mean == 0
    diff = 'N/A';
    return;
end

diff_val = (device_mean - baseline_mean) / baseline_mean * 100;
diff     = sprintf('%.2f', diff_val);
end
