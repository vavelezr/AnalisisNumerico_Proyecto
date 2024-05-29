function [T] = Spline(d, x, y)

    x = str2num(x);
    y = str2num(y);
    
    n = length(x);
    A = zeros((d+1)*(n-1));
    b = zeros((d+1)*(n-1),1);
    
    cua = x.^2;
    cub = x.^3;

    %% Lineal
    if d == 1
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=x(i);
            A(i,c+1)=1;
            b(i)=y(i);
            c=c+2;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=x(i);
            A(h,c+1)=1;
            b(h)=y(i);
            c=c+2;
            h=h+1;
        end

    %% Cuadratic
    elseif d == 2
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=cua(i);
            A(i,c+1)=x(i);
            A(i,c+2)=1;
            b(i)=y(i);
            c=c+3;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=cua(i);
            A(h,c+1)=x(i);
            A(h,c+2)=1;
            b(h)=y(i);
            c=c+3;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=2*x(i);
            A(h,c+1)=1;
            A(h,c+3)=-2*x(i);
            A(h,c+4)=-1;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        A(h,1)=2;
        b(h)=0;
        
    %% Cubic
    elseif d == 3
        c=1;
        h=1;
        for i=1:n-1
            A(i,c)=cub(i);
            A(i,c+1)=cua(i);
            A(i,c+2)=x(i);
            A(i,c+3)=1;
            b(i)=y(i);
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n
            A(h,c)=cub(i);
            A(h,c+1)=cua(i);
            A(h,c+2)=x(i);
            A(h,c+3)=1;
            b(h)=y(i);
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=3*cua(i);
            A(h,c+1)=2*x(i);
            A(h,c+2)=1;
            A(h,c+4)=-3*cua(i);
            A(h,c+5)=-2*x(i);
            A(h,c+6)=-1;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        c=1;
        for i=2:n-1
            A(h,c)=6*x(i);
            A(h,c+1)=2;
            A(h,c+4)=-6*x(i);
            A(h,c+5)=-2;
            b(h)=0;
            c=c+4;
            h=h+1;
        end
        
        A(h,1)=6*x(1);
        A(h,2)=2;
        b(h)=0;
        h=h+1;
        A(h,c)=6*x(end);
        A(h,c+1)=2;
        b(h)=0;
    end


    val = inv(A) * b;
    Tabla = reshape(val, d+1, n-1);
    Tabla = Tabla';


    pts = (1:n-1)';
    if d==1
        T = table(pts, Tabla(:,1), Tabla(:,2), 'VariableNames', {'polinomio','a', 'b'});
    elseif d==2
        T = table(pts, Tabla(:,1), Tabla(:,2), Tabla(:,3), 'VariableNames', {'polinomio','a', 'b', 'c'});
    else
        T = table(pts, Tabla(:,1), Tabla(:,2), Tabla(:,3), Tabla(:,4), 'VariableNames',  {'polinomio','a', 'b', 'c', 'd'});
    end

    csv_path = 'tablas/spline_tabla.csv';
    writetable(T, csv_path);

%{
    x_vals = linspace(min(x), max(x), 100);
    y_vals = polyval(flipud(val), x_vals);


    plot(x_vals, y_vals, 'b-', 'LineWidth', 2);
    hold on;
    plot(x, y, 'ro');
    title('Interpolación Spline');
    xlabel('x');
    ylabel('y');
    legend('Spline interpolado', 'Puntos de datos', 'Location', 'Best');
    grid on;
    

    saveas(fig, 'static/images/spline.png');
    close(fig);
end
%}
% Graficar cada segmento del spline
    fig = figure;
    hold  on;
    for i=1:n-1
        x_vals = linspace((x(i)), x(i+1), 100);
        if d==1
            y_vals = Tabla(i,1)*x_vals + Tabla(i,2);
        elseif d==2
            y_vals = Tabla(i,1)*x_vals.^2 + Tabla(i,2)*x_vals + Tabla(i,3);
        else
            y_vals = Tabla(i,1)*x_vals.^3 + Tabla(i,2)*x_vals.^2 + Tabla(i,3)*x_vals + Tabla(i,4);
        end
        plot(x_vals, y_vals, 'b-', 'LineWidth', 2);
    end

    % Graficar los puntos originales
    plot(x, y, 'ro');

    title('Interpolación Spline');
    xlabel('x');
    ylabel('y');
    legend('Spline interpolado', 'Puntos de datos', 'Location', 'Best');
    grid on;

    % Guardar la imagen
    saveas(fig, 'static/images/spline.png');
    close(fig);
    end