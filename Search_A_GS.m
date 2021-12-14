function A=Search_A_GS(k_determined,Mean_scene,b,sourcePic,T1,C,Theta_error1)
A = 0;
aa=0;bb=1;
r=0.618;a1=bb-r*(bb-aa);a2=aa+r*(bb-aa);stepNum=0;
while abs(bb-aa)>Theta_error1
    stepNum=stepNum+1;
    f1=GS_s_A(k_determined,a1,Mean_scene,b,sourcePic,T1,C);%GS_s(k_determined,a1,Mean_scene,b,sourcePic,T1,T2,ba,c21,c31);
    f2=GS_s_A(k_determined,a2,Mean_scene,b,sourcePic,T1,C);%GS_s(k_determined,a2,Mean_scene,b,sourcePic,T1,T2,ba,c21,c31);
    if f1>f2
       aa=a1;
       f1=f2;
       a1=a2;
       a2=aa+r*(bb-aa);     
    else
       bb=a2;
       a2=a1;
       f2=f1;
       a1=bb-r*(bb-aa);       
    end 
   A=(a1+a2)/2;
end