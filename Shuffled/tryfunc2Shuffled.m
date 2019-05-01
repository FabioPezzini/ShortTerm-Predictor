close all;

%N.B = Runnare prima main e poi il tryfunc (questo per poter ricavare prima
%i thetaCap)

%La funzione richiede la scrittura in T (array 1x7) delle misure rilevate
%da giovedi' a mercoledi' ed effettua la predizione sul mercoledi' succ

T = [33.887096283666665 34.322414632125000 34.652158858541670 33.578615787583340 28.956420815750004 25.413061986749995 32.052170129833335];
%Ho scelto una settimana a caso dal dataset , inserendo da mer a mar e
%cercando di trovare il mer successivo

mer = T(1,1);
gio = T(1,2);
ven = T(1,3);
sab = T(1,4);
dom = T(1,5);
lun = T(1,6);
mar = T(1,7);

w = 1;
phiFourPrev = ones(size(mer));
for n = 1:1
    phiFourPrev = [phiFourPrev, cos(n*w.*mer),sin(n*w.*mer),cos(n*w.*gio),sin(n*w.*gio),cos(n*w.*ven),sin(n*w.*ven),cos(n*w.*sab),sin(n*w.*sab),cos(n*w.*dom),sin(n*w.*dom),cos(n*w.*lun),sin(n*w.*lun),cos(n*w.*mar),sin(n*w.*mar)];
end

PREVISIONE = phiFourPrev * thetaCapFour14;

%Tentativo con modello lineare.... risultato scarso rispetto a Fourier 
phiLPrev = [ones(length(mer),1),mer,gio,ven,sab,dom,lun,mar,mer.*gio,mer.*ven,mer.*sab,mer.*dom,mer.*lun,mer.*mar,gio.*ven,gio.*sab,gio.*dom,gio.*lun,gio.*mar,gio.*mer,ven.*sab,ven.*dom,ven.*lun,ven.*mar,ven.*mer,sab.*dom,sab.*lun,sab.*mar,sab.*mer,dom.*lun,dom.*mar,dom.*mer,lun.*mar,lun.*mer,mar.*mer,mer.^2,gio.^2,ven.^2,sab.^2,dom.^2,lun.^2,mar.^2];
PREVISIONELINEARE =  phiLPrev * thetaCapL2;

%Atteso: 33.119001948874995    dati da 315 a 322