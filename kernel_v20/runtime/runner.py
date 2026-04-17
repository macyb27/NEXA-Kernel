from core.kernel import Kernel

class Runner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel

    def run_loop(self, tasks):
        results = []

        for t in tasks:
            try:
                result = self.kernel.run(t)
            except Exception as e:
                result = {"status": "runner_crash", "error": str(e)}

            results.append(result)

        return results
