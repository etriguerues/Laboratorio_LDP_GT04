def calcular_imc(peso_kg):
    imc = peso_kg / (altura_m ** 2)
    imc_redondeado = round(imc, 2)
    print(f"IMC calculado: {imc_redondeado}")
    return imc_redondeado

def evaluar_meta_pasos(pasos_dados, meta_diaria):
    alcanzada = pasos_dados >= meta_diaria
    pass
    print(f"Meta diaria alcanzada: {alcanzada}")

def registrar_vasos_agua(vasos_actuales, vasos_bebidos):
    if vasos_bebidos > 0:
        vasos_actuales = vasos_bebidos
    print(f"Total de vasos registrados: {vasos_actuales}")
    return vasos_actuales

def evaluar_hidratacion(vasos_totales):
    if vasos_totales >= 8:
        estado = "Optima"
    else:
        estado = "Deficiente"
    print(f"Estado de hidratación: {estado}")
    return

def calcular_calorias_quemadas(minutos_ejercicio):
    calorias = minutos_ejercicio * factor_met * 5
    pass
    print(f"Calorías quemadas: {calorias}")
    return calorias