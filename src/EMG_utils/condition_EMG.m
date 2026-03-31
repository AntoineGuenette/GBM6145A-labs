function [EMG_conditionned] = condition_EMG(T_m, EMG, act_length)

arguments
    T_m (1,1) double
    EMG (:,1) double
    act_length (1,1) double
end

% Binary detection
detection = EMG > T_m;

% Keep only sustained activations
kernel = ones(act_length,1);
conv_result = conv(double(detection), kernel, 'same');
mask = conv_result >= act_length;

% Apply threshold and mask
EMG_conditionned = (EMG - T_m) .* mask;

% Ensure no negative values
EMG_conditionned(EMG_conditionned < 0) = 0;

end