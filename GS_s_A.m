function SQ=GS_s_A(k_determined,a,Mean_scene,b,sourcePic,T1,C)
J_scene_pre=k_determined*(Mean_scene-min(min(Mean_scene)))+b;
A(1)=a*C(1);A(2)=C(2)*a;A(3)=C(3)*a;
t=(max(mean(A)-Mean_scene,0.00000010)./max(mean(A)-J_scene_pre,0.0000000001));
t_=min(max(t,0.1),0.99);
J(:,:,1) = double((sourcePic(:,:,1) - (1-t_).*A(1))./t_)/A(1);   
J(:,:,2) = double((sourcePic(:,:,2) - (1-t_).*A(2))./t_)/A(2);  
J(:,:,3) = double((sourcePic(:,:,3) - (1-t_).*A(3))./t_)/A(3);  
J=min(max(J,0),1);
[m,n]=size(Mean_scene);
SQ=abs((sum(J(:)==0)+sum(J(:)==1))/m/n/3-T1); 
end