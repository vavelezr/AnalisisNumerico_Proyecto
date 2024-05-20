from django.shortcuts import render
import matlab.engine
import pandas as pd
import json
import csv
from .models import *
import matplotlib.pyplot as plt
import numpy as np
import scipy.io
# Create your views here.

def home(request):
    return render(request, "home.html")


def biseccion_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        xi = float(request.POST.get('xi'))
        xs = float(request.POST.get('xs'))
        tol = float(request.POST.get('tol'))

        eng = matlab.engine.start_matlab()
        respuesta, s, E, fm = eng.Biseccion(funcion, xi, xs, tol, niter, nargout=4)
        eng.quit()

        # Leer el archivo CSV con los datos de la tabla
        tabla_csv = pd.read_csv("tablas/biseccion_tabla.csv")

        # Graficar los datos
        plt.plot(tabla_csv['Iteration'], tabla_csv['fxi'])  # Graficar fxi respecto a la iteración
        plt.xlabel('Iteración')
        plt.ylabel('f(xi)')
        plt.title('Gráfico de f(xi) vs. Iteración')
        plt.grid(True)
        plt.savefig('media/grafico_biseccion.png')  # Guardar la imagen del gráfico
        plt.close()
    
        tabla = tabla_csv.to_dict('records')

        # Pasar la ruta de la imagen del gráfico al template
        return render(request, 'biseccion.html', {'respuesta': respuesta, 's': s, 'E': E, 'fm': fm, 'tabla': tabla, 'ruta_grafico': "media/grafico_biseccion.png"})

    return render(request, 'biseccion.html')

    
    
    
def busqueda_incremental_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        x0 = float(request.POST.get('x0'))
        delta = float(request.POST.get('delta'))
        niter = int(request.POST.get('niter'))


        eng = matlab.engine.start_matlab()
        solucion, tabla= eng.Bi(funcion, x0, delta, niter, nargout=2)


        eng.quit()
        tabla_csv = pd.read_csv("tablas/busqueda_incremental_tabla.csv")
        tabla2 = tabla_csv.to_dict('records')
        return render(request, 'busqueda_incremental.html', {'solucion': solucion, 'tabla': tabla, 'tabla2': tabla2})

    return render(request, 'busqueda_incremental.html')



def secante_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        x1 = float(request.POST.get('x1'))
        tol = float(request.POST.get('tol'))
        terr=int(request.POST.get('terr'))


        eng = matlab.engine.start_matlab()


        respuesta, N, XN, fm, E,T = eng.Secante(funcion, x0, x1, tol, niter, terr, nargout=6)


        eng.quit()


        tabla_csv = pd.read_csv("tablas/secante_tabla.csv")

        # Graficar los datos
        plt.plot(tabla_csv['Iteration'], tabla_csv['fxn'])  # Graficar fxi respecto a la iteración
        plt.xlabel('Iteración')
        plt.ylabel('f(xn)')
        plt.title('Gráfico de f(xn) vs. Iteración')
        plt.grid(True)
        plt.savefig("./media/grafico_secante.png")  # Guardar la imagen del gráfico
        plt.close()

        tabla = tabla_csv.to_dict('records')


        return render(request, 'secante.html', {
            'respuesta': respuesta,
            'tabla': tabla,
            'ruta_grafico': "media/grafico_secante.png"
        })

    return render(request, 'secante.html')



def newton_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))
        terr=int(request.POST.get('terr'))

        # Inicializar el motor de MATLAB
        eng = matlab.engine.start_matlab()

        # Llamar a la función de MATLAB para el método de Newton
        n, xn, fm, dfm, E , respuesta = eng.Newton(funcion, x0, tol, niter,terr, nargout=6)

        # Detener el motor de MATLAB
        eng.quit()

        # Cargar datos del archivo CSV
        tabla_csv = pd.read_csv("tablas/newton_tabla.csv")
        
        # Graficar los datos
        plt.plot(tabla_csv['i'], tabla_csv['Fm'])  # Graficar fxi respecto a la iteración
        plt.xlabel('Iteración')
        plt.ylabel('fm')
        plt.title('Gráfico de fm vs. Iteración')
        plt.grid(True)
        plt.savefig('media/grafico_newton.png')  # Guardar la imagen del gráfico
        plt.close()
        
        
        # Convertir el DataFrame de pandas a una lista de diccionarios
        tabla = tabla_csv.to_dict('records')

        # Renderizar la plantilla con los datos del método de Newton
        return render(request, 'newton.html', {
            'respuesta': respuesta,
            'n': n,
            'xn': xn,
            'fm': fm,
            'dfm': dfm,
            'E': E,
            'tabla': tabla,
            'ruta_grafico': "media/grafico_newton.png"
        })

    return render(request, 'newton.html')

