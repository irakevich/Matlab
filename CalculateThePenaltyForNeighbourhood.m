function [cWRR]= CalculateThePenaltyForNeighbourhood(cWRR,Xwgr,Ewrz,HEwrz,wf)

global W
global R
 for w=wf:W % zaczynamy od koljeki [wf:W. Zak³adamy ze od [1:wf)=? meczy sie odby³y
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

                        [Vv] = CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz);
                        cWRR(w,r1,r) = Vv;

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