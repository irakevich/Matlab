clear all;
%rodzia³ 5.5
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
draw=100;
Vhistory=zeros(draw,3);
VhistoryS=zeros(draw,10);

SetTheParameters();
i=1;
VOr=0;
while VOr==0
[Hwgz,Awgz]=GenerateMatrixes (1); 
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
C6wr=zeros(W,R);
[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr)
end;
while i<=draw 
    i
%disp('--------------------- start  -----------------------------');


tic 
    wf=1; C6wr=zeros(W,R);
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood_V6(XwgrOr,EwrzOr,HEwrzOr,VOr,1,zeros(W,R));  
    CheckHardConstraints(Xwgr);  
time=toc;

cup=1;
if (cup==1)
     
        [wf,C6wr]=SetPunishment();
        [XwgrOr_V6, EwrzOr_V6,HEwrzOr_V6,CwgrOr_V6,CwrgOr_V6]=AlgorithmConstrctiveAssignmentHeuristic_V6(Hwgz,Awgz,C6wr,wf);
        [VOr_V6]=CalculateTheCostOfAllAssignment(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,C6wr); 
        CheckHardConstraints(XwgrOr_V6);  
         disp('----------------- PO rozpoczêciu sezonu ---------------------------------------------');
        [V_C6]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
        tic
        [VAfterCup,cWRR, XwgrAfterCup,EwrzAfterCup,HEwrzAfterCup]= HeuristicMethodSpecialNeighbourhood_V6(Xwgr,Ewrz,HEwrz,V_C6,wf,C6wr); % puchar=1;
        time1=toc;
         CheckHardConstraints(XwgrAfterCup);  
        
        disp(VAfterCup);
       
          disp('----------------- Przed rozpoczeciem sezonu---------------------------------------------');
        tic
        [VSCup_V6,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhood_V6_P(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,VOr_V6,wf,C6wr); % puchar=1;
        time2=toc;  
         CheckHardConstraints(XwgrC);  
        disp( VSCup_V6);   
        disp('----------------- Poczatkowe rozwiazanie+ kara---------------------------------------------');
       
        [VOrCup]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        [VSCup,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhood_V6_P(XwgrOr,EwrzOr,HEwrzOr,VOrCup,wf,C6wr); % puchar=1;
       
        disp(VSCup);
         disp(sprintf('!!!!!VOr,  V ,V_C6, VAfterCup ,VOr_V6,VSCup_V6,VOrCup,VSCup %g %g %g %g %g %g %g %g %g ',VOr,  V ,V_C6, VAfterCup , VOr_V6,VSCup_V6,VOrCup,VSCup ));
    
        VhistoryS(i,1)=VOr;
        VhistoryS(i,2)=V;
        VhistoryS(i,3)=V_C6;
        VhistoryS(i,4)=VAfterCup;
        VhistoryS(i,5)=time1;
        VhistoryS(i,6)=VOr_V6;
        VhistoryS(i,7)=VSCup_V6;
        VhistoryS(i,8)=time2;
        VhistoryS(i,9)=VOrCup;
        VhistoryS(i,10)=VSCup;
        
       
end;

i=i+1;

end;
    

