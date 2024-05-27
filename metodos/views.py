from django.shortcuts import render
import matlab.engine
import pandas as pd
import json
from django.http import JsonResponse
import csv
from .models import *
import matplotlib.pyplot as plt
import numpy as np
import scipy.io
import sympy as sp
from sympy import lambdify, symbols, sympify
import os
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

        tabla = tabla_csv.to_dict('records')

        # Crear el gráfico de la función
        x = sp.symbols('x')
        f = sp.sympify(funcion)
        f_lambdified = sp.lambdify(x, f, 'numpy')

        x_vals = np.linspace(xi, xs, 400)
        y_vals = f_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals, label=f'f(x) = {funcion}')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de la Función')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.legend()
        plt.grid(True)

        grafico_funcion_path = os.path.join('static', 'images', 'funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        # Pasar la ruta de la imagen del gráfico al template
        return render(request, 'biseccion.html', {
            'respuesta': respuesta, 
            's': s, 
            'E': E, 
            'fm': fm, 
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/'),  # Ruta relativa para la imagen de la función
        })

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
        terr = int(request.POST.get('terr'))

        eng = matlab.engine.start_matlab()

        respuesta, N, XN, fm, E, T = eng.Secante(funcion, x0, x1, tol, niter, terr, nargout=6)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/secante_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        # Crear el gráfico de la función
        x = sp.symbols('x')
        f = sp.sympify(funcion)
        f_lambdified = sp.lambdify(x, f, 'numpy')

        x_vals = np.linspace(x0, x1, 400)
        y_vals = f_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals, label=f'f(x) = {funcion}')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de la Función')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.legend()
        plt.grid(True)

        grafico_funcion_path = os.path.join('static', 'images', 'secante_funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        return render(request, 'secante.html', {
            'respuesta': respuesta,
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/')
        })

    return render(request, 'secante.html')



def newton_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))
        terr = int(request.POST.get('terr'))

        eng = matlab.engine.start_matlab()

        n, xn, fm, dfm, E, respuesta = eng.Newton(funcion, x0, tol, niter, terr, nargout=6)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/newton_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        # Crear el gráfico de la función
        x = sp.symbols('x')
        f = sp.sympify(funcion)
        f_lambdified = sp.lambdify(x, f, 'numpy')

        x_vals = np.linspace(x0 - 5, x0 + 5, 400)
        y_vals = f_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals, label=f'f(x) = {funcion}')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de la Función')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.legend()
        plt.grid(True)
        plt.ylim([-10, 10])

        grafico_funcion_path = os.path.join('static', 'images', 'newton_funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        return render(request, 'newton.html', {
            'respuesta': respuesta,
            'n': n,
            'xn': xn,
            'fm': fm,
            'dfm': dfm,
            'E': E,
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/')
        })

    return render(request, 'newton.html')

def newton_m2_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        tol = float(request.POST.get('tol'))

        eng = matlab.engine.start_matlab()

        N, s, fm, dfm, E, respuesta = eng.NewtonM2(funcion, x0, tol, niter, nargout=6)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/newton_m2_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        # Crear el gráfico de la función
        x = sp.symbols('x')
        f = sp.sympify(funcion)
        f_lambdified = sp.lambdify(x, f, 'numpy')

        x_vals = np.linspace(x0 - 5, x0 + 5, 400)
        y_vals = f_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals, label=f'f(x) = {funcion}')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de la Función')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.legend()
        plt.grid(True)

        grafico_funcion_path = os.path.join('static', 'images', 'newton_m2_funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        return render(request, 'newton_m2.html', {
            'respuesta': respuesta,
            'n': N,
            'fm': fm,
            'dfm': dfm,
            'E': E,
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/')
        })

    return render(request, 'newton_m2.html')





