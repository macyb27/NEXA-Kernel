import time


class Metrics:
    def __init__(self):
        self.data = {
            "total_runs": 0,
            "success": 0,
            "errors": 0,
            "rejected": 0,
            "latencies": []
        }

    def record_start(self):
        return time.time()

    def record_end(self, start_time, status: str):
        duration = time.time() - start_time

        self.data["total_runs"] += 1
        self.data["latencies"].append(duration)

        if status == "ok":
            self.data["success"] += 1
        elif status == "execution_error":
            self.data["errors"] += 1
        elif status == "rejected":
            self.data["rejected"] += 1

        return self.data

    def summary(self):
        if self.data["latencies"]:
            avg_latency = sum(self.data["latencies"]) / len(self.data["latencies"])
        else:
            avg_latency = 0

        return {
            "total_runs": self.data["total_runs"],
            "success": self.data["success"],
            "errors": self.data["errors"],
            "rejected": self.data["rejected"],
            "avg_latency": avg_latency
        }
