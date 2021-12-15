function [] = savetif( Mtif, filesave )
%save matrix to Mtif to filename
%   Usage: [] = savetif( Mtif, filesave )
T=size(Mtif,3);
Mtif = uint16(Mtif);

imwrite(Mtif(:,:,1),filesave)
for K=2:T
   imwrite(Mtif(:, :, K), filesave, 'WriteMode', 'append');
end


end

