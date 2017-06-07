function [pixel_x,pixel_y]=camera_footprint_height_angle(cam_height,cam_angle_horizon,...
    angle_y,angle_x,npixel_y,npixel_x)

dtheta_y=angle_y/npixel_y;
dtheta_x=angle_x/npixel_x;

s_thetay=90-cam_angle_horizon-angle_y/2;
j=1:1:npixel_y;
for i=1:1:npixel_x
    pixel_y(:,i)=cam_height*tan((s_thetay+j*dtheta_y)*pi/180);
end

pixel_x=zeros(npixel_y,npixel_x/2);
for i=1:1:npixel_y
    a1=cam_height/cos((s_thetay+i*dtheta_y)*pi/180);
    pixel_x(i,1)=a1*dtheta_x*pi/180;
    for j=2:1:npixel_x/2
        d=sum(pixel_x(i,1:j-1));
        c=sqrt(pixel_y(i,1)^2+d^2);
        a1=sqrt(cam_height^2+c^2);
        pixel_x(i,j)=a1*dtheta_x*pi/180;
    end
end

for i=1:1:npixel_y
    for j=1:1:npixel_x/2
        temp(i,j)=sum(pixel_x(i,1:j),2);
    end
end
clear pixel_x
pixel_x=zeros(npixel_y,npixel_x);
pixel_x(:,1:npixel_x/2)=-fliplr(temp);
pixel_x(:,npixel_x/2+1:npixel_x)=temp;
pixel_y=pixel_y-pixel_y(1,1);