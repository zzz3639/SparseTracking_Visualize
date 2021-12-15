function TrajectoryPlotCon(Trj1, Trj2, BG, zoom, FrameRate, FileName)
%Modified in 2015.08.28 by ZhangHaowen
%Plot trajectory above background movie BG
%Usage: TrajectoryPlotCon(Trj1, Trj2, BG, zoom, FrameRate)
%   or: TrajectoryPlotCon(Trj1, Trj2, BG, zoom, FrameRate, FileName)
%
%   Trj1,Trj2: Trajectory, [x,y,t,id], for best performance, set the topleft pixel (0.5,0.5).
%   BG: Background, 2d(image) or 3d(movie)
%   Zoom: Integer, magnificant to zoom in.
%   FrameRate: How fast to play the movie
%   FileName: avi name to save to. Save nothing when this value was absent.

if nargin<6
    FileName='';
end
    S = [size(BG,1),size(BG,2)];
    Trj1 = rmoutrange(Trj1,S);
    Trj2 = rmoutrange(Trj2,S);
    Trj2(:,4) = Trj2(:,4) + 1 + max(Trj1(:,4));
    TrjRemain = [Trj1;[Trj2(:,1:2)+repmat([0,S(2)],size(Trj2,1),1),Trj2(:,3:4)]];
    BG = [BG,BG];
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
    T=max(TrjRemain(:,3))+1;
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
    
    
    for l=1:T
        ImgB=PlotTrjFrame(TrjRemain,BGC(:,:,:,l),l-1,zoom,FileName,0);
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


function TrjRemain = rmoutrange(Trj,S)
    %filter molecules out of range.
    [u,v] = sort(Trj(:,4));
    Trj = Trj(v,:);
    Remove=(Trj(:,1)<0.5 | Trj(:,1)>S(1)-0.5 | Trj(:,2)<0.5 | Trj(:,2)>S(2)-0.5) ;
    [v]=find(Remove);
    Ridx=Trj(v,4);
    Ridx=sort(Ridx);
    Ridx=unique(Ridx);
    if length(Ridx)==0
        TrjRemain=Trj;
    else
        k=1;
        r=0;
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
    idfull = TrjRemain(:,4);
    ididx = unique(idfull);
    for i=1:length(ididx)
        idthis = ididx(i);
        u = find(TrjRemain(:,4)==idthis);
        TrjRemain(u,4) = i-1;
    end
end


