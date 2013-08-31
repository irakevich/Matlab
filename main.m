clearvars -except LBTA4 LBTA5 LBTA4OLD LBTA5OLD;
% LBTA dla roznych L oraz N
% HeuristicMethodSpecialNeighbourhood
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

draw=340;
H=zeros(draw,6);
SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes(1); 
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
l=2300;
N=l/4;
[L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr,l);

for j=1:draw

%[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=RandomRandom(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
CheckHardConstraints(XwgrOr);

j
H(j,1)=j;
H(j,2)=VOr;

if (mod(j,10)==1)
         N=l/5;
end;

if (mod(j,20)==1)
        l=l-100;
       N=l/4;
       [L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr,l);
end;
    
    disp(sprintf('length(L) %g',length(L)));
    disp(sprintf('N %g',N));
  
tic    
    [Vsl,Xwgrsl,Ewrzsl,HEwrzsl,N]=HeuristicMethod_V5_SL(XwgrOr,EwrzOr,HEwrzOr,VOr,L,N);    
time=toc;
CheckHardConstraints(Xwgrsl);
H(j,3)=Vsl;
H(j,5)=length(L);
H(j,6)=N;
H(j,4)=time;

  
   if 0==1
        %tic
            [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
            CheckHardConstraints(Xwgrhm);  
            H(j,1)=Vhm;
            disp(Vhm);
        %toc
  % end;
    % if (j==1)
        %tic 
            [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);
            CheckHardConstraints(Xwgr);  
            H(j,2)=V;
            disp(V);
        %toc
    end;



end;

