clear all
close all 
clc

%Carico i dati all'interno di una tabella
data = readtable('data.xlsx','Range','A2:C732');
dataTab = data {:,:};
dataTabOutlier = filloutliers(dataTab(isoutlier(dataTab(:,3)),:), 'center'); %rimpiazzo outliers con i valori di center
dataTabCp1 = dataTab(1:365,:);  
dataTabCp2 = dataTab(366:730,:);
meanSetOutlier475 = mean([dataTab(475-7,3), dataTab(475+7,3)]); % non essendo soddisfatto dei valori dei nuovi outliers questi vengono ricalcolati
meanSetOutlier476 = mean([dataTab(476-7,3), dataTab(476+7,3)]); % come media del giorno stesso della settimana precendente e quella della successiva
dataTab(475,3)=meanSetOutlier475;
dataTab(476,3)=meanSetOutlier476;
dataTabCorrected = [dataTab(dataTab(:,1)==110,3),dataTab(dataTab(:,1)==111,3)];

trend1=detrend(dataTabCp1(:,3));
trend2=dataTabCp2(:,3);
trend2(isnan(trend2))=33;
trend2=detrend(trend2);

meanY1 = nanmean(dataTabCp1(:,3));
meanY2 = nanmean(dataTabCp2(:,3));
cost = meanY1 - meanY2;
meanTot = nanmean(dataTab(:,3));
ratioY1 = (meanY1 / meanTot);
ratioY2 = (meanY2 / meanTot);
dataTabCp2(:,3) = trend2;
dataTabCp1(:,3) = trend1;

figure(1)
subplot(2,2,1)
plot(dataTabCp1(:,1), dataTabCp1(:,3));
title('andamento primo anno')
hold on
plot(dataTabCp1(:,1),trend1)
subplot(2,2,2)
plot(dataTabCp2(:,1), dataTabCp2(:,3));
title('andamento secondo anno')
hold on
plot(dataTabCp1(:,1),trend2)
subplot(2,2,[3,4])
scatter(dataTabCp1(:,1), dataTabCp1(:,3));
hold on  
scatter(dataTabCp2(:,1), dataTabCp2(:,3));
title('andamento complessivo')

figure(2)
subplot(1,2,1)
plot(dataTabCp1(:,1), trend1);
title('andamento primo anno detrendizzato') 
subplot(1,2,2)
plot(dataTabCp2(:,1), trend2);
title('andamento secondo anno detrendizzato') 


%Carico i dati all'interno di una tabella
dataTabDet = vertcat(dataTabCp1, dataTabCp2);
dataTabCp = dataTab;
dataTabCpDet = dataTabDet;
meanTotN = nanmean(dataTab(:,3) - 0.15);


%Salvo ultimo mercoledi che sara' usato come risultato
y2fin = dataTab(:,3);
y2fin = y2fin(729,:);

%Salvo ultimo mercoledi che sara' usato come risultato DETRENDIZZAZIONE
y2finD = dataTabDet(:,3);
y2finD = y2finD(729,:);


%Cancello la settimana con il NaN
count = 1;
while (count <= 7)
   dataTabCp(632,:) = [];
   count=count+1;
end

%Tolgo gli ultimi due dati poiche verranno usati solo come misura utile
%alla predizione
count = 1;
while (count <= 2)
   dataTabCp(722,:) = [];
   count=count+1;
end

dataTabCp = dataTabCp(:,3);

%Salvo ultimo mercoledi che sara' usato come risultato CON DETRENDIZZAZIONE
y2finD = dataTabDet(:,3);
y2finD = y2finD(729,:);

%Cancello la settimana con il NaN CON DETRENDIZZAZIONE
count = 1;
while (count <= 7)
   dataTabCpDet(632,:) = [];
   count=count+1;
end

%Tolgo gli ultimi due dati poiche verranno usati solo come misura utile
%alla predizione CON DETRENDIZZAZIONE
count = 1;
while (count <= 2)
   dataTabCpDet(722,:) = [];
   count=count+1;
end

dataTabCpDet = dataTabCpDet(:,3);


%Creo delle settimane
for i=1:103
    for c=1:7
      misure(i,c)= dataTabCp(c,:);  
    end
    for a=1:7
        dataTabCp(1,:)=[];
    end
end

