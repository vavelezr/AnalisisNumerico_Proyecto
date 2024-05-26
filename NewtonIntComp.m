function [coef, pol, polT] = NewtonIntComp(x, y)
    syms X;
    x = str2num(x);
    y = str2num(y);
    n=length(x);
    Tabla=zeros(n,n+1);
    Tabla(:,1)=x;
    Tabla(:,2)=y;
    for j=3:n+1
        for i=j-1:n
            Tabla(i,j)=(Tabla(i,j-1)-Tabla(i-1,j-1))/(Tabla(i,1)-Tabla(i-j+2,1));
        end
    end
    csv_file_path = "tablas/newtonIntComp.csv";
    writematrix(Tabla, csv_file_path);
    coef = diag(Tabla(:,2:end))';
    n=length(x);
    pol=1;
    acum=pol;
    pol=coef(1)*acum;
    for i=1:n-1
        pol=[0 pol];
        acum=conv(acum,[1 -x(i)]);
        pol=pol+coef(i+1)*acum;
    end
    polT = poly2sym(pol,X);
    polT = vpa(polT, 10);
    f = matlabFunction(polT);
    polT = char(polT);
    x_vals = linspace(min(x), max(x), 100);
    y_vals = f(x_vals);


    figure;
    plot(x_vals, y_vals, 'LineWidth', 2);
    hold on;
    plot(x, y, 'ro');
    title('Polinomio de Interpolacion de Newton');
    xlabel('x');
    ylabel('y');
    legend('Polinomio interpolado', 'Puntos de datos', 'Location', 'Best');
    grid on;

    saveas(gcf, 'static\images\polinomio_interpolacion_newton.png')

end