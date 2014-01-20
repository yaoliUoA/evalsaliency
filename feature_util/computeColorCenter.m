function color_center = computeColorCenter(image, segimage)
    num_region = max(segimage(:));
    
    r = image(:,:,1);   
    g = image(:,:,2);
    b = image(:,:,3);           % all in the range of [0, 1]
    
    color_center = zeros(num_region, 3);        % r, g, b respectively
    
    for ix = 1 : num_region
        ind = find(segimage == ix);
        
        color_center(ix, 1) = mean(r(ind));
        color_center(ix, 2) = mean(g(ind));
        color_center(ix, 3) = mean(b(ind));
    end