clear all;

global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S

V=-100;
Vhm=-100;
if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;

draw=10;
Vhistory=zeros(draw,3);
VhistoryS=zeros(draw,9);
 VhistorySL=zeros(draw,9);
SetTheParameters();
i=1;
l=1900
 N=l/4;
while i<=draw 
    i
%disp('--------------------- start  -----------------------------');

if (mod(i,5)==1)
    [Hwgz,Awgz]=GenerateMatrixes (1); 
    l=l-100;
   

%disp('------------------------not random--------------------------');

[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);

end;
C6wr=zeros(W,R);[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
tic 
   [V_V5,cWRR_V5, Xwgr_V5,Ewrz_V5,HEwrz_V5]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);
          
            if (find(squeeze(sum(Xwgr_V5(:,:,:),3))~=1)>0) 
                squeeze(sum(Xwgr_V5(:,:,:),3)) 
            end;
            if (find(squeeze(sum(Xwgr_V5(:,:,:),2))>1)>0)
                squeeze(sum(Xwgr_V5(:,:,:),2))
            end;  
time=toc;
Vhistory(i,1)=VOr;
Vhistory (i,2)=V_V5;
Vhistory(i,3)=time;


tic 
    wf=1; C6wr=zeros(W,R);
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood_V6(XwgrOr,EwrzOr,HEwrzOr,VOr,wf,C6wr);  
      if (find(squeeze(sum(Xwgr(:,:,:),3))~=1)>0) 
                squeeze(sum(Xwgr(:,:,:),3)) 
            end;
            if (find(squeeze(sum(Xwgr(:,:,:),2))>1)>0)
                squeeze(sum(Xwgr(:,:,:),2))
            end;  
time=toc;
Vhistory (i,4)=V;
Vhistory(i,5)=time;


 %%-------------------------- SL  ---------------------------------------
[L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr,l);   
tic    
    [Vsl_V5,Xwgrsl,Ewrzsl,HEwrzsl]=HeuristicMethod_V5_SL(XwgrOr,EwrzOr,HEwrzOr,VOr,L,N);

    if (find(squeeze(sum(Xwgrsl(:,:,:),3))~=1)>0) 
        squeeze(sum(Xwgrsl(:,:,:),3)) 
    end;
    if (find(squeeze(sum(Xwgrsl(:,:,:),2))>1)>0)
        squeeze(sum(Xwgrsl(:,:,:),2))
    end; 
time=toc;  
Vhistory(i,6)=l;
Vhistory(i,7)=Vsl_V5;
Vhistory(i,8)=time;

