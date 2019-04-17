clc;
clear;
close all;

%Carico i dati all'interno di una tabella
data = readtable('data.xlsx','Range','A2:C732');
dataTab = data {:,:};
dataTabCp = dataTab;

%Salvo ultimo mercoledi che sara' usato come risultato
y2fin = dataTab(:,3);
y2fin = y2fin(729,:);

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

%Creo delle settimane
for i=1:103
    for c=1:7
      misure(i,c)= dataTabCp(c,:);  
    end
    for a=1:7
        dataTabCp(1,:)=[];
    end
end

%Mischio casualmente le settimane 
shuffledArray = misure(randperm(size(misure,1)),:);
%IN QUESTO MODO HO SETTIMANE DA MERCOLEDI A MARTEDI CASUALI, CONTENENTI
%ANNO 1 E ANNO 2
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

%il mercoledi lo devo dare come ingresso, come uscita stimo il successivo!
y= mer;
y(1,:) = [];
y1 = y(1:70); %tolgo il primo che e' solo un dato e stimo l' 81 esimo
%Visualizzo i consumi in relazione al giorno della settimana
y2 = y(71:102);
y2 = vertcat(y2,y2fin);

%////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

figure (1);
subplot(2,1,1);
settimane(1:70,1) = 1:70;
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

figure (2);
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
%N.B = variare il max di n per variare il grado

w = 1; %era 2 * pi / 365 ma con 1 (come suggerito dal tutore) e' meglio!!
phiFour = ones(size(mer1));
for n = 1:2
    phiFour = [phiFour, cos(n*w.*mer1),sin(n*w.*mer1),cos(n*w.*gio1),sin(n*w.*gio1),cos(n*w.*ven1),sin(n*w.*ven1),cos(n*w.*sab1),sin(n*w.*sab1),cos(n*w.*dom1),sin(n*w.*dom1),cos(n*w.*lun1),sin(n*w.*lun1),cos(n*w.*mar1),sin(n*w.*mar1)];
end
thetaCapFour = phiFour \ y1;
misuraStimataFour = phiFour * thetaCapFour;
scartoFour = y1 - misuraStimataFour;
SSRFOUR = scartoFour' * scartoFour;


phiFourVAL = ones(size(mer2));
for n = 1:2
    phiFourVAL = [phiFourVAL, cos(n*w.*mer2),sin(n*w.*mer2),cos(n*w.*gio2),sin(n*w.*gio2),cos(n*w.*ven2),sin(n*w.*ven2),cos(n*w.*sab2),sin(n*w.*sab2),cos(n*w.*dom2),sin(n*w.*dom2),cos(n*w.*lun2),sin(n*w.*lun2),cos(n*w.*mar2),sin(n*w.*mar2)];
end
misuraStimataFourVAL = phiFourVAL * thetaCapFour;
scartoFourVAL = y2 - misuraStimataFourVAL;
SSRFOURVAL = scartoFourVAL' * scartoFourVAL;

figure (3);
subplot(2,1,1);
scatter(settimane,y1,'r','o');
hold on;
scatter(settimane,misuraStimataFour,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier');

subplot(2,1,2);
scatter(settimaneVal,y2,'r','o');
hold on;
scatter(settimaneVal,misuraStimataFourVAL,'b','x');
xlabel('Numero Settimana');
ylabel('Consumo Energetico');
legend('Atteso','Stimato');
title('Modello Fourier VALIDAZIONE');

%Il risultato e' soddisfacente, lo scarto e' basso

%----------------------------------------------------------------------------------------------------------------------
%Utilizzo una rete neurale con ingresso due input
%Utilizzo un solo layer nascosto, con 20 neuroni
%Utilizzando algoritmo Bayesiano, il grafico di regressione esce

x = [mer gio ven sab dom lun mar]';
t = (vertcat(y1,y2))';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;

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
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)
figure (4);
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
fpeL2 = ((length(vertcat(y1,y2))+length(thetaCapL2))/(length(vertcat(y1,y2))-length(thetaCapL2))) * SSRL2;
fpeL3 = ((length(vertcat(y1,y2))+length(thetaCapL3))/(length(vertcat(y1,y2))-length(thetaCapL3))) * SSRL3;
fpeFOUR = ((length(vertcat(y1,y2))+length(thetaCapFour))/(length(vertcat(y1,y2))-length(thetaCapFour))) * SSRFOUR;

%TEST AIC
aicL2 = (2*length(thetaCapL2)/length(vertcat(y1,y2)))+log(SSRL2);
aicL3 = (2*length(thetaCapL3)/length(vertcat(y1,y2)))+log(SSRL3);
aicFOUR = (2*length(thetaCapFour)/length(vertcat(y1,y2)))+log(SSRFOUR);
aicNET = (2*length(thetaCapNET)/nt)+log(SSRNET);

%Grazie al Test AIC ed ai grafici si nota che sia il modello migliore
%risulta essere sempre quello di Fourier con 8 armoniche anche se la lineare
%di ordine 2 in alcuni casi si comporta meglio!
