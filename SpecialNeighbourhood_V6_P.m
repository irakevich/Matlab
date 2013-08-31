function [Vwr]=SpecialNeighbourhood_V6_P(Xwgr,Ewrz,HEwrz,wf,C6wr)
%	definiujemy C6wr, wykorzystuj¹c wybrany algorytm szukamy najlepszego uszeregowania sêdziów, zak³adaj¹c, ¿e ¿adne spotkanie jeszcze siê nie odby³o.
%do sasiedztwa trafia ca³y wektor s¹siedztwa Vwr, gdyz zadne spotkanie
%jeszcze sie nie odby³o

% P -> mo¿emy modyfikowaæ obsadê we wszystkich kolejkach.
global W
global R
global S
global Oa
global Oh
global Lr

V1wr=zeros(W,R);
V2wr=zeros(W,R);
V3wr=zeros(W,R);
V4wr=zeros(W,R);
V5wr=zeros(W,R);
V6wr=zeros(W,R);
 % -- V1
             
    V1 = 0;
    for i = 1:W-1
        V1old =  sum(sum(sum(Ewrz(i,:,:).*sum(Ewrz(i+1:min(i+S-1,W),:,:),1),1),2),3);
        
        V1r =  sum(  Ewrz(i,:,:).*sum(Ewrz(max(i-S+1,1):min(i+S-1,W),:,:),1) -Ewrz(i,:,:)  ,3);
        V1next=sum(sum(V1r,1),2);
        if V1next>0
          V1wr(i,:)=V1r; 
        end;  
        V1=V1+V1next;
    end;
     % disp(sprintf('V1 %g %g',V1, V1old));
 
 % -- V2                
    V2wrz = max(sum(Ewrz, 1) - Oa, 0);
    V2rz=squeeze(V2wrz); %sp³aszczyc wynik
    for i=1:W
        Erz=squeeze(Ewrz(i,:,:));
        V2wr(i,:)= squeeze(sum(Erz.*V2rz,2));
    end;    
    
     %disp(sprintf('V2%g',V2)); 


 % -- V3                
    V3wrz =max(sum(HEwrz, 1) - Oh, 0);
    V3rz=squeeze(V3wrz); %sp³aszczyc wynik
    for i=1:W
        HErz=squeeze(HEwrz(i,:,:));
        V3wr(i,:)= squeeze(sum(HErz.*V3rz,2));
    end;    
  
  % -- V4
    TMPX11r=sum(sum(Xwgr(:,:,:),1),2);
    TMPXr=TMPX11r(:); %sp³aszczyæ wynik do wektora
    V4r=max(Lr(:,1)-TMPXr,0); %wektor kar
    for i=1:W
        Xr=squeeze(sum(Xwgr(i,:,:),2));
        Xropozit=Xr==0;
        V4wr(i,:)=Xropozit.*V4r;
    end;    
    
    
 % --V5
   % V5old=sum(sum(sum( max( Xwgr(1:W/2,:,:)+Xwgr(W/2+1:W,:,:)-1,0),1),2),3);
    V5=0;
    for i=1:W/2
        V5r=sum(max( Xwgr(i,:,:)+Xwgr(i+W/2,:,:)-1,0),2); %sum po 2
        V5next=sum(sum(V5r,1),2);
        if V5next>0
            V5wr(i,:)=V5r;
        end;
        V5=V5+V5next;
    end;    
    %disp(sprintf('V5 %g %g',V5, V5old));
    
  % --V6
   V6wr=squeeze(sum(Xwgr,2)).*C6wr;
   Vwr=V1wr+V2wr+V3wr+V4wr+V5wr+V6wr;
   
 %  if wf>1
 %      pom=zeros(wf-1,R);
 %    Vwr=[pom;Vwr(wf:W,1:R)];
 %  end;
    
  
    