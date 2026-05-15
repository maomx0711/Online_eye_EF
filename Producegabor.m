function gabor=Producegabor(size,ang,p,pha,c,sigma)
% pha=rand(1);
% size=60;
% ang=45;%angle 
% p=22;%period or lamda
% c=0.5;%contronst 
% sigma=18;
phase=pha*2*pi;%phase 
[X,Y]=meshgrid(1:size,1:size,3);
Ga=exp(-(((X-30)/(sqrt(2)*sigma)).^2)-(((Y-30)/(sqrt(2)*sigma)).^2));
gab=(sin((sind(ang)*X+cosd(ang)*Y)*2*pi/p+phase)*c+1)/2;

gabor_ground=zeros(60,60,3);
    loca=gab>0.25;
    gabor1=gab;
    gabor1(loca)=0;
    gabor_ground(:,:,1)=gabor1;
    gabor2=gab;
    gabor_ground(:,:,2)=gabor2;
    gabor3=gab;
    gabor3(loca)=0;
    gabor_ground(:,:,3)=gabor3;
%     gabor= (((gabor_ground(:,:,:).*2-1).*Ga)+1)/2;
    gabor=gabor_ground;
%     figure;
%     imshow(gabor)
end
