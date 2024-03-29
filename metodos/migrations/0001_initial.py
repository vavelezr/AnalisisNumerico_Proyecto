# Generated by Django 4.1.2 on 2024-03-29 00:34

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BiseccionModelo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('funcion', models.CharField(max_length=90)),
                ('niter', models.IntegerField()),
                ('xs', models.FloatField()),
                ('xi', models.FloatField()),
                ('Tol', models.FloatField()),
                ('solucion', models.CharField(max_length=430)),
            ],
        ),
        migrations.CreateModel(
            name='BusquedaIncrementalModelo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('funcion', models.CharField(max_length=90)),
                ('x0', models.FloatField()),
                ('delta', models.FloatField()),
                ('niter', models.IntegerField()),
                ('solucion', models.CharField(max_length=400)),
            ],
        ),
    ]
