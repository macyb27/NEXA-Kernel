#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Kernel extension tool starting..."

cd $PROJECT

# ---------------- OBSERVABILITY ----------------

echo "[+] Adding Observability Layer..."

mkdir -p observability

cat > observability/events.py << 'EOF'
import time
import uuid

def create_event(event_type: str, payload: dict):
    return {
        "id": str(uuid.uuid4()),
        "type": event_type,
        "timestamp": time.time(),
        "payload": payload
    }
EOF

cat > observability/logger.py << 'EOF'
import json
from observability.events import create_event

class Logger:
    def log(self, event_type: str, payload: dict):
        event = create_event(event_type, payload)
        print("[OBS]", json.dumps(event))
        return event
EOF

cat > observability/tracer.py << 'EOF'
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
EOF

# ---------------- WRAPPER LAYER ----------------

echo "[+] Adding Observed Runner (non-invasive)..."

mkdir -p runtime

cat > runtime/observed_runner.py << 'EOF'
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
EOF

# ---------------- OPTIONAL ENTRYPOINT ----------------

echo "[+] Creating observability entrypoint..."

cat > run_observed.py << 'EOF'
from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.observed_runner import ObservedRunner

def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    runner = ObservedRunner(kernel)

    for i in range(3):
        result = runner.run(
            task="test_task",
            context={"i": i}
        )
        print(result)

if __name__ == "__main__":
    main()
EOF

echo "[✓] Kernel extension applied successfully"
echo "[→] Run: python run_observed.py"
