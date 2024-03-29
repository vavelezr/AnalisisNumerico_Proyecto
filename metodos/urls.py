from django.urls import path
from . import views

urlpatterns = [
    path('biseccion/', views.biseccion_view, name="biseccion"),
    path('busqueda-incremental/', views.busqueda_incremental_view, name="busqueda-incremental"),
]
