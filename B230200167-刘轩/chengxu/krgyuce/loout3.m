L18x=cell(1,910);
for j=1:910
    Cd = regrkrg(Y{1,j},X{1,j},@regpoly2,@corrgauss,2,0.01,100);
    f = regpoly2(X{1,j});
    loout= predkrg2(X1{1,j},Cd,f,0.01);
    L18x{j}=loout;
end                                                                                          