function [T, respuesta] = ReglaFalsa(func, x0, x1, Tol, niter, Tipo_error)

    syms x

    f = str2sym(func);
    c = 0; 
    xi(c + 1) = x0; % Límite inferior inicial
    xs(c + 1) = x1; % Límite superior inicial
    fi(c + 1) = eval(subs(f, x0)); % Evaluar f en el límite inferior
    fs(c + 1) = eval(subs(f, x1)); % Evaluar f en el límite superior
    
    % Comprobar si alguno de los límites es una raíz exacta
    if fi(c + 1) == 0
        xm(c + 1) = xi(c + 1); % Asignar raíz como el límite inferior
        fm(c + 1) = eval(subs(f, xm(c + 1))); 
        E(c + 1) = 0; % Error como cero
        respuesta = sprintf('El límite inferior %f es una raíz exacta de f(x)', xi(c + 1)); 
        T = table((0:1:c)', xm', xi', xs', fm', fi', fs', E', 'VariableNames', ["n", "x_m", "x_i", "x_s", "f_m", "f_i", "f_s", "E"]);
    elseif fs(c + 1) == 0
        xm(c + 1) = xs(c + 1); % Asignar raíz como el límite superior
        fm(c + 1) = eval(subs(f, xm(c + 1))); 
        E(c + 1) = 0; 
        respuesta = sprintf('El límite superior %f es una raíz exacta de f(x)', xs(c + 1)); 
        T = table((0:1:c)', xm', xi', xs', fm', fi', fs', E', 'VariableNames', ["n", "x_m", "x_i", "x_s", "f_m", "f_i", "f_s", "E"]); 
    
    % Aplicar la Regla Falsa cuando hay un cambio de signo en el intervalo
    elseif fs(c + 1) * fi(c + 1) < 0
        fi(c + 1) = eval(subs(f, xi)); % Evaluar f en el límite inferior actualizado
        fs(c + 1) = eval(subs(f, xs)); % Evaluar f en el límite superior actualizado
        p = (fs(c + 1) - fi(c + 1)) / (xs(c + 1) - xi(c + 1)); % Calcular la pendiente de la secante
        xm(c + 1) = (p * xi(c + 1) - fi(c + 1)) / p; % Calcular la nueva aproximación de la raíz
        fm(c + 1) = eval(subs(f, xm(c + 1))); % Evaluar f en la nueva aproximación
        fe = fm(c + 1); 
        E(c + 1) = Tol + 1; % Inicializar el error como mayor que la tolerancia
        error = E(c + 1);

        % Bucle principal de iteración
        while error > Tol && fe ~= 0 && c < niter
            % Determinar en qué subintervalo está la raíz
            if fi(c + 1) * fe < 0
                xs(c + 2) = xm(c + 1);
                fs(c + 2) = eval(subs(f, xs(c + 2)));
                xi(c + 2) = xi(c + 1);
                fi(c + 2) = fi(c + 1);
            else
                xi(c + 2) = xm(c + 1);
                fi(c + 2) = eval(subs(f, xi(c + 2)));
                xs(c + 2) = xs(c + 1);
                fs(c + 2) = fs(c + 1);
            end
            % Calcular la pendiente de la recta secante
            p = (fs(c + 2) - fi(c + 2)) / (xs(c + 2) - xi(c + 2)); 
            % Calcular la nueva aproximación de la raíz
            xm(c + 2) = (p * xi(c + 2) - fi(c + 2)) / p; 
            % Evaluar f en la nueva aproximación de la raíz
            fm(c + 2) = eval(subs(f, xm(c + 2))); 
            fe = fm(c + 2); 
            
            % Calcular el error
            if Tipo_error == 0
                E(c + 2) = abs(xm(c + 2) - xm(c + 1)); % Error ABSOLUTO
            else
                E(c + 2) = abs((xm(c + 2) - xm(c + 1)) / xm(c + 2)); % Error RELATIVO
            end
            error = E(c + 2); 
            c = c + 1; 
        end

        % Determinación de la respuesta final
        if fe == 0 
           respuesta = sprintf('%f es una raíz exacta de f(x)', xm(c + 1));
           respuesta = char(respuesta);
           E(c + 2) = 0;
           T = table((0:1:c)', xm', xi', xs', fm', fi', fs', E', 'VariableNames', ["n", "x_m", "x_i", "x_s", "f_m", "f_i", "f_s", "E"]); 
        elseif error < Tol
           respuesta = sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia de %f en %d iteraciones', xm(c + 1), Tol, c);
           respuesta = char(respuesta);
           T = table((0:1:c)', xm', xi', xs', fm', fi', fs', E', 'VariableNames', ["n", "x_m", "x_i", "x_s", "f_m", "f_i", "f_s", "E"]); 
        else
           respuesta = sprintf('El método falló después de %d iteraciones', niter);
           respuesta = char(respuesta);
           T = table(niter, 'VariableNames', ["iteraciones"]);
        end
    else % No hay certeza de raíz en el intervalo dado
        xm(c + 1) = xi(c + 1); 
        fm(c + 1) = fi(c + 1); 
        E(c + 1) = 100; % Establecer un error alto para indicar la falta de certeza de raíz
        respuesta = sprintf('El intervalo inicial no es adecuado para buscar una raíz.'); 
        respuesta = char(respuesta);
        T = table(-1, 'VariableNames', ["intervalo"]); 
    end


    csv_file_path = "tablas/regla_falsa_tabla.csv"; 
    writetable(T, csv_file_path); 
end
