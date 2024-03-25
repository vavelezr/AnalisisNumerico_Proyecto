from django.shortcuts import render
import matlab.engine
import pandas as pd
import json
import csv
# Create your views here.
eng = matlab.engine.start_matlab()
result = eng.sqrt(4.0)
print(result)  # Debería imprimir 2.0

# Cierra el motor de MATLAB
eng.quit()