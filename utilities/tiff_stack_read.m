function stack = tiff_stack_read(fn)
%TIFF_STACK_READ Read TIFF stack

% get info
info = imfinfo(fn);

% get number of images in stack
images = size(info, 1);

% size
width = info(1).Width;
height = info(1).Height;

if any([info.Width] ~= width) || any([info.Height] ~= height)
    error('Inconsistent dimensions.');
end

stack = imread(fn, 1);
d = ndims(stack) + 1;
for i = 2:images
    nxt = imread(fn, i);
    stack = cat(d, stack, nxt);
end

end

