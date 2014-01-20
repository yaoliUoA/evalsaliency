function color_weight = computeColorWeight(image, segimage, color_center, epsilon)
    [h w c] = size(image);
    color_weight = zeros(h, w);
    
    num_region = max(segimage(:));
    
    spstats = regionprops(segimage, 'PixelIdxList');
    
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    
    for ix = 1 : num_region
        pixel_ind = spstats(ix).PixelIdxList;
        
        size(repmat(color_center(ix,:), [length(pixel_ind), 1]));
        size([r(pixel_ind) g(pixel_ind) b(pixel_ind)]);
        
        xx = computeColorDist([r(pixel_ind) g(pixel_ind) b(pixel_ind)], ...
            repmat(color_center(ix,:), [length(pixel_ind), 1]));
%         size(xx)
%         size(color_weight(pixel_ind))
    end
    color_weight = 1 ./ (color_weight + epsilon);
    
    
function color_dist = computeColorDist(c1, c2)
    color_dist = sqrt(sum((c1 - c2).^2, 2));
        