function video_dff = FS_Dff(frames)
%FS_DFF Background subtraction and delta f / f calculation

% parameters
filt_rad = 1; % gauss filter radius
filt_alpha = 1; % gauss filter alpha
per = 10; % baseline percentile (0 for min)

% turn into movie data
mov_data = cat(3, frames(:).cdata);

% turn to single for memory purposes
mov_data = single(mov_data);

% smooth (use a [1/3 1/3 1/3] convolution along the third dimension)
mov = convn(mov_data, single(reshape([1 1 1] / 3, 1, 1, [])), 'same');

% Gaussian filter video
h = fspecial('gaussian', filt_rad, filt_alpha);
mov = imfilter(mov, h, 'circular');

% calculate baseline using percentile and repeat over video
baseline = prctile(mov, per, 3);

% use circular gaussian filter for baseline
h = fspecial('gaussian', 20, 40);
baseline = imfilter(baseline, h, 'circular'); % filter baseline

% calculate dff
dff = bsxfun(@minus, mov, baseline);
dff = bsxfun(@rdivide, dff, baseline);

% get high and low percentiles
H = prctile(mean(max(dff)),99);
L = prctile(mean(mean(dff)),50);

% convert to grayscale
clim = [double(L) double(H)];
video_dff = mat2gray(dff, clim);

end
