function [ ImgB ] = PlotTrjFrame( Trj, BG, Frame, zoom, FileName, DrawBG )
% modified by ZhangHaowen in 2016.01.18
%PLOTTRJFRAME Summary of this function goes here
%   Detailed explanation goes here
P=3;
%BG=[zeros(20,10),ones(20,10)];
[u]=find(Trj(:,3)==Frame);
Mol=Trj(u,4);
[idx]=sort(Mol);
h=figure(1);
if size(BG,3)==1
    if DrawBG
        imshow(kron([BG,BG],ones(zoom,zoom)),'border','tight');
    else
        imshow(kron([BG],ones(zoom,zoom)),'border','tight');
    end
else
    BGC=zeros(size(BG,1)*zoom,size(BG,2)*zoom,3);
    BGC(:,:,1)=kron([BG(:,:,1)],ones(zoom,zoom));
    BGC(:,:,2)=kron([BG(:,:,2)],ones(zoom,zoom));
    BGC(:,:,3)=kron([BG(:,:,3)],ones(zoom,zoom));
    if DrawBG
        imshow(cat(2,BGC,BGC));
    else
        imshow(BGC);
    end
end
hold on
for i=1:length(idx)
    ThisMol=idx(i);
    [u]=find(Trj(:,4)==ThisMol);
    Trthis=Trj(u,:);
    [u,v] = sort(Trthis(:,3));
    Trthis = Trthis(v,:);
    FrameEnd=find(Trthis(:,3)==Frame);
    FrameStart=max(1,FrameEnd-P);
    Pos=Trthis(FrameStart:FrameEnd,1:2);
    plot(Pos(:,2)*zoom,Pos(:,1)*zoom,'g-','LineWidth',1.5);
    hold on;
    scatter(Pos(end,2)*zoom,Pos(end,1)*zoom,25,'r','o','filled');
    hold on;
end
hold off;
if length(FileName)==0
    ImgB=[];
else
    saveas(h,'temp','png');
    ImgB=imread('temp.png');
end
end

