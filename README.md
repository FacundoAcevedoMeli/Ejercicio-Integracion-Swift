# Ejercicio-Integracion-Swift

## Enunciado

AlkeParking es un estacionamiento que permite estacionar diferentes tipos de
vehículos (auto, moto, minibus y bus) con un cupo máximo de 20 vehículos.

- Cuando se va a ingresar un vehículo se ingresa la patente y el tipo, y se
valida que no haya ningún otro vehículo con esa misma patente en el
estacionamiento.
- Cuando un vehículo va a ser retirado se cobra una tarifa determinada por
las siguientes reglamentaciones
- Las primeras 2 horas de estacionamiento tendrán un costo fijo
determinado por el tipo de vehículo (auto: $20, moto: $15, mini bus: $25,
bus: $30).
- Luego de las 2 primeras horas se cobrarán $5 por cada 15 minutos o
fracción independiente del tipo de vehículo. Por ejemplo para un auto se
tendrían las siguientes tarifas:

18:00 | 18:46 | $20
18:00 | 20:00 | $20
18:00 | 21:13 | $45
18:00 | 21:18 | $50
18:00 | 21:30 | $50
