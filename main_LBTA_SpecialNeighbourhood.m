clearvars -except LBTA4 LBTA5 LBTA4OLD LBTA5OLD H220 H2sr20 H218 H2sr18;
%5.4 LBTA
global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S

%global cWRR

draw=10;
H2=zeros(draw,10);
SL=zeros(draw,6);
SetTheParameters();
l=800;
N=l/4;

for j=1:draw
if (mod(j,10)==1)
    [Hwgz,Awgz]=GenerateMatrixes(1); 
    tic
    [XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
    time=toc;
    H2(j,1)=time;H2(j+1,1)=time;H2(j+2,1)=time;H2(j+3,1)=time;H2(j+4,1)=time;
    [VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
    VOr
    l=l-100;
    N=l/4;
    [L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr,l);   
end;

CheckHardConstraints(XwgrOr);    


H2(j,2)=VOr;
%%-------------------------- LBTA  ---------------------------------------
tic    
    [Vsl,Xwgrsl,Ewrzsl,HEwrzsl]=HeuristicMethod_V5_SL(XwgrOr,EwrzOr,HEwrzOr,VOr,L,N);
    CheckHardConstraints(Xwgrsl); 
time=toc;  
time
H2(j,3)=Vsl;
H2(j,4)=time;
H2(j,5)=length(L);
H2(j,6)=N;

SL(j,1)=length(L);
SL(j,2)=N;
SL(j,3)=Vsl;
SL(j,4)=time;

%%-------------------------- LBTA NEW ---------------------------------------
tic    
    [VslNEW,Xwgrsl,Ewrzsl,HEwrzsl]=HeuristicMethod_V5_SLNEW(XwgrOr,EwrzOr,HEwrzOr,VOr,L,N);
   CheckHardConstraints(Xwgrsl); 
time=toc; 

H2(j,9)=VslNEW;
H2(j,10)=time;
SL(j,5)=VslNEW;
SL(j,6)=time;



   if 0==1
        %tic
            [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
            CheckHardConstraints(Xwgrhm);  
            H(j,1)=Vhm;
            disp(Vhm);
        %toc
   end;
    % if (j==1)
        tic 
            [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);
            CheckHardConstraints(Xwgr);
            time=toc;
            V
            H2(j,7)=V;
            H2(j,8)=time;
        
   % end;



end;

