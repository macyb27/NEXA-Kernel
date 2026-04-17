from observability.logger import Logger

class Tracer:
    def __init__(self):
        self.logger = Logger()

    def trace(self, task, context, result=None):
        return self.logger.log("kernel_call", {
            "task": task,
            "context": context,
            "result": result
        })
