from dateutil.parser import parse

def is_date(string):
    try:
        date = parse(string)
        return True
    except:
        return False

def getDate(string):
    try:
        date = parse(string)
        return date
    except:
        return False

def validarFechasPeriodo(fechaInicio,fechaOrdinario,fechaExtra,fechaFin):
        if not (fechaFin > fechaInicio):
            return {'ok': False, 'msg': 'La fecha de fin debe ser mayor a la de inicio'}
        if not (fechaFin > fechaOrdinario):
            return {'ok': False, 'msg': 'La fecha de fin debe ser mayor a la de ordinario'}
        if not (fechaFin > fechaExtra):
            return {'ok': False, 'msg': 'La fecha de fin debe ser mayor a la de extraodinario'}

        if not (fechaExtra > fechaOrdinario):
            return {'ok': False, 'msg': 'La fecha de extraordinario debe ser mayor a la de ordinario'}
        if not (fechaExtra > fechaInicio):
            return {'ok': False, 'msg': 'La fecha de extraordinario debe ser mayor a la de inicio'}

        if not (fechaOrdinario > fechaInicio):
            return {'ok': False, 'msg': 'La fecha de ordinario debe ser mayor a la de inicio'}

        return {'ok': True}