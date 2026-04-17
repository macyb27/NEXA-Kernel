#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Extending Kernel v20 with Metrics Layer..."

cd $PROJECT

# ---------------- METRICS CORE ----------------

echo "[+] Creating observability/metrics.py"

mkdir -p observability

cat > observability/metrics.py << 'EOF'
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
EOF

# ---------------- METRICS RUNNER ----------------

echo "[+] Creating runtime/metrics_runner.py"

mkdir -p runtime

cat > runtime/metrics_runner.py << 'EOF'
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
EOF

# ---------------- ENTRY POINT ----------------

echo "[+] Creating run_metrics.py"

cat > run_metrics.py << 'EOF'
from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.metrics_runner import MetricsRunner


def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    runner = MetricsRunner(kernel)

    for i in range(5):
        result = runner.run(
            task="test_task",
            context={"i": i}
        )
        print(result)

    print("\n[METRICS REPORT]")
    print(runner.report())


if __name__ == "__main__":
    main()
EOF

echo "[✓] Metrics layer successfully applied"
echo "[→] Run with: python run_metrics.py"
