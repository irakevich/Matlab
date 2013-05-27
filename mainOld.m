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

if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;



tic
SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes ();
[Xwgr, Ewrz,HEwrz,Cwgr,Cwrg]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);

cWRR = ones(W,R,R-1)*inf;
disp('kara')
[V]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz)
for w=1:W
    for r=1:R
        for r1 = r+1:R
            if r ~= r1
                if sum(Xwgr(w,:,r),2)+sum(Xwgr(w,:,r1),2) > 0
                    tmpX = Xwgr(w,:,r1);
                    Xwgr(w,:,r1) = Xwgr(w,:,r);
                    Xwgr(w,:,r) = tmpX;
                    tmpE = Ewrz(w,r,:);
                    Ewrz(w,r,:) = Ewrz(w,r1,:);
                    Ewrz(w,r1,:) = tmpE;
                    tmpHE = HEwrz(w,r,:);
                    HEwrz(w,r,:) = HEwrz(w,r1,:);
                    HEwrz(w,r1,:) = tmpHE;

                    [V] = CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz);
                    cWRR(w,r1,r) = V;
                    Xwgr(w,:,r) = Xwgr(w,:,r1);
                    Xwgr(w,:,r1) = tmpX;
                    Ewrz(w,r1,:) = Ewrz(w,r,:);
                    Ewrz(w,r,:) = tmpE;
                    HEwrz(w,r1,:) = HEwrz(w,r,:);
                    HEwrz(w,r,:) = tmpHE;
                end
            end
        end
    end
end
toc

