previsionemape=[];
for i=1:103
    t=misure(i,:);
    mer1=t(1,1);
    gio1=t(1,2);
    ven1=t(1,3);
    sab1=t(1,4);
    dom1=t(1,5);
    lun1=t(1,6);
    mar1=t(1,7);
    for n = 1:1
    phiL1 = [ones(length(mer1),1),mer1,gio1,ven1,sab1,dom1,lun1,mar1];
    end
    previsionemapeL1=[previsionemape phiL1*thetaCapL1];
end
valoreatteso=misure(:,1);
valoreatteso(1)=[];
valoreatteso=[valoreatteso ; y2fin];
MAPE=mean((abs(previsionemapeL1(:)-valoreatteso(:))./valoreatteso(:)));
MAPE