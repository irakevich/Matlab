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

draw=1;
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
    [XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
end;
C6wr=zeros(W,R);[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);

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

cup=1;
if (cup==1)
     
         [wf,C6wr]=SetPunishment();
         
         [XwgrOr_V6, EwrzOr_V6,HEwrzOr_V6,CwgrOr_V6,CwrgOr_V6]=AlgorithmConstrctiveAssignmentHeuristic_V6(Hwgz,Awgz,C6wr,wf);
         [VOr_V6]=CalculateTheCostOfAllAssignment(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,C6wr);

        disp('----------------- Znajdz rozwiazanie + na konec Set the punishment CUP ---------------------------------------------');
        [V_C6]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
        tic
        [VAfterCup,cWRR, XwgrAfterCup,EwrzAfterCup,HEwrzAfterCup]= HeuristicMethodSpecialNeighbourhood_V6(Xwgr,Ewrz,HEwrz,V_C6,wf,C6wr); % puchar=1;
              if (find(squeeze(sum(Xwgr(:,:,:),3))~=1)>0) 
                squeeze(sum(Xwgr(:,:,:),3)) 
            end;
            if (find(squeeze(sum(Xwgr(:,:,:),2))>1)>0)
                squeeze(sum(Xwgr(:,:,:),2))
            end;
        timet1=toc;
       
       
          disp('----------------- Poczatkowe rozwiazanie poprawnie ---------------------------------------------');
        [VSCup_V6,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhood_V6(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,VOr_V6,wf,C6wr); % puchar=1;
       
        disp('----------------- Poczatkowe rozwiazanie+ with the punishment CUP ---------------------------------------------');
        tic
        [VOrCup]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        [VSCup,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhood_V6(XwgrOr,EwrzOr,HEwrzOr,VOrCup,wf,C6wr); % puchar=1;
        timet2=toc;
        disp(sprintf('!!!!!VOr,  V ,V_C6, VAfterCup ,VOrCup,VSCup,VOr_V6,VSCup_V6 %g %g %g %g %g %g %g %g %g ',VOr,  V ,V_C6, VAfterCup ,VOrCup,VSCup, VOr_V6,VSCup_V6 ));
           
        
        
        
        
            disp('----------------- Znajdz rozwiazanie + na konec Set the punishment CUP ---------------------------------------------');
        
        [VAfterSL]=CalculateTheCostOfAllAssignment(Xwgrsl,Ewrzsl,HEwrzsl,C6wr);
        [L]=ListBasedTresholdAccepting_V6(Xwgrsl,Ewrzsl,HEwrzsl,l,wf,C6wr);  
        tic
        [VAfterSL_V6,XwgrV6,EwrzV6,HEwrzV6,krok]=HeuristicMethod_V6_SL(Xwgrsl,Ewrzsl,HEwrzsl,VAfterSL,L,N,wf,C6wr);
         time1=toc;
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
          disp('----------------- Poczatkowe rozwiazanie+ with the punishment CUP ---------------------------------------------');
        
        [VStartSL]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        [L]=ListBasedTresholdAccepting_V6(XwgrOr,EwrzOr,HEwrzOr,l,wf,C6wr);  
        tic
        [VStartSL_V6,XwgrV6S,EwrzV6S,HEwrzV6S,krok]=HeuristicMethod_V6_SL(XwgrOr,EwrzOr,HEwrzOr,VStartSL,L,N,wf,C6wr);
         time2=toc;
        
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
       
       
        disp('----------------- Poczatkowe rozwiazanie poprawnie ---------------------------------------------');
        [L]=ListBasedTresholdAccepting_V6(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,l,wf,C6wr);  
        tic
        [V6S,XwgrV6S,EwrzV6S,HEwrzV6S,krok]=HeuristicMethod_V6_SL(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6, VOr_V6,L,N,wf,C6wr);
         time2=toc;
       
        VStartSL_V6_NEW=12345;
        if krok==500000
            tic
             [V6S_NEW,XwgrV6S,EwrzV6S,HEwrzV6S]=HeuristicMethod_V6_SL_NEW(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6, VOr_V6,L,N,wf,C6wr);
             time2=toc;
        end;     
            if (find(squeeze(sum(XwgrV6S(:,:,:),3))~=1)>0) 
                squeeze(sum(XwgrV6S(:,:,:),3)) 
            end;
            if (find(squeeze(sum(XwgrV6S(:,:,:),2))>1)>0)
                squeeze(sum(XwgrV6S(:,:,:),2))
            end;
       
      
         disp(sprintf('!!!!!VOr, Vsl_V5,VAfterSL ,VAfterSL_V6, VStartSL ,VStartSL_V6, VOr_V6, V6S %g %g %g %g %g %g %g %g',VOr, Vsl_V5,VAfterSL ,VAfterSL_V6, VStartSL ,VStartSL_V6,VOr_V6, V6S ));
end;

i=i+1;
end;
    

