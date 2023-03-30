clc;close all;clear all;
            
    load('lab9_2.mat')
     Yid=id.Y;Xid=id.U; Yval=val.Y; Xval=val.U;Ts=id.Ts;
     figure(1); subplot(411), plot(Xid); subplot(412), plot(Yid);subplot(413), plot(Xval); subplot(414), plot(Yval);
     na=n;nb=n;nk=1;
     modelARX = arx(id,[na nb 1]); yh=compare(modelARX,id);Ysim=yh.y;
     figure(2),subplot(212), compare(modelARX, val); subplot(211), compare(modelARX,id);
     l=length(Xid);
     Y=[na+nb,1]; PHIf=[na+nb,na+nb];
     %% vector z
      for i=1:l
         for j=1:na
            if i-j>0
                z(i,j)= -Ysim(i-j); 
            else
                z(i,j)=0;
            end
        end  
        for j=1:nb
            if i-j>0
               z(i, j+na)=Xid(i-j); 
            else
                z(i, j+na)=0;
            end
         end
      end
        z = z';
%% vector PHI
Y=0;PHIf=0;
for i=1:l
    for j=1:na
        if i-j>0
            PHI(i,j)= -Yid(i-j);
        else
            PHI(i,j)=0;
        end
    end
    for j=1:nb
        if i-j>0
           PHI(i,j+na)=Xid(i-j); 
        else
            PHI(i,j+na)=0;
        end
    end
    Y = Y + z(:, i) * Yid(i);
   PHIf = PHIf + z(:, i) * PHI(i, :);
end
PHI=PHI';Y=Y/l;PHIf = PHIf/l; THETA=PHIf\Y;
A=[1 THETA(1:n)'];B=[0 THETA(n+1:end)'];
model_iv = idpoly(A, B, [], [], [], 0, Ts);
figure(3),subplot(211),compare(val, model_iv);subplot(212), compare(modelARX, val); 
figure(4),compare(val, model_iv, modelARX);      