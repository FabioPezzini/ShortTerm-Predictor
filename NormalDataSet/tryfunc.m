close all;

%N.B = Runnare prima main e poi il tryfunc (questo per poter ricavare prima
%i thetaCap)

%La funzione richiede la scrittura in T (array 1x6) delle misure rilevate
%da giovedi' a martedi' ed effettua la predizione sul mercoledi

T = [33.887096283666665 34.322414632125000 34.652158858541670 33.578615787583340 28.956420815750004 25.413061986749995 32.052170129833335];
%Ho scelto una settimana a caso dal dataset , inserendo da mer a mar e
%cercando di trovare il mer successivo

mer1 = T(1,1);
gio1 = T(1,2);
ven1 = T(1,3);
sab1 = T(1,4);
dom1 = T(1,5);
lun1 = T(1,6);
mar1 = T(1,7);

phiL2PREV = [ones(length(mer1),1),mer1,gio1,ven1,sab1,dom1,lun1,mar1,mer1.*gio1,mer1.*ven1,mer1.*sab1,mer1.*dom1,mer1.*lun1,mer1.*mar1,gio1.*ven1,gio1.*sab1,gio1.*dom1,gio1.*lun1,gio1.*mar1,gio1.*mer1,ven1.*sab1,ven1.*dom1,ven1.*lun1,ven1.*mar1,ven1.*mer1,sab1.*dom1,sab1.*lun1,sab1.*mar1,sab1.*mer1,dom1.*lun1,dom1.*mar1,dom1.*mer1,lun1.*mar1,lun1.*mer1,mar1.*mer1,mer1.^2,gio1.^2,ven1.^2,sab1.^2,dom1.^2,lun1.^2,mar1.^2];

PREVISIONE = phiL2PREV * thetaCapL2;

%Atteso: 33.119001948874995    dati da 315 a 322