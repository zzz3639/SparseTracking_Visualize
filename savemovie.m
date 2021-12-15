function [] = savemovie( name, mergemv, framerate )
%Save matlab 3D or 4D matrix to movie
%Usage:  [] = savemovie( outputfilename, matrix, framerate )
    mergemv=mergemv-(mergemv>1).*(mergemv-1);
    vidObj = VideoWriter(name,'Uncompressed AVI');
    vidObj.FrameRate=framerate;
    open(vidObj)
 
    if length(size(mergemv))==3
        K=3;
    else
        K=4;
    end
    n=size(mergemv,K);
    for i=1:n
       % Write each frame to the file.
       if K==4
           writeVideo(vidObj,mergemv(:,:,:,i));
       else
           writeVideo(vidObj,mergemv(:,:,i));
       end
    end
  
    % Close the file.
    close(vidObj);

end

