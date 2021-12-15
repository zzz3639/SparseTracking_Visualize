function [ movieout ] = moviezoom( moviein, k )
%MOVIEZOOM Summary of this function goes here
%   [ movieout ] = moviezoom( moviein, k )

T = size(moviein,3);
movieout = zeros(size(moviein,1)*k,size(moviein,2)*k,T);
for i=1:T
    movieout(:,:,i) = kron(moviein(:,:,i),ones(k,k));
end

end

