from django.urls import path
from . import views

urlpatterns = [
    path('biseccion/', views.biseccion_view, name="biseccion"),
    path('busqueda-incremental/', views.busqueda_incremental_view, name="busqueda_incremental"),
    path('secante/', views.secante_view, name="secante"),
    path('newton/', views.newton_view, name="newton"),
    path('regla-falsa/', views.regla_falsa_view, name="regla_falsa"),
    path('punto-fijo/', views.punto_fijo_view, name="punto_fijo"),
    
    path('newton_m2/', views.newton_m2_view, name="newton_m2"),
    
    
    #Capitulo 2
    path('sor/', views.sor_view, name="sor"),
    path('gauss_seid/', views.gauss_seid_view, name="gauss_seid"),

    #Capitulo 3
    path('newtonInt/', views.newton_int_view, name='newton-int'),
    path('vander/', views.vander_view, name='vander'),
    path('spline/', views.spline_view, name='spline'),
]

