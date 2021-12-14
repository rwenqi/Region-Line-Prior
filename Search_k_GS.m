function k=Search_k_GS(A,Mean_scene,b,sourcePic,T2,C,Theta_error)
aa=0;bb=65;
r=0.618;a1=bb-r*(bb-aa);a2=aa+r*(bb-aa);stepNum=0;
while abs(bb-aa)>Theta_error
    stepNum=stepNum+1;
    f1=GS_s_K(a1,A,Mean_scene,b,sourcePic,T2,C);
    f2=GS_s_K(a2,A,Mean_scene,b,sourcePic,T2,C);
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
   k=(a1+a2)/2;
end