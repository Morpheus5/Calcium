function video = video_adjust(video, tol)
%VIDEO_ADJUST Adjust values to saturate values
%   Will cause the darkest 2% of pixels and the brightest
%   2% of pixels to saturate to black and white respectively.
%   Pass alternative values for `tol` to change the
%   proportions.

if ~exist('tol', 'var') || isempty(tol)
    tol = [0.02 0.98];
end

% minor optimization
if 0 == tol(1) && 1 == tol(2)
    video = mat2gray(video);
    return
end

% handle non image values gracefully
if isfloat(video)
    mn = min(video(:));
    mx = max(video(:));
    if mn < 0 || mx > 1
        video = (video - mn) ./ (mx - mn);
    end
end

old_dim = size(video);
clim = stretchlim(video(:), tol);
video = imadjust(video(:), clim, []);
video = reshape(video, old_dim);

end

