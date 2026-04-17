#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Creating v20.1 hardened kernel structure..."

mkdir -p $PROJECT/core
mkdir -p $PROJECT/runtime
mkdir -p $PROJECT/examples

cd $PROJECT

# ---------------- CORE ----------------

echo "[+] core/errors.py"
cat > core/errors.py << 'EOF'
class KernelError(Exception):
    pass

class ValidationError(KernelError):
    pass

class ExecutionError(KernelError):
    pass
EOF

echo "[+] core/validator.py"
cat > core/validator.py << 'EOF'
class Validator:
    def validate(self, packet: dict) -> bool:
        try:
            if not isinstance(packet, dict):
                return False
            if "task" not in packet:
                return False
            if not isinstance(packet.get("task"), str):
                return False
            return True
        except Exception:
            return False
EOF

echo "[+] core/executor.py"
cat > core/executor.py << 'EOF'
class Executor:
    def __init__(self, handler):
        self.handler = handler

    def execute(self, packet: dict):
        if not isinstance(packet, dict):
            raise ValueError("Packet must be dict")

        if "task" not in packet:
            raise ValueError("Missing task field")

        return self.handler(packet)
EOF

echo "[+] core/kernel.py"
cat > core/kernel.py << 'EOF'
class Kernel:
    def __init__(self, executor, validator=None):
        self.executor = executor
        self.validator = validator

    def run(self, task: str, context=None):
        packet = {
            "task": task,
            "context": context or {}
        }

        if self.validator:
            try:
                if not self.validator.validate(packet):
                    return {"status": "rejected", "result": None}
            except Exception as e:
                return {"status": "validator_error", "error": str(e), "result": None}

        try:
            result = self.executor.execute(packet)
            return {"status": "ok", "result": result}

        except Exception as e:
            return {"status": "execution_error", "error": str(e), "result": None}
EOF

# ---------------- RUNTIME ----------------

echo "[+] runtime/runner.py"
cat > runtime/runner.py << 'EOF'
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
EOF

# ---------------- EXAMPLE ----------------

echo "[+] examples/simple_executor.py"
cat > examples/simple_executor.py << 'EOF'
def handler(packet):
    return {
        "echo": packet["task"],
        "context": packet["context"]
    }
EOF

# ---------------- ENTRY ----------------

echo "[+] run.py"
cat > run.py << 'EOF'
from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler

def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    for i in range(3):
        result = kernel.run(
            task="test_task",
            context={"i": i}
        )
        print(result)

if __name__ == "__main__":
    main()
EOF

echo "[✓] kernel_v20.1 hardened system created"
echo "[→] run: cd kernel_v20 && python run.py"
