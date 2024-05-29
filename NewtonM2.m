function [N,s,fm,dfm,E, respuesta] = NewtonM2(f, x0,Tol,niter, Tipo_error)
    syms x
        f = str2sym(f);
        %x0 = str2double(x0);
        %Tol = str2double(Tol);
        %niter = str2double(niter);

        df=diff(f);
        d2f=diff(df);
        c=0;
        fm(c+1) = eval(subs(f,x0));
        fe=fm(c+1);
        dfm = eval(subs(df,x0));
        dfe=dfm;
        d2fm(c+1) = eval(subs(f,x0));
        d2e=d2fm(c+1);
        E(c+1)=Tol+1;
        error=E(c+1);
        xn(c+1)=x0;
        N(c+1)=c;
        tabla = table(c, xn(c+1), fe, dfm, error, 'VariableNames', {'i', 'xn', 'Fm', 'dfm','Error'});
        csv_file_path = "tablas/newton_m2_tabla.csv";
        writetable(tabla, csv_file_path);
        while error>Tol 
            xn(c+2)=x0-((fe*dfe)/((dfe)^2 - fe*d2e));   %Fórmula
            fe=eval(subs(f,xn(c+2)));
            dfe=eval(subs(df,xn(c+2)));
            d2e = eval(subs(d2f,xn(c+2)));
            if Tipo_error == 0
                E(c+2)=abs(xn(c+2)-x0); % Error ABSOLUTO
            else
                E(c+2)=abs((xn(c+2)-x0)/(xn(c+2))); % Error RELATIVO
            end
            error=E(c+2);
            x0=xn(c+2);
            N(c+2)=c+2;
            c=c+1;
            nueva_fila = table(c, x0, fe, dfm, error, 'VariableNames', {'i', 'xn', 'Fm', 'dfm','Error'});
            tabla = [tabla; nueva_fila];
            csv_file_path = "tablas/newton_m2_tabla.csv";
            writetable(tabla, csv_file_path);
        end
        if fe==0
            s=x0;
            respuesta = sprintf('%f es raiz de f(x)',x0);

        elseif error<Tol
            s=x0;
            respuesta = sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f',x0,Tol);

        elseif dfe==0
            s=x0;
            respuesta = sprintf('%f es una posible raiz múltiple de f(x)',x0);
        else 
            s=x0;
            respuesta = sprintf('Fracasó en %f iteraciones',niter); 
        end
        
end