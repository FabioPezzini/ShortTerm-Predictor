
previsionemape=[];
for i=1:103
    t=misureDet(i,:);
    mer1D=t(1,1);
    gio1D=t(1,2);
    ven1D=t(1,3);
    sab1D=t(1,4);
    dom1D=t(1,5);
    lun1D=t(1,6);
    mar1D=t(1,7);
    phiFour = ones(size(mer1D));
    for n = 1:1
    phiFour = [phiFour, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
    end
    previsionemape=[previsionemape phiFour*thetaCapFour14+meanTot];
end
valoreatteso=misure(:,1);
valoreatteso(1)=[];
valoreatteso=[valoreatteso ; y2fin];
MAPE=mean((abs(previsionemape(:)-valoreatteso(:))./valoreatteso(:)));
MAPE