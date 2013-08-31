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

draw=50;
VhistorySL=zeros(draw,11);
SetTheParameters();
i=1;
l=800
 N=l/4;
[Hwgz,Awgz]=GenerateMatrixes (1); 
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,zeros(W,R));
VOr
while i<=draw 
    i
%disp('--------------------- start  -----------------------------');

        [wf,C6wr]=SetPunishment();
        [XwgrOr_V6, EwrzOr_V6,HEwrzOr_V6,CwgrOr_V6,CwrgOr_V6]=AlgorithmConstrctiveAssignmentHeuristic_V6(Hwgz,Awgz,C6wr,wf);
        [VOr_V6]=CalculateTheCostOfAllAssignment(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,C6wr); 
        CheckHardConstraints(XwgrOr_V6);  

%if (mod(i,5)==1)
 %     l=l-100;
   
%end;


 %%-------------------------- SL  ---------------------------------------
[L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr,l);   
tic    
    [Vsl_V5,Xwgrsl,Ewrzsl,HEwrzsl]=HeuristicMethod_V5_SL(XwgrOr,EwrzOr,HEwrzOr,VOr,L,N);
time=toc;
    CheckHardConstraints(Xwgrsl);  

cup=1;
if (cup==1)
     
        disp('----------------  PO rozpoczêciu sezonu  ---------------------------------------------');
        
        [VAfterSL]=CalculateTheCostOfAllAssignment(Xwgrsl,Ewrzsl,HEwrzsl,C6wr);  disp(VAfterSL);
        [L]=ListBasedTresholdAccepting_V6(Xwgrsl,Ewrzsl,HEwrzsl,l,wf,C6wr);  
        tic
            [VAfterSL_V6,XwgrV6,EwrzV6,HEwrzV6,krok]=HeuristicMethod_V6_SL(Xwgrsl,Ewrzsl,HEwrzsl,VAfterSL,L,N,wf,C6wr);
        time1=toc;
        disp(VAfterSL_V6);
        VAfterSL_V6_NEW=12345;
        if krok==500000
            tic
             [VAfterSL_V6_NEW,XwgrV6,EwrzV6,HEwrzV6]=HeuristicMethod_V6_SL_NEW(Xwgrsl,Ewrzsl,HEwrzsl,VAfterSL,L,N,wf,C6wr);
              time1=toc;
        end;  
        CheckHardConstraints(XwgrV6); 
        disp(VAfterSL_V6_NEW)
        disp('----------------- Przed rozpoczeciem sezonu---------------------------------------------');
        
        [L]=ListBasedTresholdAccepting_V6(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,l,wf,C6wr);  
        tic
         [VSL_V6S,XwgrV6S,EwrzV6S,HEwrzV6S,krok]=HeuristicMethod_V6_SL_P(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,VOr_V6,L,N,wf,C6wr);
        time2=toc;
        disp(VSL_V6S);
        VSL_V6S_NEW=12345;
        if krok==500000
            tic
             [VSL_V6S_NEW,XwgrV6S,EwrzV6S,HEwrzV6S]=HeuristicMethod_V6_SL_NEW_P(XwgrOr_V6,EwrzOr_V6,HEwrzOr_V6,VOr_V6,L,N,wf,C6wr);
             time2=toc;
        end;   
        CheckHardConstraints(XwgrV6S); 
        disp(VSL_V6S_NEW);
        if (0==1)
            disp('----------------- Poczatkowe rozwiazanie+ kara ---------------------------------------------');

            [VStartSL]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
            [L]=ListBasedTresholdAccepting_V6(XwgrOr,EwrzOr,HEwrzOr,l,wf,C6wr);  
            tic
            [VStartSL_V6,XwgrV6S,EwrzV6S,HEwrzV6S,krok]=HeuristicMethod_V6_SL_P(XwgrOr,EwrzOr,HEwrzOr,VStartSL,L,N,wf,C6wr);
             time3=toc;
            disp(VStartSL_V6);
            VStartSL_V6_NEW=12345;
            if krok==500000
                tic
                 [VStartSL_V6_NEW,XwgrV6S,EwrzV6S,HEwrzV6S]=HeuristicMethod_V6_SL_NEW_P(XwgrOr,EwrzOr,HEwrzOr,VStartSL,L,N,wf,C6wr);
                 time3=toc;
            end;     
            CheckHardConstraints(XwgrV6S); 
            disp(VStartSL_V6_NEW);
        end;
        disp('!!!!!VOr, Vsl_V5,VAfterSL ,VAfterSL_V6,VAfterSL_V6_NEW, VOr_V6,VSL_V6S,VSL_V6S_NEW, VStartSL, VStartSL_V6,  VStartSL_V6_NEW ');
        disp(sprintf('%g %g %g %g %g %g %g %g',VOr, Vsl_V5,VAfterSL,VAfterSL_V6,VAfterSL_V6_NEW, VOr_V6,VSL_V6S,VSL_V6S_NEW));
         VhistorySL(i,1)=l;
         VhistorySL(i,2)=VOr;
        VhistorySL(i,3)=Vsl_V5;
        VhistorySL(i,4)=VAfterSL;
        VhistorySL(i,5)=VAfterSL_V6;
        VhistorySL(i,6)=VAfterSL_V6_NEW;
        VhistorySL(i,7)= time1;
        VhistorySL(i,8)=VOr_V6;
        VhistorySL(i,9)=VSL_V6S;
        VhistorySL(i,10)=VSL_V6S_NEW;
        VhistorySL(i,11)=time2;
       % VhistorySL(i,12)= VStartSL;
       % VhistorySL(i,13)=VStartSL_V6;
       % VhistorySL(i,14)=VStartSL_V6_NEW;
       % VhistorySL(i,15)=time3;
       
        
      
end;

i=i+1;
end;
