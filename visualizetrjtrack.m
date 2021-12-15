function [ trajectory ] = visualizetrjtrack( trj, s, Tmax, zoom ,J)
%Modified by ZHANG Haowen in 2015.08.21 
%  convert from particle list to movie;
%  usage: [ trajectory ] = visualizetrjtrack( [x,y,I,T], framesize, framenumber, zoom , SaveEverySnaps)

m=max(trj(:,4))+1;
if length(m)==0
    m=0;
end
m=max(m,Tmax);
s1=s(1);
s2=s(2);
ng1=s1*zoom;
ng2=s2*zoom;
trajectory=zeros(ng1,ng2,floor((m-1)/J)+1);

for i=1:(floor((m-1)/J)+1)
    T = (i-1)*J;
    v = find(T==trj(:,4));
    n = length(v);
    for j=1:n
        x=zoom*trj(v(j),1)+zoom/2+1/2;
        y=zoom*trj(v(j),2)+zoom/2+1/2;
        x=floor(x);
        y=floor(y);
        
        %light(x,y,trajectory,w(j),i);
        if x>=1+1&&x<=ng1-1&&y>=1+1&&y<=ng2-1
            trajectory(x,y,i)=trajectory(x,y,i)+trj(v(j),3);
            trajectory(x-1,y,i)=trajectory(x-1,y,i)+trj(v(j),3)/2;
            trajectory(x+1,y,i)=trajectory(x+1,y,i)+trj(v(j),3)/2;
            trajectory(x,y-1,i)=trajectory(x,y-1,i)+trj(v(j),3)/2;
            trajectory(x,y+1,i)=trajectory(x,y+1,i)+trj(v(j),3)/2;
        end
    end
end

end