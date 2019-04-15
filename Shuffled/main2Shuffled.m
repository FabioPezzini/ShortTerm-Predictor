clc;
clear;
close all;

%Carico i dati all'interno di vettori distinti
data = readtable('data.xlsx','Range','A2:C723');
dataTab = data {:,:};
dataTabCp = dataTab(:,3);

for i=1:103
    for c=1:7
      misure(i,c)= dataTabCp(c,:)    
    end
    for a=1:7
        dataTabCp(1,:)=[];
    end
end

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
y1 = y(1:70); %tolgo il primo che e' solo un dato e stimo il 71 esimoy2 = y(70,
%Visualizzo i consumi in relazione al giorno della settimana
y2 = y(70:102);

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

%come previsto una lineare di ordine 2 non approssima per niente l'andamento!

%//////////////////////////////////////////////////////////////////////////
%Provo con stima lineare di ordine 3

phiL3 = [phiL2, mer1.^3,gio1.^3,ven1.^3,sab1.^3,dom1.^3,lun1.^3,mar1.^3,(mer1.^2).*gio1,(mer1.^2).*ven1,(mer1.^2).*sab1,(mer1.^2).*dom1,(mer1.^2).*lun1,(mer1.^2).*mar1,(gio1.^2).*mer1,(gio1.^2).*ven1,(gio1.^2).*sab1,(gio1.^2).*dom1,(gio1.^2).*lun1,(gio1.^2).*mar1,(ven1.^2).*mer1,(ven1.^2).*gio1,(ven1.^2).*sab1,(ven1.^2).*dom1,(ven1.^2).*lun1,(ven1.^2).*mar1,(sab1.^2).*mer1,(sab1.^2).*gio1,(sab1.^2).*ven1,(sab1.^2).*dom1,(sab1.^2).*lun1,(sab1.^2).*mar1,(1.^2).*mer1,(dom1.^2).*gio1,(dom1.^2).*ven1,(dom1.^2).*sab1,(dom1.^2).*lun1,(dom1.^2).*mar1,(lun1.^2).*mer1,(lun1.^2).*gio1,(lun1.^2).*ven1,(lun1.^2).*sab1,(lun1.^2).*dom1,(lun1.^2).*mar1,(mar1.^2).*mer1,(mar1.^2).*gio1,(mar1.^2).*ven1,(mar1.^2).*sab1,(mar1.^2).*dom1,(mar1.^2).*lun1];
thetaCapL3 = phiL3 \ y1;
misuraStimataL3 = phiL3 * thetaCapL3;
scartoL3 = y1 - misuraStimataL3;
SSRL3 = scartoL3' * scartoL3;

phiL3VAL = [phiL2VAL, mer2.^3,gio2.^3,ven2.^3,sab2.^3,dom2.^3,lun2.^3,mar2.^3,(mer2.^2).*gio2,(mer2.^2).*ven2,(mer2.^2).*sab2,(mer2.^2).*dom2,(mer2.^2).*lun2,(mer2.^2).*mar2,(gio2.^2).*mer2,(gio2.^2).*ven2,(gio2.^2).*sab2,(gio2.^2).*dom2,(gio2.^2).*lun2,(gio2.^2).*mar2,(ven2.^2).*mer2,(ven2.^2).*gio2,(ven2.^2).*sab2,(ven2.^2).*dom2,(ven2.^2).*lun2,(ven2.^2).*mar2,(sab2.^2).*mer2,(sab2.^2).*gio2,(sab2.^2).*ven2,(sab2.^2).*dom2,(sab2.^2).*lun2,(sab2.^2).*mar2,(dom2.^2).*mer2,(dom2.^2).*gio2,(dom2.^2).*ven2,(dom2.^2).*sab2,(dom2.^2).*lun2,(dom2.^2).*mar2,(lun2.^2).*mer2,(lun2.^2).*gio2,(lun2.^2).*ven2,(lun2.^2).*sab2,(lun2.^2).*dom2,(lun2.^2).*mar2,(mar2.^2).*mer2,(mar2.^2).*gio2,(mar2.^2).*ven2,(mar2.^2).*sab2,(mar2.^2).*dom2,(mar2.^2).*lun2];
misuraStimataL3VAL = phiL3VAL * thetaCapL3;
scartoL3VAL = y2 - misuraStimataL3VAL;
SSRL3VAL = scartoL3VAL' * scartoL3VAL;

