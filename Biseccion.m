function [respuesta, s, E, fm] = Biseccion(func, xi, xs, Tol, niter)
    % Declarar x como símbolo para evaluar expresiones simbólicas
    syms x

    % Inicializar variables de respuesta y valores predeterminados
    respuesta = "Error: No se encontró una raíz en el intervalo de la función";
    s = NaN;  % Valor predeterminado para s
    E = NaN;  % Valor predeterminado para E
    fm = NaN;  % Valor predeterminado para fm

    % Convertir la función ingresada como cadena a una expresión simbólica
    f = str2sym(func);
    % Evaluar la función en los límites del intervalo inicial
    fi = eval(subs(f, xi));
    fs = eval(subs(f, xs));

    % Verificar si alguno de los límites es una raíz exacta
    if fi == 0
        s = xi;
        E = 0;
        fprintf('%f es raíz de f(x)', xi);
    elseif fs == 0
        s = xs;
        E = 0;
        fprintf('%f es raíz de f(x)', xs);

    % Verificar que los límites del intervalo tengan signos opuestos
    elseif fs * fi < 0
        % Inicializar contador y calcular el punto medio
        c = 0;
        xm = (xi + xs) / 2;
        % Evaluar la función en el punto medio
        fm(c + 1) = eval(subs(f, xm));
        fe = fm(c + 1);
        % Inicializar el error para asegurar que el bucle se ejecute al menos una vez
        E(c + 1) = Tol + 1;
        error = E(c + 1);

        % Inicializar arrays para almacenar los valores de la iteración
        Iteration = [];
        a = [];
        b = [];
        Xm = [];
        func = [];
        Error = [];

        % Bucle principal de iteración
        while error > Tol && fe ~= 0 && c < niter
            % Almacenar los valores actuales en los arrays
            Iteration = [Iteration, c];
            a = [a, xi];
            b = [b, xs];
            Xm = [Xm, xm];
            func = [func, fe];
            Error = [Error, error];

            % Determinar el nuevo intervalo en función del signo de f(xm)
            if fi * fe < 0
                xs = xm;
                fs = eval(subs(f, xs));
            else
                xi = xm;
                fi = eval(subs(f, xi));
            end
            % Actualizar el valor de la iteración anterior y calcular el nuevo punto medio
            xa = xm;
            xm = (xi + xs) / 2;
            fm(c + 2) = eval(subs(f, xm));
            fe = fm(c + 2);

            % Calcular el error relativo o absoluto según corresponda
            if (error == 1)
                E(c + 2) = abs((xm - xa) / xm);
                error = E(c + 2);
            else
                E(c + 2) = abs(xm - xa);
                error = E(c + 2);
            end
            % Incrementar el contador
            c = c + 1;
        end

        % Creación de la tabla de resultados
        tabla = table(Iteration', a', Xm', b', func', Error', 'VariableNames', {'Iteración', 'a', 'xi', 'b', 'fxi', 'Error'});
        csv_file_path = "tablas/biseccion_tabla.csv"; 
        
        writetable(tabla, csv_file_path);

        % Determinación de la respuesta final
        if fe == 0
            s = xm;
            respuesta = sprintf('%f es raíz de f(x)', xm);
        elseif error < Tol
            s = xm;
            respuesta = sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia de %f', xm, Tol);
        else
            s = xm;
            respuesta = sprintf('Fracasó en %f iteraciones', niter);
        end 
    else

        respuesta = sprintf('Ha ocurrido un error: el intervalo es inadecuado, Reformula');
    end
end