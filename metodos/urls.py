from django.urls import path
from . import views

urlpatterns = [
    path('biseccion/', views.biseccion_view, name="biseccion"),
    path('busqueda-incremental/', views.busqueda_incremental_view, name="busqueda_incremental"),
    path('secante/', views.secante_view, name="secante"),
    path('newton/', views.newton_view, name="newton"),
    path('regla-falsa/', views.regla_falsa_view, name="regla_falsa"),
    path('punto-fijo/', views.punto_fijo_view, name="punto_fijo"),
]