%Creo delle settimane con detrendizzazione(buone solo per fourier)
for i=1:103
    for c=1:7
      misureDet(i,c)= dataTabCpDet(c,:);  
    end
    for a=1:7
        dataTabCpDet(1,:)=[];
    end
end

rng(730);
%Mischio casualmente le settimane 
shuffledArray = misure(randperm(size(misure,1)),:);
%IN QUESTO MODO HO SETTIMANE DA MERCOLEDI A MARTEDI CASUALI, CONTENENTI
%ANNO 1 E ANNO 2

settimane(1:70,1) = 1:70;
settimaneVal(1:33,1) = 1:33;

mer = shuffledArray(:,1);
mer1= mer(1:70,:);
mer2= mer(71:103,:);
gio = shuffledArray(:,2);
gio1= gio(1:70,:);
gio2= gio(71:103,:);
ven = shuffledArray(:,3);
ven1= ven(1:70,:);
ven2= ven(71:103,:);
sab = shuffledArray(:,4);
sab1= sab(1:70,:);
sab2= sab(71:103,:);
dom = shuffledArray(:,5);
dom1= dom(1:70,:);
dom2= dom(71:103,:);
lun = shuffledArray(:,6);
lun1= lun(1:70,:);
lun2= lun(71:103,:);
mar = shuffledArray(:,7);
mar1= mar(1:70,:);
mar2= mar(71:103,:);


rng(730);
%Mischio casualmente le settimane detrendizzate
shuffledArray = misureDet(randperm(size(misure,1)),:);
merD = shuffledArray(:,1);
mer1D= mer(1:70,:);
mer2D= mer(71:103,:);
gioD = shuffledArray(:,2);
gio1D= gio(1:70,:);
gio2D= gio(71:103,:);
venD = shuffledArray(:,3);
ven1D= ven(1:70,:);
ven2D= ven(71:103,:);
sabD = shuffledArray(:,4);
sab1D= sab(1:70,:);
sab2D= sab(71:103,:);
domD = shuffledArray(:,5);
dom1D= dom(1:70,:);
dom2D= dom(71:103,:);
lunD = shuffledArray(:,6);
lun1D= lun(1:70,:);
lun2D= lun(71:103,:);
marD = shuffledArray(:,7);
mar1D= mar(1:70,:);
mar2D= mar(71:103,:);

%il mercoledi lo devo dare come ingresso, come uscita stimo il successivo!
merOrdinati = misure(:,1);
y = merOrdinati;
y(1,:) = [];
y1 = y(1:70); %tolgo il primo che e' solo un dato e stimo l' 81 esimo
%Visualizzo i consumi in relazione al giorno della settimana
y2 = y(71:102);
y2 = vertcat(y2,y2fin);

%il mercoledi lo devo dare come ingresso, come uscita stimo il successivo!
%DETRENDIZZATO
merOrdinatiD = misureDet(:,1);
yD = merOrdinatiD;
y1D = yD(1:70); 
%tolgo il primo che e' solo un dato e stimo l' 81 esimo
%Visualizzo i consumi in relazione al giorno della settimana
y2D = yD(71:102);
y2D = vertcat(y2D,y2finD);

%////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%%Proviamo con la retta
phiL1 = [ones(length(mer1),1),mer1,gio1,ven1,sab1,dom1,lun1,mar1];
thetaCapL1 = phiL1 \ y1;
misuraStimataL1 = phiL1 * thetaCapL1;
scartoL1 = y1 - misuraStimataL1;
SSRL1 = scartoL1' * scartoL1;

phiL1VAL = [ones(length(mer2),1),mer2,gio2,ven2,sab2,dom2,lun2,mar2];
misuraStimataL1VAL = phiL1VAL * thetaCapL1;
scartoL1VAL = y2 - misuraStimataL1VAL;
SSRL1VAL = scartoL1VAL' * scartoL1VAL;

figure(2000)
scatter(settimane,y1,'r','o');
title('lineare ordine 1')
hold on
scatter(settimane,misuraStimataL1,'b','x');
%Un primo approccio e' la stima lineare di ordine 2 LS
% model to fit  z = a0 + a1x + a2y + a3x^2 + a4y^2 + a5xy