%l'SSR e' diminuito di poco rispetto al 2 ordine

%//////////////////////////////////////////////////////////////////////////
%Si nota un'andamento sinusoidale, provo serie di Fourier
%N.B = variare il max di n per variare il grado

w = 1; %era 2 * pi / 365 ma con 1 (come suggerito dal tutore) e' meglio!!
phiFour = ones(size(mer1));
for n = 1:12
    phiFour = [phiFour, cos(n*w.*mer1),sin(n*w.*mer1),cos(n*w.*gio1),sin(n*w.*gio1),cos(n*w.*ven1),sin(n*w.*ven1),cos(n*w.*sab1),sin(n*w.*sab1),cos(n*w.*dom1),sin(n*w.*dom1),cos(n*w.*lun1),sin(n*w.*lun1),cos(n*w.*mar1),sin(n*w.*mar1)];
end
thetaCapFour = phiFour \ y1;
misuraStimataFour = phiFour * thetaCapFour;
scartoFour = y1 - misuraStimataFour;
SSRFOUR = scartoFour' * scartoFour;


phiFourVAL = ones(size(mer2));
for n = 1:12
    phiFourVAL = [phiFourVAL, cos(n*w.*mer2),sin(n*w.*mer2),cos(n*w.*gio2),sin(n*w.*gio2),cos(n*w.*ven2),sin(n*w.*ven2),cos(n*w.*sab2),sin(n*w.*sab2),cos(n*w.*dom2),sin(n*w.*dom2),cos(n*w.*lun2),sin(n*w.*lun2),cos(n*w.*mar2),sin(n*w.*mar2)];
end
misuraStimataFourVAL = phiFourVAL * thetaCapFour;
scartoFourVAL = y2 - misuraStimataFourVAL;
SSRFOURVAL = scartoFourVAL' * scartoFourVAL;


%Si nota che il modello mediante serie di Fourier risulta essere il
%migliore, provo a Crossvalidarlo con i dati del secondo anno
%N.B= adattare l' n massimo con quello in identificazione e togliere meta'
%dati


%Il risultato e' soddisfacente, lo scarto e' basso

%----------------------------------------------------------------------------------------------------------------------
%Utilizzo una rete neurale con ingresso due input
%Utilizzo un solo layer nascosto, con 20 neuroni
%Utilizzando algoritmo Bayesiano, il grafico di regressione esce

%ATTENZIONE VA SISTEMATO IL t, NON DEVO USARE MER, PIUTTOSTO TOLTO UN DATO
%DAGLI INGRESSI

x = [mer gio ven sab dom lun mar]';
t = mer';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

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
scartoNET = mer - out';
SSRNET = scartoNET' * scartoNET;
performance = perform(net,t,out);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

%-------------------------------------------------------
%In ultima analisi provo a creare un modello su stima di Fourier basato
%in ingresso sui dati della settimana e come misura uso il mercoledi



%Per concluder testo i modelli ricavati con le varie tecniche
%TEST FPE
fpeL2 = ((length(mer)+length(thetaCapL2))/(length(mer)-length(thetaCapL2))) * SSRL2;
fpeL3 = ((length(mer)+length(thetaCapL3))/(length(mer)-length(thetaCapL3))) * SSRL3;

fpeFOUR = ((length(mer)+length(thetaCapFour))/(length(mer)-length(thetaCapFour))) * SSRFOUR;

%TEST AIC
aicL2 = (2*length(thetaCapL2)/length(mer))+log(SSRL2);
aicL3 = (2*length(thetaCapL3)/length(mer))+log(SSRL3);
aicFOUR2 = (2*length(thetaCapFour)/length(mer))+log(SSRFOUR);
aicNET = (2*length(thetaCapNET)/nt)+log(SSRNET);

%Si nota che il modello migliore e' il FOUR2! Facciamo una predizione!
