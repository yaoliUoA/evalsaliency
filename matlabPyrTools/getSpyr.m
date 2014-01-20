% RANGE = getSpyr (PYR, INDICES, RANGE, GAP, LEVEL_SCALE_FACTOR)
% 
% Display a steerable pyramid, specified by PYR and INDICES
% (see buildSpyr), in the current figure.  The highpass band is not shown.
% 
% RANGE is a 2-vector specifying the values that map to black and
% white, respectively.  These values are scaled by
% LEVEL_SCALE_FACTOR^(lev-1) for bands at each level.  Passing a value
% of 'auto1' sets RANGE to the min and max values of MATRIX.  'auto2'
% sets RANGE to 3 standard deviations below and above 0.0.  In both of
% these cases, the lowpass band is independently scaled.  A value of
% 'indep1' sets the range of each subband independently, as in a call
% to showIm(subband,'auto1').  Similarly, 'indep2' causes each subband
% to be scaled independently as if by showIm(subband,'indep2').
% The default value for RANGE is 'auto2'.
% 
% GAP (optional, default=1) specifies the gap in pixels to leave
% between subbands.  
% 
% LEVEL_SCALE_FACTOR indicates the relative scaling between pyramid
% levels.  This should be set to the sum of the kernel taps of the
% lowpass filter used to construct the pyramid (default is 2, which is 
% correct for L2-normalized filters.

% Eero Simoncelli, 2/97.

function pyramids = getSpyr(pyr, pind, range, gap, scale);

nbands = spyrNumBands(pind);

%------------------------------------------------------------
%% OPTIONAL ARGS:

if (exist('range') ~= 1)  
  range = 'auto2';
end
		
if (exist('gap') ~= 1)
  gap = 1;
end

if (exist('scale') ~= 1)
  scale = 2;
end

%------------------------------------------------------------

ht = spyrHt(pind);
nind = size(pind,1);

%% Auto range calculations:
if strcmp(range,'auto1')
  range = ones(nind,1);
  band = spyrHigh(pyr,pind);
  [mn,mx] = range2(band);
  for lnum = 1:ht
    for bnum = 1:nbands
      band = spyrBand(pyr,pind,lnum,bnum)/(scale^(lnum-1));
      range((lnum-1)*nbands+bnum+1) = scale^(lnum-1);
      [bmn,bmx] = range2(band);
      mn = min(mn, bmn);
      mx = max(mx, bmx);
    end    
  end
  range = range * [mn mx]; 		% outer product
  band = pyrLow(pyr,pind);
  [mn,mx] = range2(band);
  range(nind,:) = [mn, mx];

elseif strcmp(range,'indep1')
  range = zeros(nind,2);
  for bnum = 1:nind
    band = pyrBand(pyr,pind,bnum);
    [mn,mx] = range2(band);
    range(bnum,:) =  [mn mx];
  end

elseif strcmp(range,'auto2')
  range = ones(nind,1);
  band = spyrHigh(pyr,pind);
  sqsum = sum(sum(band.^2));  numpixels = prod(size(band));
  for lnum = 1:ht
    for bnum = 1:nbands
      band = spyrBand(pyr,pind,lnum,bnum)/(scale^(lnum-1));
      sqsum = sqsum + sum(sum(band.^2));
      numpixels = numpixels + prod(size(band));
      range((lnum-1)*nbands+bnum+1) = scale^(lnum-1);
    end    
  end
  stdev = sqrt(sqsum/(numpixels-1));
  range = range * [ -3*stdev 3*stdev ]; % outer product
  band = pyrLow(pyr,pind);
  av = mean2(band);   stdev = sqrt(var2(band));
  range(nind,:) = [av-2*stdev,av+2*stdev];

elseif strcmp(range,'indep2')
  range = zeros(nind,2);
  for bnum = 1:(nind-1)
    band = pyrBand(pyr,pind,bnum);
    stdev = sqrt(var2(band));
    range(bnum,:) =  [ -3*stdev 3*stdev ];
  end
  band = pyrLow(pyr,pind);
  av = mean2(band);   stdev = sqrt(var2(band));
  range(nind,:) = [av-2*stdev,av+2*stdev];
  
elseif isstr(range)
  error(sprintf('Bad RANGE argument: %s',range))
  
elseif ((size(range,1) == 1) & (size(range,2) == 2))
  scales = scale.^[0:(ht-1)];
  scales = ones(nbands,1) * scales;   %outer product
  scales = [1; scales(:); scale^ht];  %tack on highpass and lowpass
  range = scales * range;		% outer product
  band = pyrLow(pyr,pind);
  range(nind,:) = range(nind,:) + mean2(band) - mean(range(nind,:));

end

% CLEAR FIGURE:

% colormap(gray);
% cmap = get(gcf,'Colormap');
% nshades = size(cmap,1);
nshades = 64;




%% Paste bands into image, (im-r1)*(nshades-1)/(r2-r1) + 1.5 
pyramids = cell(1,nind-1);
for bnum=2:nind
  mult = (nshades-1) / (range(bnum,2)-range(bnum,1));
  pyramids{bnum-1} = mult*pyrBand(pyr,pind,bnum) + (1.5-mult*range(bnum,1));
end
  


