from django.db import models

# Create your models here.
class BiseccionModelo(models.Model):
    funcion = models.CharField(max_length=90)
    niter = models.IntegerField()
    xs = models.FloatField()
    xi = models.FloatField()
    Tol =  models.FloatField()
    solucion = models.CharField(max_length=430)
    
    def __str__(self):  
        return self.funcion
    
    
class BusquedaIncrementalModelo(models.Model):
    funcion = models.CharField(max_length=90)
    x0 = models.FloatField()
    delta = models.FloatField()
    niter = models.IntegerField()
    solucion = models.CharField(max_length=400)
    
    def __str__(self):
        return self.funcion
    
    
