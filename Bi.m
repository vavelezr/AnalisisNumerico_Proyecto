function [solucion, tabla] = Bi(func, x0, Delta, niter)
    syms x
    f(x) = str2sym(func);
    
    f0 = eval(subs(f, x0));
    if f0 == 0
        solucion = x0;
        fprintf('%f es raiz de f(x)\n', x0);
        tabla = table(0, x0, f0, 'VariableNames', {'i', 'Xm', 'f_xm'});
    else
        x1 = x0 + Delta;
        c = 1; % contador
        f1 = eval(subs(f, x1));
        % Inicializar la tabla con los valores iniciales
        tabla = table(c, x0, f0, 'VariableNames', {'i', 'Xm', 'f_xm'});
        
        while f0 * f1 > 0 && c <= niter
            x0 = x1;
            f0 = f1;
            x1 = x0 + Delta;
            f1 = eval(subs(f, x1));
            c = c + 1;
            
            % Agregar resultados a la tabla en cada iteración
            nueva_fila = table(c, x1, f1, 'VariableNames', {'i', 'Xm', 'f_xm'});
            tabla = [tabla; nueva_fila];
        end
        
        if f1 == 0
            solucion = x1;
            fprintf('%f es raiz de f(x)\n', x1);
        elseif f0 * f1 < 0
            solucion = x1;
            fprintf('Existe una raiz de f(x) entre %f y %f\n', x0, x1);
        else
            solucion = x1;
            fprintf('Fracasó en %d iteraciones\n', c);
        end
        
        % Guardar la tabla en un archivo CSV
        csv_file_path = 'tablas/busqueda_incremental_tabla.csv';
        writetable(tabla, csv_file_path);
        
        % Imprimir el valor de c
        disp(['El valor de c es: ' num2str(c)]);
    end
end