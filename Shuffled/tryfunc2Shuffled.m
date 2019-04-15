close all;

%N.B = Runnare prima main e poi il tryfunc (questo per poter ricavare prima
%i thetaCap)

%La funzione richiede la scrittura in T (array 1x6) delle misure rilevate
%da giovedi' a martedi' ed effettua la predizione sul mercoledi

T = [35,1401788389583 35,5871627635417 34,9352095785 33,6609246901667 28,9101644515417 25,5626735807917 33,8653852538333];
%Ho scelto una settimana a caso dal dataset , inserendo da mer a mar e
%cercando di trovare il mer successivo

mer = T(1,1);
gio = T(1,2);
ven = T(1,3);
sab = T(1,4);
dom = T(1,5);
lun = T(1,6);
mar = T(1,7);

w = 1; %  2 * pi/365;
phiFourPrev = ones(size(mer));
for n = 1:12
    phiFourPrev = [phiFourPrev, cos(n*w.*mer),sin(n*w.*mer),cos(n*w.*gio),sin(n*w.*gio),cos(n*w.*ven),sin(n*w.*ven),cos(n*w.*sab),sin(n*w.*sab),cos(n*w.*dom),sin(n*w.*dom),cos(n*w.*lun),sin(n*w.*lun),cos(n*w.*mar),sin(n*w.*mar)];
end

PREVISIONE = phiFourPrev * thetaCapFour;

%Atteso: 35,3478288770833    dati da 315 a 322
%Previsione: 35.269515609556755


%OTTIMO

% Mi salvo il ThetaCap Ottimale