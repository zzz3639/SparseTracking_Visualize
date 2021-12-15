function TrajectoryPlot(Trj,BG,zoom,FrameRate,DrawBGAside,FileName)
%Modified in 2015.08.28 by ZhangHaowen
%Plot trajectory above background movie BG
%Usage: TrajectoryPlot(Trj,BG,zoom,FrameRate,DrawBGAside)
%   or: TrajectoryPlot(Trj,BG,zoom,FrameRate,DrawBGAside,FileName)
%
%   Trj: Trajectory, [x,y,t,id], for best performance, set the topleft pixel (0.5,0.5).
%   BG: Background, 2d(image) or 3d(movie)
%   Zoom: Integer, magnificant to zoom in.
%   FrameRate: How fast to play the movie
%   DrawBGAside: 0/1, whether to draw an empty background aside
%   FileName: avi name to save to. Save nothing when this value was absent.

if nargin<6
    FileName='';
end
    [u,v] = sort(Trj(:,4));
    Trj = Trj(v,:);
    %filter molecules out of range.
    Remove=(Trj(:,1)<1 | Trj(:,1)>size(BG,1) | Trj(:,2)<1 | Trj(:,2)>size(BG,2)) ;
    [v]=find(Remove);
    Ridx=Trj(v,4);
    Ridx=sort(Ridx);
    Ridx=unique(Ridx);
    if length(Ridx)==0
        TrjRemain=Trj;
    else
        k=1;
        Remain=zeros(size(Trj,1),1);
        for i=1:size(Trj,1)
            if Ridx(k)<Trj(i,4)
                if k+1<=size(Ridx,1)
                    k=k+1;
                end
                if Ridx(k)~=Trj(i,4)
                    Remain(i,1)=1;
                end
            else
                if Ridx(k)~=Trj(i,4)
                    Remain(i,1)=1;
                end
            end
        
        end
        [v]=find(Remain);
        TrjRemain=Trj(v,:);
        [u,v]=sort(TrjRemain(:,4));
        TrjRemain=TrjRemain(v,:);
    end
%{
    N=length(unique(TrjRemain(:,4)));
    Trj=cell(N,1);
    Min=min(TrjRemain(:,4));
    Max=max(TrjRemain(:,4));
    minus=[TrjRemain(2:end,4);Max+1]-TrjRemain(1:end,4);
    v=find(minus);
    k=0;
    for i=1:N
        Trj{i}=TrjRemain(k+1:v(i),1:3);
        k=v(i);
    end
%}   
    % open this file
    if length(FileName)>0
        vidObj = VideoWriter(FileName,'Uncompressed AVI');
        vidObj.FrameRate=FrameRate;
        open(vidObj);
    end
    
    L=length(TrjRemain);
    T=max(TrjRemain(:,3));
    BGC=zeros(size(BG,1),size(BG,2),3,T);
    for l=1:T
        if size(BG,3)==1
            BGC(:,:,1,l)=0;
            BGC(:,:,2,l)=BG;
            BGC(:,:,3,l)=BG;
        else
            BGC(:,:,1,l)=0;
            BGC(:,:,2,l)=BG(:,:,l);
            BGC(:,:,3,l)=BG(:,:,l);
        end
    end
    ImgB=PlotTrjFrame(TrjRemain,BGC,1,zoom,FileName,DrawBGAside);
    
    
    for l=1:T
        ImgB=PlotTrjFrame(TrjRemain,BGC(:,:,:,l),l,zoom,FileName,DrawBGAside);
        pause(1/FrameRate);
        if length(FileName)>0
            writeVideo(vidObj,ImgB);
        end
    end
    
% Close the file.
if length(FileName)>0
    close(vidObj);
end
    
end
