import re

def regexTime(str):
    if re.fullmatch("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", str):
        return True
    else:
        return False
