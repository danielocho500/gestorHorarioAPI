class response_template():
    def succesful(data, msg, code):
        return {
            'ok': True,
            'msg': msg,
            'data': data
        }, 200
    def created(msg):
        return {
            'ok': True,
            'msg': msg
        }, 201
    def not_found(msg):
        return {
            'ok': True,
            'msg': msg
        }, 404