def newton_m2_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))

        eng = matlab.engine.start_matlab()

        N,s,fm,dfm,E,respuesta = eng.NewtonM2(funcion,x0,tol,niter, nargout = 6)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/newton_m2_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        return render(request, 'newton_m2.html', {
            'respuesta': respuesta,
            'n': N,
            'fm': fm,
            'dfm': dfm,
            'E': E,
            'tabla':tabla
        })
    return render(request, 'newton_m2.html')


def regla_falsa_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        x1 = float(request.POST.get('x1'))
        tol = float(request.POST.get('tol'))
        terr=int(request.POST.get('terr'))


        eng = matlab.engine.start_matlab()


        respuesta,T = eng.ReglaFalsa(funcion, x0, x1, tol, niter, terr, nargout=2)
        eng.quit()

        tabla_csv = pd.read_csv("tablas/regla_falsa_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        return render(request, 'regla_falsa.html', {'respuesta': respuesta, 'tabla': tabla})

    return render(request, 'regla_falsa.html')


def punto_fijo_view(request):
    if request.method == 'POST':
        # Recopilación de datos del formulario
        funcion = request.POST.get('funcion')
        funciong = request.POST.get('funciong')
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))
        niter = int(request.POST.get('niter'))
        tipo_error = int(request.POST.get('tipo_error'))

        eng = matlab.engine.start_matlab()
        n, xn, fm, E, respuesta = eng.PuntoFijo(funcion, funciong, x0, tol, niter, tipo_error, nargout=5)
        eng.quit()

        tabla_csv = pd.read_csv("tablas/punto_fijo_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        # El último valor de xn y E para mostrar
        s = xn[-1] if xn else None
        ultimo_error = E[-1] if E else None

        return render(request, 'punto_fijo.html', {
            'respuesta': respuesta,
            's': s,
            'E': ultimo_error,
            'tabla': tabla
        })

    return render(request, 'punto_fijo.html')

def sor_view(request):
    if request.method == 'POST':
        # Recopilación de datos del formulario
        tol = float(request.POST.get('tol'))
        niter = int(request.POST.get('niter'))
        w= float(request.POST.get('w'))
        tipo_error = int(request.POST.get('tipo_error'))

        x0_str = request.POST.get('x0')
        A_str = request.POST.get('A')
        b_str = request.POST.get('b')

        # Función auxiliar para convertir cadenas a array numpy
        def parse_input(vector_str):
            try:
                # Convierte cadena a lista y luego a array numpy
                vector = np.array(eval(vector_str))
                return vector
            except:
                return None

        # Parsear las entradas
        x0 = parse_input(x0_str)
        A = parse_input(A_str)
        b = parse_input(b_str)

        eng = matlab.engine.start_matlab()
        radio, E, respuesta = eng.Sor(x0, A, b,tol,niter,w, tipo_error, nargout=3)
        eng.quit()

        tabla_csv = pd.read_csv("tablas/tabla_sor.csv")
        tabla = tabla_csv.to_dict('records')
        columnas = tabla_csv.columns.tolist()

        # El último valor de xn y E para mostrar
        s = respuesta[-1] if respuesta else None
        ultimo_error = E[-1] if E else None

        return render(request, 'sor.html', {
            'respuesta': respuesta,
            'E': ultimo_error,
            'radio':radio,
            'tabla': tabla,
            'columnas':columnas,
        })

    return render(request, 'sor.html')


