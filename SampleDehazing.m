close all;
clear all;clc;
sourcePic=double(imread('./image/1.jpg'))/255;
[m,n,c]=size(sourcePic);
J = zeros(size(sourcePic));
av=sourcePic(:,:,1)+sourcePic(:,:,2)+sourcePic(:,:,3);
av=av/3;
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parameter Set
b=0.1;cluster_num=10;T1=0.01;T2=0.40;dn=0.5;
per=0.1;k_search=0.5;error1=0.0001;error2=0.0001;error=0.05;
%%%%%%%%%%%%%%%find direction
sourcePic_d=imresize(sourcePic,dn);
[m_d,n_d,c_d]=size(sourcePic_d);
av=(sourcePic_d(:,:,1)+sourcePic_d(:,:,2)+sourcePic_d(:,:,3))/3;
PW=abs(sourcePic_d(:,:,1)-av)./av+abs(sourcePic_d(:,:,2)-av)./av+abs(sourcePic_d(:,:,3)-av)./av;
U=reshape(PW,1,m_d*n_d);
U=sort(U,2,'ascend');
med1=round(m_d*n_d*per)+1;
med2=round(m_d*n_d*(per+0.1));
AP2=find(PW<=U(med2)&PW>=U(med1));
aa=sourcePic_d(:,:,1);bb=sourcePic_d(:,:,2);cc=sourcePic_d(:,:,3);
R=mean2(aa(AP2));G=mean2(bb(AP2));B=mean2(cc(AP2));
C=[1,G/R,B/R];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Cluster
DE=sourcePic_d(:,:,3);
Mask = avecluster(DE,cluster_num);
Mean_scene_d=ones(m_d,n_d);
for i=1:1:cluster_num
Pos=find(Mask==i);
Mean_scene_d(Pos)=mean2(av(Pos));
end
ddn=50/m;
Mean_scene_dd=imresize(Mean_scene_d,ddn);sourcePic_dd=imresize(sourcePic_d,ddn);
[hh1,ww1] = size(sourcePic_dd(:,:,1));
for iter=1:1:14
A_search=Search_A_GS(k_search,Mean_scene_dd,b,sourcePic_dd,T1,C,error1);
k_search=Search_k_GS(A_search,Mean_scene_dd,b,sourcePic_dd,T2,C,error1);
M(iter)=A_search;
N(iter)=k_search;
MMM(iter)=M(iter);
if iter>=2
MMM(iter)=abs(M(iter)-M(iter-1))+abs(N(iter)-N(iter-1));
end
if iter>=2&(abs(M(iter)-M(iter-1))<error2)
    break
end
end
k_determined=max(min(N(iter),1),0);
A=M(iter)*C;
J_scene_pre_d=k_determined*(Mean_scene_d-min(min(Mean_scene_d)))+b;
t_d=max(mean(A)-Mean_scene_d,error)./max(mean(A)-J_scene_pre_d,error);
t_d=guidedfilter(sourcePic_d(:,:,3),t_d,round(m_d/5),0.02);
t_=imresize(t_d,[m,n]);
J(:,:,1) = double((sourcePic(:,:,1) - (1-t_).*A(1))./t_)/A(1);   
J(:,:,2) = double((sourcePic(:,:,2) - (1-t_).*A(2))./t_)/A(2);  
J(:,:,3) = double((sourcePic(:,:,3) - (1-t_).*A(3))./t_)/A(3);  
toc
J=min(max(J,0),1);
imwrite(J,'dehazing.bmp');

