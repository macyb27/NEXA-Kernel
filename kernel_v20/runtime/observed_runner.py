from core.kernel import Kernel
from observability.tracer import Tracer


class ObservedRunner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
        self.tracer = Tracer()

    def run(self, task, context=None):
        context = context or {}

        self.tracer.trace(task, context)

        result = self.kernel.run(task, context)

        self.tracer.trace(task, context, result)

        return result