from core.kernel import Kernel
from observability.metrics import Metrics


class MetricsRunner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
        self.metrics = Metrics()

    def run(self, task, context=None):
        context = context or {}

        start = self.metrics.record_start()

        result = self.kernel.run(task, context)

        status = result.get("status", "unknown")

        self.metrics.record_end(start, status)

        return result

    def report(self):
        return self.metrics.summary()
