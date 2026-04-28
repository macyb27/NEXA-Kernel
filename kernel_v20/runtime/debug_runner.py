from core.kernel import Kernel


class DebugRunner:
    def __init__(self, kernel: Kernel, enabled=False):
        self.kernel = kernel
        self.enabled = enabled

    def run(self, task, context=None):
        result = self.kernel.run(task, context)

        if self.enabled:
            print("[DEBUG]", {
                "task": task,
                "context": context,
                "result": result
            })

        return result