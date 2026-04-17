class SimulationEngine:
    def run(self, kernel, task, context):
        return {
            "status": "simulated",
            "task": task,
            "context": context,
            "note": "no execution performed"
        }
