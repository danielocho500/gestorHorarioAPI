import re
import datetime

def regexTime(str):
    if re.fullmatch("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", str):
        return True
    else:
        return False

def is_time_between(tiempoInicio, tiempoFin, checarTiempoFin, checarTiempoInicio):
    tiempoAux = str(tiempoInicio)
    tiempoAux2 = str(tiempoFin)

    horarioInicioCadena = datetime.datetime.strptime(tiempoAux, '%H:%M:%S').time()
    horarioFinCadena = datetime.datetime.strptime(tiempoAux2, '%H:%M:%S').time()


    if horarioInicioCadena == checarTiempoInicio:
        return True
    if horarioInicioCadena < checarTiempoInicio and checarTiempoInicio < horarioFinCadena:
        return True
    else:
        if horarioInicioCadena < checarTiempoFin and checarTiempoFin <= horarioFinCadena:
            return True
        else:
            return False
