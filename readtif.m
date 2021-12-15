function [ Mtif ] = readtif( fname )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
info = imfinfo(fname);
num_images = numel(info);
A=imread(fname,1);
Mtif=zeros([size(A),num_images]);
for k = 1:num_images
    A = imread(fname, k);
    % ... Do something with image A ...
    Mtif(:,:,k) = A;
end

end