phiL2 = [ones(length(mer1),1),mer1,gio1,ven1,sab1,dom1,lun1,mar1,mer1.*gio1,mer1.*ven1,mer1.*sab1,mer1.*dom1,mer1.*lun1,mer1.*mar1,gio1.*ven1,gio1.*sab1,gio1.*dom1,gio1.*lun1,gio1.*mar1,gio1.*mer1,ven1.*sab1,ven1.*dom1,ven1.*lun1,ven1.*mar1,ven1.*mer1,sab1.*dom1,sab1.*lun1,sab1.*mar1,sab1.*mer1,dom1.*lun1,dom1.*mar1,dom1.*mer1,lun1.*mar1,lun1.*mer1,mar1.*mer1,mer1.^2,gio1.^2,ven1.^2,sab1.^2,dom1.^2,lun1.^2,mar1.^2];
thetaCapL2 = phiL2 \ y1;
misuraStimataL2 = phiL2 * thetaCapL2;
scartoL2 = y1 - misuraStimataL2;
SSRL2 = scartoL2' * scartoL2;

phiL2VAL = [ones(length(mer2),1),mer2,gio2,ven2,sab2,dom2,lun2,mar2,mer2.*gio2,mer2.*ven2,mer2.*sab2,mer2.*dom2,mer2.*lun2,mer2.*mar2,gio2.*ven2,gio2.*sab2,gio2.*dom2,gio2.*lun2,gio2.*mar2,gio2.*mer2,ven2.*sab2,ven2.*dom2,ven2.*lun2,ven2.*mar2,ven2.*mer2,sab2.*dom2,sab2.*lun2,sab2.*mar2,sab2.*mer2,dom2.*lun2,dom2.*mar2,dom2.*mer2,lun2.*mar2,lun2.*mer2,mar2.*mer2,mer2.^2,gio2.^2,ven2.^2,sab2.^2,dom2.^2,lun2.^2,mar2.^2];
misuraStimataL2VAL = phiL2VAL * thetaCapL2;
scartoL2VAL = y2 - misuraStimataL2VAL;
SSRL2VAL = scartoL2VAL' * scartoL2VAL;

