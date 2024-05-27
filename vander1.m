function [A, a, pol] = vander1(x, y)
    x = str2num(x);
    y = str2num(y);
    n = length(x) - 1;
    x=x';
    y=y';
    syms X;
    A=vander(x); 
    b=y;
    a=inv(A)*b;
    pol = poly2sym(a', X);
    a = a';
    pol = vpa(pol,10);
    f = matlabFunction(pol);
    pol = char(pol);
    csv_file_path = "tablas/vander1.csv";
    writematrix(A, csv_file_path);

    x_vals = linspace(min(x), max(x), 100);
    y_vals = f(x_vals);

    figure;
    plot(x_vals, y_vals, 'LineWidth', 2);
    hold on;
    plot(x, y, 'ro');
    title('Polinomio de Interpolacion Vandermonde');
    xlabel('x');
    ylabel('y');
    legend('Polinomio interpolado', 'Puntos de datos', 'Location', 'Best');
    grid on;

    saveas(gcf, 'static\images\vander1.png')
    %{
    xpol=-2:0.01:3;
    p=a(1)*xpol.^3+a(2)*xpol.^2+a(3)*xpol+a(4);
    plot(x,y,'r*',xpol,p,'b-')
    hold on
    grid on
    %}
end