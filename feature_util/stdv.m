function b = stdv(data)

% squared average distance
A = bsxfun(@minus,data,mean(data));
b = mean(sum(A.*A,2));



