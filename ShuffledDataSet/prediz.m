function [m_hat] = prediz(week)

    merP = week(1,1);
    gioP = week(1,2);
    venP = week(1,3);
    sabP = week(1,4);
    domP = week(1,5);
    lunP = week(1,6);
    marP = week(1,7);
    
    mainShuffled;
    
    w = 1;
   
    for n = 1:1
        phiFourPrev = [1, cos(n*w.*merP),sin(n*w.*merP),cos(n*w.*gioP),sin(n*w.*gioP),cos(n*w.*venP),sin(n*w.*venP),cos(n*w.*sabP),sin(n*w.*sabP),cos(n*w.*domP),sin(n*w.*domP),cos(n*w.*lunP),sin(n*w.*lunP),cos(n*w.*marP),sin(n*w.*marP)];
    end
    
    PREVISIONE = phiFourPrev * thetaCapFour14

    
end