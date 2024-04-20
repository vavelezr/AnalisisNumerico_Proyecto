function [n, xn, fm, E, respuesta] = PuntoFijo(func, fung, x0, Tol, niter, error)
    syms x
    f = str2sym(func);
    g = str2sym(fung);
    c = 0;
    fm(c + 1) = eval(subs(f, x0));
    fe = fm(c + 1);
    E(c + 1) = Tol + 1;
    error = E(c + 1);
    xn(c + 1) = x0;
    N(c + 1) = c;
    while error > Tol && fe ~= 0 && c < niter
        xn(c + 2) = eval(subs(g, x0));
        fm(c + 2) = eval(subs(f, xn(c + 2)));
        fe = fm(c + 2);
        if error == 1
            E(c + 2) = abs((xn(c + 2) - x0) / xn(c + 2));
            error = E(c + 2);            
        else 
            E(c + 2) = abs((xn(c + 2) - x0));
            error = E(c + 2);
        end
        x0 = xn(c + 2);
        N(c + 2) = c + 1;
        c = c + 1;
    end
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

    tabla = table(N', xn', fm', E', 'VariableNames', {'Iteration','xi', 'fxi', 'Error'});
        
    csv_file_path = "tablas/punto_fijo_tabla.csv";

    writetable(tabla, csv_file_path)
    if abs(fm(n+1)) <= Tol
        respuesta = sprintf('%f es una aproximación de una raíz de f(x)', xn(n+1));
    else
        respuesta = 'No se encontró una solución con la precisión requerida';
    end
end
