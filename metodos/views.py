from django.shortcuts import render
import matlab.engine
import pandas as pd
import json
import csv
from .models import *
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

        # Inicializar el motor de MATLAB
        eng = matlab.engine.start_matlab()

        # Llamar a la función de MATLAB
        respuesta, s, E, fm = eng.Biseccion(funcion, xi, xs, tol, niter, nargout=4)

        # Detener el motor de MATLAB
        eng.quit()

        # Preparar datos para enviar a la plantilla

        # Cargar datos del archivo CSV
        tabla_csv = pd.read_csv("tablas/biseccion_tabla.csv")
        # Convertir el DataFrame de pandas a una lista de diccionarios para que pueda ser utilizado en la plantilla
        tabla = tabla_csv.to_dict('records')
        return render(request, 'biseccion.html',{'respuesta': respuesta, 's': s, 'E': E, 'fm': fm, 'tabla': tabla})

    return render(request, 'biseccion.html')

    
    
    
def busqueda_incremental_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        x0 = float(request.POST.get('x0'))
        delta = float(request.POST.get('delta'))
        niter = int(request.POST.get('niter'))

        # Inicializar el motor de MATLAB
        eng = matlab.engine.start_matlab()

        # Llamar a la función de MATLAB
        solucion, tabla= eng.Bi(funcion, x0, delta, niter, nargout=2)

        # Detener el motor de MATLAB
        eng.quit()

        # Preparar datos para enviar a la plantilla

        # Cargar datos del archivo CSV
        tabla_csv = pd.read_csv("tablas/busqueda_incremental_tabla.csv")
        # Convertir el DataFrame de pandas a una lista de diccionarios para que pueda ser utilizado en la plantilla
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

        # Inicializar el motor de MATLAB
        eng = matlab.engine.start_matlab()

        # Llamar a la función de MATLAB para el método de la secante
        respuesta, N, XN, fm, E,T = eng.Secante(funcion, x0, x1, tol, niter, terr, nargout=6)

        # Detener el motor de MATLAB
        eng.quit()

        # Cargar datos del archivo CSV
        tabla_csv = pd.read_csv("tablas/secante_tabla.csv")

        # Convertir el DataFrame de pandas a una lista de diccionarios
        tabla = tabla_csv.to_dict('records')

        # Renderizar la plantilla con los datos del método de la secante
        return render(request, 'secante.html', {
            'respuesta': respuesta,
            'tabla': tabla,
            # Aquí puedes incluir otros datos que quieras enviar a la plantilla
        })

    return render(request, 'secante.html')



def newton_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))

        # Inicializar el motor de MATLAB
        eng = matlab.engine.start_matlab()

        # Llamar a la función de MATLAB para el método de Newton
        n, xn, fm, dfm, E , respuesta = eng.Newton(funcion, x0, tol, niter, nargout=6)

        # Detener el motor de MATLAB
        eng.quit()

        # Cargar datos del archivo CSV
        tabla_csv = pd.read_csv("tablas/newton_tabla.csv")

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
            'tabla': tabla
        })

    return render(request, 'newton.html')


