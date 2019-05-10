function [m_hat] = prediz(week)

    merP = week(1,1);
    gioP = week(1,2);
    venP = week(1,3);
    sabP = week(1,4);
    domP = week(1,5);
    lunP = week(1,6);
    marP = week(1,7);
    
    thetaCap = [2.21035023425329;0.0945698564132268;-0.228754541144681;-1.74487897772585;-0.639202145829186;2.54553462429046;1.74220020181766;-1.32021658471695;-0.377400865104519;0.113193368587403;-0.0729883204943708;1.11466075190314;-0.169998772376709;-0.481731140110238;-0.997117789612126];
    meanTot = [32.8418963672593]; %media delle misure dei due anni
    w = 1;
   
    for n = 1:1
        phiFourPrev = [1, cos(n*w.*merP),sin(n*w.*merP),cos(n*w.*gioP),sin(n*w.*gioP),cos(n*w.*venP),sin(n*w.*venP),cos(n*w.*sabP),sin(n*w.*sabP),cos(n*w.*domP),sin(n*w.*domP),cos(n*w.*lunP),sin(n*w.*lunP),cos(n*w.*marP),sin(n*w.*marP)];
    end
    
    PREVISIONE = phiFourPrev * thetaCap + meanTot

    
end