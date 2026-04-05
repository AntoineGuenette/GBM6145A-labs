function cmap = redblue(m)

if nargin < 1
    m = 256;
end

bottom = [0 0 1];
middle = [1 1 1];
top = [1 0 0];

cmap = zeros(m,3);
for i = 1:m
    t = (i-1)/(m-1);
    if t < 0.5
        cmap(i,:) = (1-2*t)*bottom + (2*t)*middle;
    else
        cmap(i,:) = (1-2*(t-0.5))*middle + (2*(t-0.5))*top;
    end
end

end