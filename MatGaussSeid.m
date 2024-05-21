%MatJacobiSeid: Calcula la solución del sistema
%Ax=b con base en una condición inicial x0,mediante el método de Jacobi o
%de Gauss Seidel (Matricial), depende del método elegido, se elige 0 o 1 en met
%respectivamente

function [radio,E,s] = MatGaussSeid(x0,A,b,Tol,niter, met)

    A = str2num(A);
    b = str2num(b);
    x0 = str2num(x0);

    c=0;
    error=Tol+1;
    D=diag(diag(A));
    L=-tril(A,-1);
    U=-triu(A,+1);

    Xt(:,c+1)=x0;
    n(1)=c;
    E(c+1)=error;

    while error>Tol && c<niter
        if met==0
            T=inv(D)*(L+U);
            C=inv(D)*b;
            x1=T*x0+C;
        end
        if met==1
            T=inv(D-L)*(U); % ecuacion de matriz trasicion gs
            C=inv(D-L)*b;  % ecuacion de vector constante gs
            x1=T*x0+C; % ecuacion para proxima iteracion de x
        end
        E(c+2)=norm((x1-x0)/x1,'inf');
        error=E(c+2);
        x0=x1
        c=c+1;

        n(c+1)=c;
        Xt(:,c+1)=x0;
    end


    % Calcula el radio espectral
    radio = max(abs(eig(T)));

    D=[n' Xt' E'];
    tabla = table(n', Xt', E', 'VariableNames', {'Iteracion', 'x' 'Error'});

    csv_file_path = "tablas/GaussSeid_tabla.csv";

    writetable(tabla, csv_file_path)

    if error < Tol
        s=x0;
        n=c;
        s
        fprintf('es una aproximación de la solución del sistmea con una tolerancia= %f',Tol)
    else 
        s=x0;
        n=c;
        fprintf('Fracasó en %f iteraciones',niter) 
    end
end