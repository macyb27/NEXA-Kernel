class Result:
    def __init__(self, status="ok", data=None, error=None):
        self.status = status
        self.data = data
        self.error = error

    def to_dict(self):
        return {
            "status": self.status,
            "data": self.data,
            "error": self.error
        }