def regla_falsa_view(request):
    if request.method == 'POST':
        funcion = request.POST.get('funcion')
        niter = int(request.POST.get('niter'))
        x0 = float(request.POST.get('x0'))
        x1 = float(request.POST.get('x1'))
        tol = float(request.POST.get('tol'))
        terr = int(request.POST.get('terr'))

        eng = matlab.engine.start_matlab()

        respuesta, T = eng.ReglaFalsa(funcion, x0, x1, tol, niter, terr, nargout=2)
        eng.quit()

        tabla_csv = pd.read_csv("tablas/regla_falsa_tabla.csv")
        tabla = tabla_csv.to_dict('records')

        # Crear el gráfico de la función
        x = sp.symbols('x')
        f = sp.sympify(funcion)
        f_lambdified = sp.lambdify(x, f, 'numpy')

        x_vals = np.linspace(x0, x1, 400)
        y_vals = f_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals, label=f'f(x) = {funcion}')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de la Función')
        plt.xlabel('x')
        plt.ylabel('f(x)')
        plt.legend()
        plt.grid(True)

        grafico_funcion_path = os.path.join('static', 'images', 'regla_falsa_funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        return render(request, 'regla_falsa.html', {
            'respuesta': respuesta,
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/')
        })

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

        # Graficar ambas funciones
        x_vals = np.linspace(x0 - 5, x0 + 5, 400)
        
        f_lambdified = lambdify(symbols('x'), sympify(funcion))
        g_lambdified = lambdify(symbols('x'), sympify(funciong))
        
        y_vals_f = f_lambdified(x_vals)
        y_vals_g = g_lambdified(x_vals)

        plt.figure()
        plt.plot(x_vals, y_vals_f, label=f'f(x) = {funcion}', color='blue')
        plt.plot(x_vals, y_vals_g, label=f'g(x) = {funciong}', color='red')
        plt.axhline(0, color='black', linewidth=0.5)
        plt.axvline(0, color='black', linewidth=0.5)
        plt.title('Gráfico de las Funciones f y g')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.legend()
        plt.grid(True)
        plt.ylim([-10, 10])

        grafico_funcion_path = os.path.join('static', 'images', 'punto_fijo_funcion_grafico.png')
        plt.savefig(grafico_funcion_path)
        plt.close()

        return render(request, 'punto_fijo.html', {
            'respuesta': respuesta,
            's': xn[-1] if xn else None,
            'E': E[-1] if E else None,
            'tabla': tabla,
            'ruta_grafico_funcion': '/' + grafico_funcion_path.replace(os.path.sep, '/')
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

def gauss_seid_view(request):
    if request.method == 'POST':
        # Recopilación de datos del formulario
        tol = float(request.POST.get('tol'))
        niter = int(request.POST.get('niter'))
        met= int(request.POST.get('met'))
        print(met)

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
        radio, E, respuesta = eng.MatGaussSeid(x0, A, b,tol,niter,met, nargout=3)
        eng.quit()

        tabla_csv = pd.read_csv("tablas/GaussSeid_tabla.csv")
        tabla = tabla_csv.to_dict('records')
        columnas = tabla_csv.columns.tolist()

        # El último valor de xn y E para mostrar
        s = respuesta[-1] if respuesta else None
        ultimo_error = E[-1] if E else None

        return render(request, 'GaussSeid.html', {
            'respuesta': respuesta,
            'E': ultimo_error,
            'radio':radio,
            'tabla': tabla,
            'columnas':columnas,
        })

    return render(request, 'GaussSeid.html')
    
def newton_int_view(request):
    if request.method == 'POST':
        x = request.POST.get('x')
        y = request.POST.get('y')
        
        eng = matlab.engine.start_matlab()

        coef, pol, polT = eng.NewtonIntComp(x, y, nargout = 3)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/newtonIntComp.csv", header=None)
        tabla = tabla_csv.values.tolist()
        grafico_funcion_path = os.path.join('static', 'images', 'polinomio_interpolacion_newton.png')

        return render(request, 'newtonInt.html', {
            'Tabla': tabla,
            'coeficientes': coef,
            'polinomioC': pol,
            'polinomio': polT,
            'grafico': '/' + grafico_funcion_path.replace(os.path.sep, '/'),
        })
    return render(request, 'newtonInt.html')

def vander_view(request):
    if request.method == 'POST':
        x = request.POST.get('x')
        y = request.POST.get('y')
        
        eng = matlab.engine.start_matlab()

        [A, a, pol] = eng.vander1(x, y, nargout=3)

        eng.quit()

        tabla_csv = pd.read_csv("tablas/vander1.csv", header=None)
        tabla = tabla_csv.values.tolist()

        grafico_funcion_path = os.path.join('static', 'images', 'vander1.png')

        return render(request, 'vander.html', {
            'Tabla': tabla,
            'coeficientes': a,
            'polinomio': pol,
            'grafico': '/' + grafico_funcion_path.replace(os.path.sep, '/'),
        })
    return render(request, 'vander.html')


def spline_view(request):
    if request.method == 'POST':
        x_values = request.POST.get('x')
        y_values = request.POST.get('y')
        degree = int(request.POST.get('degree'))

        eng = matlab.engine.start_matlab()

        T = eng.Spline(degree, x_values, y_values, nargout=1)

        eng.quit()
        
        tabla_csv = pd.read_csv("tablas/spline_tabla.csv", header=None)
        tabla = tabla_csv.values.tolist()
        grafico_funcion_path = os.path.join('static', 'images', 'spline.png')
        
        return render(request, 'spline.html', {
            'Tabla': tabla,
            'grafico': '/' + grafico_funcion_path.replace(os.path.sep, '/'),
        })
    return render(request, 'spline.html')