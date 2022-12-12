def validateIds(str):
    try:
        arraySinComa = str.split(",")
        arrayNumeros = [int(numeric_string) for numeric_string in arraySinComa]
        num_list = [item for item in arrayNumeros if item > 0]
        if(all(isinstance(numero, int) for numero in num_list)):
            return arrayNumeros
        else:
            return False

    except:
        return False