figure (3);
subplot(2,1,1);
scatter(settimane,y1,'r','o');
hold on;
scatter(settimane,misuraStimataL2,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Lineare Ordine 2');

settimaneVal(1:33,1) = 1:33;
subplot(2,1,2);
scatter(settimaneVal,y2,'r','o');
hold on;
scatter(settimaneVal,misuraStimataL2VAL,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Lineare Ordine 2 VALIDAZIONE');

%//////////////////////////////////////////////////////////////////////////
%Provo con stima lineare di ordine 3
phiL3 = [phiL2,(mer1.^2).*gio1,(mer1.^2).*ven1,(mer1.^2).*sab1,(mer1.^2).*dom1,(mer1.^2).*lun1,(mer1.^2).*mar1,(gio1.^2).*mer1,(gio1.^2).*ven1,(gio1.^2).*sab1,(gio1.^2).*dom1,(gio1.^2).*lun1,(gio1.^2).*mar1,(ven1.^2).*mer1,(ven1.^2).*gio1,(ven1.^2).*sab1,(ven1.^2).*dom1,(ven1.^2).*lun1,(ven1.^2).*mar1,(sab1.^2).*mer1,(sab1.^2).*gio1,(sab1.^2).*ven1,(sab1.^2).*dom1,(sab1.^2).*lun1,(sab1.^2).*mar1,(1.^2).*mer1,(dom1.^2).*gio1,(dom1.^2).*ven1,(dom1.^2).*sab1,(dom1.^2).*lun1,(dom1.^2).*mar1,(lun1.^2).*mer1,(lun1.^2).*gio1,(lun1.^2).*ven1,(lun1.^2).*sab1,(lun1.^2).*dom1,(lun1.^2).*mar1,(mar1.^2).*mer1,(mar1.^2).*gio1,(mar1.^2).*ven1,(mar1.^2).*sab1,(mar1.^2).*dom1,(mar1.^2).*lun1,mer1.^3,gio1.^3,ven1.^3,sab1.^3,dom1.^3,lun1.^3,mar1.^3];
thetaCapL3 = phiL3 \ y1;
misuraStimataL3 = phiL3 * thetaCapL3;
scartoL3 = y1 - misuraStimataL3;
SSRL3 = scartoL3' * scartoL3;

phiL3VAL = [phiL2VAL, mer2.^3,gio2.^3,ven2.^3,sab2.^3,dom2.^3,lun2.^3,mar2.^3,(mer2.^2).*gio2,(mer2.^2).*ven2,(mer2.^2).*sab2,(mer2.^2).*dom2,(mer2.^2).*lun2,(mer2.^2).*mar2,(gio2.^2).*mer2,(gio2.^2).*ven2,(gio2.^2).*sab2,(gio2.^2).*dom2,(gio2.^2).*lun2,(gio2.^2).*mar2,(ven2.^2).*mer2,(ven2.^2).*gio2,(ven2.^2).*sab2,(ven2.^2).*dom2,(ven2.^2).*lun2,(ven2.^2).*mar2,(sab2.^2).*mer2,(sab2.^2).*gio2,(sab2.^2).*ven2,(sab2.^2).*dom2,(sab2.^2).*lun2,(sab2.^2).*mar2,(dom2.^2).*mer2,(dom2.^2).*gio2,(dom2.^2).*ven2,(dom2.^2).*sab2,(dom2.^2).*lun2,(dom2.^2).*mar2,(lun2.^2).*mer2,(lun2.^2).*gio2,(lun2.^2).*ven2,(lun2.^2).*sab2,(lun2.^2).*dom2,(lun2.^2).*mar2,(mar2.^2).*mer2,(mar2.^2).*gio2,(mar2.^2).*ven2,(mar2.^2).*sab2,(mar2.^2).*dom2,(mar2.^2).*lun2];
misuraStimataL3VAL = phiL3VAL * thetaCapL3;
scartoL3VAL = y2 - misuraStimataL3VAL;
SSRL3VAL = scartoL3VAL' * scartoL3VAL;

figure (4);
subplot(2,1,1);
scatter(settimane,y1,'r','o');
hold on;
scatter(settimane,misuraStimataL3,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Lineare Ordine 3');

subplot(2,1,2);
scatter(settimaneVal,y2,'r','o');
hold on;
scatter(settimaneVal,misuraStimataL3VAL,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Lineare Ordine 3 VALIDAZIONE');

%//////////////////////////////////////////////////////////////////////////
%Si nota un'andamento sinusoidale, provo serie di Fourier
% qui utilizzo i dataset detrendizzati
%N.B = variare il max di n per variare il grado

%14 armoniche
w = 1;
phiFour14 = ones(size(mer1D));
meanFourier = mean([mer1D; gio1D; ven1D; sab1D; dom1D; lun1D; mar1D]);
for n = 1:1
    phiFour14 = [phiFour14, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour14 = phiFour14 \ y1D;
misuraStimataFour14 = phiFour14 * thetaCapFour14 + meanFourier;
scartoFour14 = y1D - misuraStimataFour14;
SSRFOUR14 = scartoFour14' * scartoFour14;

phiFourVAL14 = ones(size(mer2D));
for n = 1:1
    phiFourVAL14 = [phiFourVAL14, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL14 = phiFourVAL14 * thetaCapFour14 + meanFourier;
scartoFourVAL14 = y2D - misuraStimataFourVAL14;
SSRFOURVAL14 = scartoFourVAL14' * scartoFourVAL14;

%28 armoniche
w = 1;
phiFour28 = ones(size(mer1D));
for n = 1:2
    phiFour28 = [phiFour28, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour28 = phiFour28 \ y1D;
misuraStimataFour28 = phiFour28 * thetaCapFour28 + meanFourier;
scartoFour28 = y1D - misuraStimataFour28;
SSRFOUR28 = scartoFour28' * scartoFour28;

phiFourVAL28 = ones(size(mer2D));
for n = 1:2
    phiFourVAL28 = [phiFourVAL28, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL28 = phiFourVAL28 * thetaCapFour28 + meanFourier;
scartoFourVAL28 = y2D - misuraStimataFourVAL28;
SSRFOURVAL28 = scartoFourVAL28' * scartoFourVAL28;

figure (5);
subplot(2,1,1);
scatter(settimane,y1D + meanFourier,'r','o');
hold on;
scatter(settimane,misuraStimataFour14 ,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier 14 armoniche');

subplot(2,1,2);
scatter(settimaneVal,y2D + meanFourier,'r','o');
hold on;
scatter(settimaneVal,misuraStimataFourVAL14,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier 14 VALIDAZIONE');

figure (51);
subplot(2,1,1);
scatter(settimane,y1D + meanFourier,'r','o');
hold on;
scatter(settimane,misuraStimataFour28 ,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier 28 armoniche');

subplot(2,1,2);
scatter(settimaneVal,y2D + meanFourier,'r','o');
hold on;
scatter(settimaneVal,misuraStimataFourVAL28,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier 28 VALIDAZIONE');

%Il risultato e' soddisfacente, lo scarto e' basso
%Provo aumentando il numero di armoniche

%42 ARMONICHE
w = 1;
phiFour42 = ones(size(mer1D));
for n = 1:3
    phiFour42 = [phiFour42, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour42 = phiFour42 \ y1D;
misuraStimataFour42 = phiFour42 * thetaCapFour42 + meanFourier;
scartoFour42 = y1D - misuraStimataFour42;
SSRFOUR42 = scartoFour42' * scartoFour42;

phiFourVAL42 = ones(size(mer2D));
for n = 1:3
    phiFourVAL42 = [phiFourVAL42, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL42 = phiFourVAL42 * thetaCapFour42 + meanFourier;
scartoFourVAL42 = y2D - misuraStimataFourVAL42;
SSRFOURVAL42 = scartoFourVAL42' * scartoFourVAL42;

figure (52);
subplot(2,1,1);
scatter(settimane,y1D + meanFourier,'r','o');
hold on;
scatter(settimane,misuraStimataFour42 ,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier 42');

subplot(2,1,2);
scatter(settimaneVal,y2D + meanFourier,'r','o');
hold on;
scatter(settimaneVal,misuraStimataFourVAL42,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier VALIDAZIONE');

%56 ARMONICHE
w = 1;
phiFour56 = ones(size(mer1D));
for n = 1:4
    phiFour56 = [phiFour56, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour56 = phiFour56 \ y1D;
misuraStimataFour56 = phiFour56 * thetaCapFour56 + meanFourier;
scartoFour56 = y1D - misuraStimataFour56;
SSRFOUR56 = scartoFour56' * scartoFour56;

phiFourVAL56 = ones(size(mer2D));
for n = 1:4
    phiFourVAL56 = [phiFourVAL56, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL56 = phiFourVAL56 * thetaCapFour56 + meanFourier;
scartoFourVAL56 = y2D - misuraStimataFourVAL56;
SSRFOURVAL56 = scartoFourVAL56' * scartoFourVAL56;

figure (53);
subplot(2,1,1);
scatter(settimane,y1D + meanFourier,'r','o');
hold on;
scatter(settimane,misuraStimataFour56 ,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier56');

subplot(2,1,2);
scatter(settimaneVal,y2D + meanFourier,'r','o');
hold on;
scatter(settimaneVal,misuraStimataFourVAL56,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier VALIDAZIONE');

%70 ARMONICHE
w = 1;
phiFour70 = ones(size(mer1D));
for n = 1:5
    phiFour70 = [phiFour70, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour70 = phiFour70 \ y1D;
misuraStimataFour70 = phiFour70 * thetaCapFour70 + meanFourier;
scartoFour70 = (y1D + meanFourier) - misuraStimataFour70;
SSRFOUR70 = scartoFour70' * scartoFour70;


phiFourVAL70 = ones(size(mer2D));
for n = 1:5
    phiFourVAL70 = [phiFourVAL70, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL70 = phiFourVAL70 * thetaCapFour70 + meanFourier;
scartoFourVAL70 = y2D - misuraStimataFourVAL70;
SSRFOURVAL70 = scartoFourVAL70' * scartoFourVAL70;

%84 ARMONICHE
w = 1;
phiFour84 = ones(size(mer1D));
for n = 1:6
    phiFour84 = [phiFour84, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour84 = phiFour84 \ (y1D + meanFourier);
misuraStimataFour84 = phiFour84 * thetaCapFour84 + meanFourier;
scartoFour84 = (y1D + meanFourier) - misuraStimataFour84;
SSRFOUR84 = scartoFour84' * scartoFour84;


phiFourVAL84 = ones(size(mer2D));
for n = 1:6
    phiFourVAL84 = [phiFourVAL84, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL84 = phiFourVAL84 * thetaCapFour84 + meanFourier;
scartoFourVAL84 = y2D - misuraStimataFourVAL84;
SSRFOURVAL84 = scartoFourVAL84' * scartoFourVAL84;

%98 ARMONICHE
w = 1;
phiFour98 = ones(size(mer1D));
for n = 1:7
    phiFour98 = [phiFour98, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour98 = phiFour98 \ (y1D + meanFourier);
misuraStimataFour98 = phiFour98 * thetaCapFour98 + meanFourier;
scartoFour98 = (y1D + meanFourier) - misuraStimataFour98;
SSRFOUR98 = scartoFour98' * scartoFour98;


phiFourVAL98 = ones(size(mer2D));
for n = 1:7
    phiFourVAL98 = [phiFourVAL98, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL98 = phiFourVAL98 * thetaCapFour98 + meanFourier;
scartoFourVAL98 = y2D - misuraStimataFourVAL98;
SSRFOURVAL98 = scartoFourVAL98' * scartoFourVAL98;

%112 ARMONICHE
w = 1;
phiFour112 = ones(size(mer1D));
for n = 1:8
    phiFour112 = [phiFour112, cos(n*w.*mer1D),sin(n*w.*mer1D),cos(n*w.*gio1D),sin(n*w.*gio1D),cos(n*w.*ven1D),sin(n*w.*ven1D),cos(n*w.*sab1D),sin(n*w.*sab1D),cos(n*w.*dom1D),sin(n*w.*dom1D),cos(n*w.*lun1D),sin(n*w.*lun1D),cos(n*w.*mar1D),sin(n*w.*mar1D)];
end
thetaCapFour112 = phiFour112 \ (y1D + meanFourier);
misuraStimataFour112 = phiFour112 * thetaCapFour112 + meanFourier;
scartoFour112 = (y1D + meanFourier) - misuraStimataFour112;
SSRFOUR112 = scartoFour112' * scartoFour112;


phiFourVAL112 = ones(size(mer2D));
for n = 1:8
    phiFourVAL112 = [phiFourVAL112, cos(n*w.*mer2D),sin(n*w.*mer2D),cos(n*w.*gio2D),sin(n*w.*gio2D),cos(n*w.*ven2D),sin(n*w.*ven2D),cos(n*w.*sab2D),sin(n*w.*sab2D),cos(n*w.*dom2D),sin(n*w.*dom2D),cos(n*w.*lun2D),sin(n*w.*lun2D),cos(n*w.*mar2D),sin(n*w.*mar2D)];
end
misuraStimataFourVAL112 = phiFourVAL112 * thetaCapFour112 + meanFourier;
scartoFourVAL112 = y2D - misuraStimataFourVAL112;
SSRFOURVAL112 = scartoFourVAL112' * scartoFourVAL112;

%----------------------------------------------------------------------------------------------------------------------
%Utilizzo una rete neurale con ingresso due input
%Utilizzo un solo layer nascosto, con 20 neuroni
%Utilizzando algoritmo Bayesiano, il grafico di regressione esce

x = [mer gio ven sab dom lun mar]';
t = (vertcat(y1,y2))';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.PEGGIORE
% 'trainbr' takes longer but may be better for challenging problems.MIGLIORE
% 'trainscg' uses less memory. Suitable in low memory situations. 
trainFcn = 'trainscg';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
%net.divideFcn = 'dividerand';  % Divide data randomly
%net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 65/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 25/100;
 
% Choose a Performance Function 
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Getting the ThetaCap
thetaCapNET = getwb(net);

%Getting the number of targets used
nt = length(tr.trainInd);

% Test the Network
out = net(x);
e = gsubtract(t,y);
scartoNET = vertcat(y1,y2) - out';
SSRNET = scartoNET' * scartoNET;
performance = perform(net,t,out);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotregression(t,y)
% figure, plotfit(net,x,t)
figure (6);
settimane(1:103,1) = 1:103;
scatter(settimane,vertcat(y1,y2),'r','o');
hold on;
scatter(settimane,out','b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Rete Neurale');
%-------------------------------------------------------

%Per concluder testo i modelli ricavati con le varie tecniche
%TEST FPE
fpeL1 = ((length(vertcat(y1,y2))+length(thetaCapL1))/(length(vertcat(y1,y2))-length(thetaCapL1))) * SSRL1;
fpeL2 = ((length(vertcat(y1,y2))+length(thetaCapL2))/(length(vertcat(y1,y2))-length(thetaCapL2))) * SSRL2;
fpeL3 = ((length(vertcat(y1,y2))+length(thetaCapL3))/(length(vertcat(y1,y2))-length(thetaCapL3))) * SSRL3;
fpeFOUR28 = ((length(vertcat(y1,y2))+length(thetaCapFour28))/(length(vertcat(y1,y2))-length(thetaCapFour28))) * SSRFOUR28;

%TEST FPE VAL
fpeL1VAL = ((length(vertcat(y1,y2))+length(thetaCapL1))/(length(vertcat(y1,y2))-length(thetaCapL1))) * SSRL1VAL;
fpeL2VAL = ((length(vertcat(y1,y2))+length(thetaCapL2))/(length(vertcat(y1,y2))-length(thetaCapL2))) * SSRL2VAL;
fpeL3VAL = ((length(vertcat(y1,y2))+length(thetaCapL3))/(length(vertcat(y1,y2))-length(thetaCapL3))) * SSRL3VAL;
fpeFOUR28VAL = ((length(vertcat(y1,y2))+length(thetaCapFour28))/(length(vertcat(y1,y2))-length(thetaCapFour28))) * SSRFOURVAL28;

fpe = ([fpeL1, fpeL2, fpeL3, fpeFOUR28]);
fpeVAL = ([fpeL1VAL, fpeL2VAL, fpeL3VAL, fpeFOUR28VAL]);

figure(7)
num1 = linspace(200,112,4);
title('scatter FPE')
scatter(num1, fpe)
hold on
scatter(num1, fpeVAL , 'r', 'x')

%TEST AIC
aicL1 = (2*length(thetaCapL1)/length(y1))+log(SSRL1);
aicL2 = (2*length(thetaCapL2)/length(y1))+log(SSRL2);
aicL3 = (2*length(thetaCapL3)/length(y1))+log(SSRL3);
aicFOUR14 = (2*length(thetaCapFour14)/length(y1))+log(SSRFOUR14);
aicFOUR28 = (2*length(thetaCapFour28)/length(y1))+log(SSRFOUR28);
aicFOUR42 = (2*length(thetaCapFour42)/length(y1))+log(SSRFOUR42);
aicFOUR56 = (2*length(thetaCapFour56)/length(y1))+log(SSRFOUR56);
aicFOUR70 = (2*length(thetaCapFour70)/length(y1))+log(SSRFOUR70);
aicFOUR84 = (2*length(thetaCapFour84)/length(y1))+log(SSRFOUR84);
aicFOUR98 = (2*length(thetaCapFour98)/length(y1))+log(SSRFOUR98);
aicFOUR112 = (2*length(thetaCapFour112)/length(y1))+log(SSRFOUR112);
aicNET = (2*length(thetaCapNET)/nt)+log(SSRNET);

%TEST AIC VAL
aicL1VAL = (2*length(thetaCapL1)/length(y))+log(SSRL1VAL);
aicL2VAL = (2*length(thetaCapL2)/length(y))+log(SSRL2VAL);
aicL3VAL = (2*length(thetaCapL2)/length(y))+log(SSRL3VAL);
aicFOURVAL14 = (2*length(thetaCapFour14)/length(y2))+log(SSRFOURVAL14);
aicFOURVAL28 = (2*length(thetaCapFour28)/length(y2))+log(SSRFOURVAL28);
aicFOURVAL42 = (2*length(thetaCapFour42)/length(y2))+log(SSRFOURVAL42);
aicFOURVAL56 = (2*length(thetaCapFour56)/length(y2))+log(SSRFOURVAL56);
aicFOURVAL70 = (2*length(thetaCapFour70)/length(y2))+log(SSRFOURVAL70);
aicFOURVAL84 = (2*length(thetaCapFour84)/length(y2))+log(SSRFOURVAL84);
aicFOURVAL98 = (2*length(thetaCapFour98)/length(y2))+log(SSRFOURVAL98);
aicFOURVAL112 = (2*length(thetaCapFour112)/length(y2))+log(SSRFOURVAL112);

aic = [aicFOUR14 , aicFOUR28 , aicFOUR42 , aicFOUR56 , aicFOUR70 , aicFOUR84 , aicFOUR98 , aicFOUR112];
aicVAL = [aicFOURVAL14 , aicFOURVAL28 , aicFOURVAL42 , aicFOURVAL56 , aicFOURVAL70 , aicFOURVAL84 , aicFOURVAL98 , aicFOURVAL112];
aicLin = [aicL1, aicL2, aicL3];
aicLinVAL = [aicL1VAL, aicL2VAL, aicL3VAL];

figure(8);
num = linspace(14,112,8);
plot(num, aic);
grid on
hold on
plot(num, aicVAL);
title('Confronto AIC Fourier');
legend('Identificazione','Validazione');
xlabel('N armoniche');
ylabel('AIC');

figure(9);
num = linspace(14,112,3);
plot(num, aicLin);
grid on
hold on
plot(num, aicLinVAL);
title('Confronto AIC Lineare');
legend('Identificazione','Validazione');
xlabel('Ordine');
ylabel('AIC');

%MDL
mdlL1 = (log(length(misure))*length(thetaCapL1))/length(misure) + log(SSRL1);
mdlL2 = (log(length(misure))*length(thetaCapL2))/length(misure) + log(SSRL2);
mdlL3 = (log(length(misure))*length(thetaCapL3))/length(misure) + log(SSRL3);
mdlFOUR28= (log(length(misure))*length(thetaCapFour28))/length(misure) + log(SSRFOUR28);
mdlFOUR14 = (log(length(misure))*length(thetaCapFour14))/length(misure) + log(SSRFOUR14);
mdlNET = (log(length(misure))*length(thetaCapNET))/length(misure) + log(SSRNET);

%MDL
mdlL1VAL = (log(length(misure))*length(thetaCapL1))/length(misure) + log(SSRL1VAL);
mdlL2VAL = (log(length(misure))*length(thetaCapL2))/length(misure) + log(SSRL2VAL);
mdlL3VAL = (log(length(misure))*length(thetaCapL3))/length(misure) + log(SSRL3VAL);
mdlFOUR28VAL = (log(length(misure))*length(thetaCapFour28))/length(misure) + log(SSRFOURVAL28);
mdlFOUR14VAL = (log(length(misure))*length(thetaCapFour14))/length(misure) + log(SSRFOURVAL14);


mdl = [mdlFOUR14,mdlFOUR28 , mdlNET, mdlL1, mdlL2, mdlL3];
mdlVAL = [mdlFOUR14VAL,mdlFOUR28VAL , mdlNET,mdlL1VAL, mdlL2VAL, mdlL3VAL];

figure(10);
num = linspace(14,112,6);
scatter(num, mdl);
grid on
hold on
scatter(num, mdlVAL);
title('Confronto MDL');
legend('Identificazione','Validazione');
ylabel('MDL');

%Grazie al Test AIC ed ai grafici si nota che sia i modello migliori
%risultano essere: Fourier con 28 armoniche, Fourier con 14 armoniche anche se la lineare
%di ordine 2 in alcuni casi si comporta meglio!

%CALCOLO MAPE
elinID = gsubtract(y1,misuraStimataL2);
elinVAL = gsubtract(y2,misuraStimataL2VAL);
efouID = gsubtract(y1,misuraStimataFour14);
efouVAL = gsubtract(y2,misuraStimataFourVAL14);
efou28ID = gsubtract(y1,misuraStimataFour28);
efou28VAL = gsubtract(y2,misuraStimataFourVAL28);
MAPEnet = mean(abs(e./t));
MAPElin2ID = mean(abs(elinID./y1));
MAPElin2VAL = mean(abs(elinVAL./y2));
MAPEfouID = mean(abs(efouID./y1));
MAPEfouVAL = mean(abs(efouVAL./y2));
MAPEfou28ID = mean(abs(efou28ID./y1));
MAPEfou28VAL = mean(abs(efou28VAL./y2));

pause
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

PREVISIONE = phiFourPrev * thetaCapFour14 + meanFourier;

%Tentativo con modello lineare.... risultato scarso rispetto a Fourier 
phiLPrev = [ones(length(mer),1),mer,gio,ven,sab,dom,lun,mar];
PREVISIONELINEARE =  phiLPrev * thetaCapL1;
%PREVISIONENET = 

%Atteso: 33.119001948874995    dati da 315 a 322