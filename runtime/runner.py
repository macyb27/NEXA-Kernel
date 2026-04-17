from core.kernel import Kernel


class Runner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel

    def run_loop(self, tasks):
        results = []

        for t in tasks:
            results.append(self.kernel.run(t))

        return results
