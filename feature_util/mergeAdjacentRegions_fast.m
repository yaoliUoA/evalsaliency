function mergedImsegs = mergeAdjacentRegions_fast(regionHist, imsegs, th)
    num_region = max(imsegs.segimage(:));
    
    adjmat = imsegs.adjmat;
    temp_ind = find(adjmat ~= adjmat');
    adjmat(temp_ind) = 0;
    region_dist = zeros(num_region, num_region);
    
%     spstats = regionprops(imsegs.segimage, 'PixelIdxList');
%     
%     
%     [sx,sy]=vl_grad(double(imsegs.segimage), 'type', 'forward') ;
%     s = find(sx | sy) ;
%     EdgeMask = zeros(size(imsegs.segimage));
%     EdgeMask(s) = 1;
%     f = f.*EdgeMask;
    
    
    ind = find(adjmat);
    for ix = 1 : length(ind)
        [x y] = ind2sub([num_region, num_region], ind(ix));
        if x ~= y
            %EdgeDist = mean(f(spstats(x).PixelIdxList));
            %EdgeDist = EdgeDist + mean(f(spstats(y).PixelIdxList));
            region_dist(x, y) = histDist(regionHist(x,:), regionHist(y,:));
        end
    end
    
    
    
    temp_adjmat = (region_dist < th & region_dist ~= 0);
    ind = find(temp_adjmat);
    cur_label = 1;
    labels = zeros(num_region, 1);
    labels = mexMergeAdjacentRegions(double(temp_adjmat),ind-1);
    
%     for ix = 1 : length(ind)
%         [x y] = ind2sub([num_region, num_region], ind(ix));
%         
%         fprintf('ix: %d, ind(ix): %d, x: %d, y: %d, label_x: %d, label_y: %d\n', ix, ind(ix), x, y, labels(x), labels(y));
% %         pause;
%         
%         if labels(x) ~= 0 && labels(y) == 0
%             labels(y) = labels(x);
%         elseif labels(y) ~= 0 && labels(x) == 0
%             labels(x) = labels(y);
%         elseif labels(x) ~= 0 && labels(y) ~= 0
%             if labels(x) ~= labels(y)
%                 %fprintf('x: %d, y: %d, label_x: %d, label_y: %d\n', x, y, labels(x), labels(y));
%                 error('Error in merging');
%             end
%         else            
%             labels(x) = cur_label;
%             labels(y) = cur_label;
%             cur_label = cur_label + 1;
%         end
%         temp_ind = find(temp_adjmat(x,:));
%         labels(temp_ind) = labels(x);
%         temp_ind = find(temp_adjmat(:,x));
%         labels(temp_ind) = labels(x);
%         temp_ind = find(temp_adjmat(:,y));
%         labels(temp_ind) = labels(y);
%         fprintf('\t*** labels(x): %d, labels(x): %d\n', labels(x), labels(y));
%         % labels'
%     end
    
    % disp(max(labels));
    
    % fprintf( '\t*** min region dist: %.8f\n', min(region_hist_dist));
%     
%     region_hist_dist;
    
    ind = find(labels == 0);
    labels(ind) = max(labels(:)) + [1:length(ind)];
    
    new_num_region = max(labels(:));
    segimage = zeros(size(imsegs.segimage));
    spstats = regionprops(imsegs.segimage, 'PixelIdxList');
    
    for ix = 1 : num_region
        segimage(spstats(ix).PixelIdxList) = labels(ix);
    end
    
    nseg = new_num_region;
    imh = size(segimage, 1);
    
	adjmat = eye([new_num_region new_num_region], 'uint8');

    % get adjacency
    dx = uint8(segimage ~= segimage(:,[2:end end]));
    dy = segimage ~= segimage([2:end end], :);
            
    ind1 = find(dy);
    ind2 = ind1 + 1;
    s1 = segimage(ind1);
    s2 = segimage(ind2);
    adjmat(s1 + nseg*(s2-1)) = 1;
    adjmat(s2 + nseg*(s1-1)) = 1;
            
    ind3 = find(dx);
    ind4 = ind3 + imh;
    s3 = segimage(ind3);
    s4 = segimage(ind4);
    adjmat(s3 + nseg*(s4-1)) = 1;
    adjmat(s4 + nseg*(s3-1)) = 1;  
    
    mergedImsegs = imsegs;
    mergedImsegs.segimage = segimage;
    mergedImsegs.adjmat = adjmat;
        
        
    
    
    