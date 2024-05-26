function [A, a, pol] = vander1(x, y)
    x = str2num(x);
    y = str2num(y);
    x=x';
    y=y';
    syms X;
    A=[x.^3 x.^2 x ones(length(x),1)];
    b=y;
    a=inv(A)*b;
    pol = poly2sym(a', X);
    a = a';
    pol = vpa(pol,10);
    pol = char(pol);
    csv_file_path = "tablas/vander1.csv";
    writematrix(A, csv_file_path);
    xpol=-2:0.01:3;
    p=a(1)*xpol.^3+a(2)*xpol.^2+a(3)*xpol+a(4);
    plot(x,y,'r*',xpol,p,'b-')
    hold on
    grid on