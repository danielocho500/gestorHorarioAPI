from datetime import time
import re

def regexTime(str):
    if re.fullmatch("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", str):
        return True
    else:
        return False

def is_time_between(tiempoInicio, tiempoFin, checarTiempoFin, checarTiempoInicio):
    if tiempoInicio == checarTiempoInicio:
        return True
    if tiempoInicio < checarTiempoInicio and checarTiempoInicio < tiempoFin:
        return True
    else:
        if tiempoInicio < checarTiempoFin and checarTiempoFin <= tiempoFin:
            return True
        else:
            return False
