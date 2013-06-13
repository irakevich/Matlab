function [cWRR]=CalculateThePenaltyForSpecialNeighbourhood(cWRR,Vwr,Xwgr,Ewrz,HEwrz,C6wr)

global R


V1w=find(sum(Vwr,2)~=0);  %disp(sprintf('length(V1w) %g',length(V1w)));
    for iw=1:length(V1w);
        w=V1w(iw);
        V1r=find(Vwr(w,:)~=0); %disp(sprintf('length(V1r) %g',length(V1r)));
        for ir=1:length(V1r)
            r=V1r(ir);
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

                        [Vnew] = CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
                        if r1 < r
                            cWRR(w,r,r1) = Vnew;
                        else
                            cWRR(w,r1,r) = Vnew;
                        end;
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