cup=1;
if (cup==1)
     
        [wf,C6wr]=SetPunishment();

        disp('----------------- Znajdz rozwiazanie + na konec Set the punishment CUP ---------------------------------------------');
        [VCup]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
        tic
        [VAfterCup,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood_V6(Xwgr,Ewrz,HEwrz,VCup,wf,C6wr); % puchar=1;
              if (find(squeeze(sum(Xwgr(:,:,:),3))~=1)>0) 
                squeeze(sum(Xwgr(:,:,:),3)) 
            end;
            if (find(squeeze(sum(Xwgr(:,:,:),2))>1)>0)
                squeeze(sum(Xwgr(:,:,:),2))
            end;
        timet1=toc;
        disp('----------------- Poczatkowe rozwiazanie+ with the punishment CUP ---------------------------------------------');
        [VOrCup]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        tic
        [VSCup,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhood_V6(XwgrOr,EwrzOr,HEwrzOr,VOrCup,wf,C6wr); % puchar=1;
        timet2=toc;
        disp(sprintf('!!!!!VOr, V_V5, V ,VCup, VAfterCup ,VOrCup,VSCup %g %g %g %g %g %g %g ',VOr,  V_V5, V ,VCup, VAfterCup ,VOrCup,VSCup ));
           
        VhistoryS(i,1)=VOr;
        VhistoryS(i,2)=V_V5;
        VhistoryS(i,3)=V;
        VhistoryS(i,4)=VCup;
        VhistoryS(i,5)=VAfterCup;
        VhistoryS(i,6)=timet1;
        VhistoryS(i,7)=VOrCup;
        VhistoryS(i,8)=VSCup;
        VhistoryS(i,9)=timet2;
        
         disp('----------------- Znajdz rozwiazanie + na konec Set the punishment CUP ---------------------------------------------');
        
        [VAfterSL]=CalculateTheCostOfAllAssignment(Xwgrsl,Ewrzsl,HEwrzsl,C6wr);
        VAfterSL
        [L]=ListBasedTresholdAccepting_V6(Xwgrsl,Ewrzsl,HEwrzsl,l,wf,C6wr);  
        tic
        [VAfterSL_V6,XwgrV6,EwrzV6,HEwrzV6,krok]=HeuristicMethod_V6_SL(Xwgrsl,Ewrzsl,HEwrzsl,VAfterSL,L,N,wf,C6wr);
         time1=toc;
         VAfterSL_V6
         VAfterSL_V6_NEW=12345;
        if krok==500000
            tic
             [VAfterSL_V6_NEW,XwgrV6,EwrzV6,HEwrzV6]=HeuristicMethod_V6_SL_NEW(Xwgrsl,Ewrzsl,HEwrzsl,VAfterSL,L,N,wf,C6wr);
              time1=toc;
        end;  
       
              if (find(squeeze(sum(XwgrV6(:,:,:),3))~=1)>0) 
                squeeze(sum(XwgrV6(:,:,:),3)) 
            end;
            if (find(squeeze(sum(XwgrV6(:,:,:),2))>1)>0)
                squeeze(sum(XwgrV6(:,:,:),2))
            end;
        VAfterSL_V6_NEW
        disp('----------------- Poczatkowe rozwiazanie+ with the punishment CUP ---------------------------------------------');
        
        [VStartSL]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        [L]=ListBasedTresholdAccepting_V6(XwgrOr,EwrzOr,HEwrzOr,l,wf,C6wr);  
        tic
        [VStartSL_V6,XwgrV6S,EwrzV6S,HEwrzV6S,krok]=HeuristicMethod_V6_SL(XwgrOr,EwrzOr,HEwrzOr,VStartSL,L,N,wf,C6wr);
         time2=toc;
        VStartSL_V6
        VStartSL_V6_NEW=12345;
        if krok==500000
            tic
             [VStartSL_V6_NEW,XwgrV6S,EwrzV6S,HEwrzV6S]=HeuristicMethod_V6_SL_NEW(XwgrOr,EwrzOr,HEwrzOr,VStartSL,L,N,wf,C6wr);
             time2=toc;
        end;     
            if (find(squeeze(sum(XwgrV6S(:,:,:),3))~=1)>0) 
                squeeze(sum(XwgrV6S(:,:,:),3)) 
            end;
            if (find(squeeze(sum(XwgrV6S(:,:,:),2))>1)>0)
                squeeze(sum(XwgrV6S(:,:,:),2))
            end;
       
        VStartSL_V6_NEW
         disp(sprintf('!!!!!VOr, Vsl_V5,VAfterSL ,VAfterSL_V6, VStartSL ,VStartSL_V6 %g %g %g %g %g %g ',VOr, Vsl_V5,VAfterSL ,VAfterSL_V6, VStartSL ,VStartSL_V6 ));
        VhistorySL(i,1)=VOr;
        VhistorySL(i,2)=Vsl_V5;
        VhistorySL(i,3)=VAfterSL;
        VhistorySL(i,4)=VAfterSL_V6;
        VhistorySL(i,5)=VAfterSL_V6_NEW;
        VhistorySL(i,6)= time1;
        VhistorySL(i,7)= VStartSL;
        VhistorySL(i,8)=VStartSL_V6;
        VhistorySL(i,9)=VStartSL_V6_NEW;
         VhistorySL(i,10)=time2;
        VhistorySL(i,11)=l;
        
      
end;

i=i+1;
end;
    





for i=1:0
figure;
hold on;stairs(Vhistory(1:draw,1), '-.k');xlabel('probki');ylabel('V');
hold on;plot(Vhistory(1:draw,2),'-r'); %Vhm
hold on;plot(Vhistory(1:draw,4),'-k'); %V
%hold on;stairs(VhistoryR(1:draw,1), '-.g');
hold on;plot(VhistoryR(1:draw,2),'-b'); %Vhm
hold on;plot(VhistoryR(1:draw,4),'-g'); %V
figure;
hold on;plot(Vhistory(1:draw,3), '-r');xlabel('probki');ylabel('czas t (sec)');
hold on;plot(Vhistory(1:draw,5),'-k')
hold on;plot(VhistoryR(1:draw,3),'-b')
hold on;plot(VhistoryR(1:draw,5),'-g')
end;
