%Lagrange: Calcula los coeficientes del polinomio de interpolación de
% grado n-1 para el conjunto de n datos (x,y), mediante el método de
% Lagrange.
function [pol, pol_str] = Lagrange(x, y)
    x = str2num(x);
    y = str2num(y);
    n = length(x);
    Tabla = zeros(n, n);
    for i = 1:n
        Li = 1;
        den = 1;
        for j = 1:n
            if j ~= i
                paux = [1 -x(j)];
                Li = conv(Li, paux);
                den = den * (x(i) - x(j));
            end
        end
        Tabla(i, :) = y(i) * Li / den;
    end
    pol = sum(Tabla);
    
    % Crear una cadena de texto con el polinomio formateado
    pol_str = sprintf('f(x) = ');
    for i = 1:length(pol)
        coef = pol(i);
        if coef ~= 0
            if coef > 0 && i > 1
                pol_str = [pol_str, ' + '];
            elseif coef < 0
                pol_str = [pol_str, ' - '];
                coef = abs(coef);
            end
            if coef ~= 1 || i == length(pol)
                pol_str = [pol_str, sprintf('%.4f', coef)];
            end
            if i < length(pol)
                pol_str = [pol_str, sprintf(' x^%d', length(pol) - i)];
            end
        end
    end

    % Guardar la tabla en un archivo CSV
    csv_file_path = "tablas/lagrange_tabla.csv";
    writematrix(Tabla, csv_file_path);

    % Mostrar el polinomio de interpolación
    disp('Polinomio de interpolacion Lagrange:');
    disp(pol);
    % Generar valores de x para graficar
    xpol = min(x):0.001:max(x);
    p = zeros(size(xpol));
    
    % Calcular el polinomio para cada grado
    for i = 1:length(pol)
        p = p + pol(i) * xpol.^(length(pol) - i);
    end

    % Crear la figura y ajustar parámetros para que se vea igual que en NewtonIntComp
    fig = figure;
    plot(xpol, p, 'b-', 'LineWidth', 2);
    hold on;
    plot(x, y, 'ro');
    title('Interpolación de Lagrange');
    xlabel('x');
    ylabel('y');
    legend('Polinomio interpolado', 'Puntos de datos', 'Location', 'Best');
    grid on;

    % Guardar la gráfica en un archivo JPG
    saveas(fig, 'static/images/lagrange.png');
    close(fig);
end
