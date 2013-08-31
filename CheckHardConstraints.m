function CheckHardConstraints(Xwgr)


if (find(squeeze(sum(Xwgr(:,:,:),3))~=1)>0) 
        squeeze(sum(Xwgr(:,:,:),3))
        disp('Brak spelnienia twardych ograniczen');
        pause;
 end;
 if (find(squeeze(sum(Xwgr(:,:,:),2))>1)>0)
        squeeze(sum(Xwgr(:,:,:),2))
        disp('Brak spelnienia twardych ograniczen');
        pause;
 end; 