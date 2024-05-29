function [n, xn, fm, E, respuesta] = PuntoFijo(func, fung, x0, Tol, niter, error)

    syms x

    f = str2sym(func);
    g = str2sym(fung);

    % Inicializar contador y arrays de resultados
    c = 0;
    %Se usa el c+1 para indexar las posiciones en los arrays. TODO este bloquecito es para la 0
    fm(c + 1) = eval(subs(f, x0));  % Evaluar la función f en x0
    fe = fm(c + 1);  % Inicializar fe con el valor de f en x0
    E(c + 1) = Tol + 1;  % Inicializar el error con un valor mayor que la tolerancia
    error = E(c + 1);  % Asignar el error inicial
    xn(c + 1) = x0;  % Asignar el valor inicial a xn
    N(c + 1) = c;  % Inicializar el contador de iteraciones


    while error > Tol && fe ~= 0 && c < niter
        xn(c + 2) = eval(subs(g, x0));  % Calcular el siguiente valor de xn usando g(x)
        fm(c + 2) = eval(subs(f, xn(c + 2)));  % Evaluar la función f en el nuevo valor de xn
        fe = fm(c + 2);  % Actualizar fe con el valor de f en xn

        % Calcular el error relativo o absoluto según corresponda
        if error == 1
            E(c + 2) = abs((xn(c + 2) - x0) / xn(c + 2));
            error = E(c + 2);            
        else 
            E(c + 2) = abs((xn(c + 2) - x0));
            error = E(c + 2);
        end

        % Actualizar x0 para la siguiente iteración
        x0 = xn(c + 2);
        % Incrementar el contador de iteraciones
        N(c + 2) = c + 1;
        c = c + 1;
    end

    % Determinación de la respuesta final
    if fe == 0
        s = x0;
        n = c;
        fprintf('%f es raiz de f(x)', x0)
        disp(['      n                Xn                   Fx                   Error'])
        D = [N' xn' fm' E'];
    elseif error < Tol
        s = x0;
        n = c;
        fprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f', x0, Tol)
        disp(['      n                Xn                   Fx                   Error'])
        D = [N' xn' fm' E'];
        disp(D)
    else 
        s = x0;
        n = c;
        fprintf('Fracasó en %f iteraciones', niter) 
    end

    tabla = table(N', xn', fm', E', 'VariableNames', {'Iteration', 'xi', 'fxi', 'Error'});
    csv_file_path = "tablas/punto_fijo_tabla.csv";
    writetable(tabla, csv_file_path)

    % Determinación de la respuesta de salida
    if abs(fm(n + 1)) <= Tol
        respuesta = sprintf('%f es una aproximación de una raíz de f(x)', xn(n + 1));
    else
        respuesta = 'No se encontró una solución con la precisión requerida';
    end
end
