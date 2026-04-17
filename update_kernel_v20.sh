#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Updating Kernel v20 → v20.4 (final core patch)..."

cd $PROJECT

# =========================================================
# CORE RESULT CONTRACT
# =========================================================

mkdir -p core

cat > core/result.py << 'EOF'
class Result:
    def __init__(self, status="ok", data=None, error=None):
        self.status = status
        self.data = data
        self.error = error

    def to_dict(self):
        return {
            "status": self.status,
            "data": self.data,
            "error": self.error
        }
EOF

# =========================================================
# FINAL KERNEL CORE
# =========================================================

cat > core/kernel.py << 'EOF'
from core.result import Result


class Kernel:
    def __init__(self, executor, validator=None):
        self.executor = executor
        self.validator = validator

    def run(self, task: str, context=None):
        context = context or {}

        packet = {
            "task": task,
            "context": context
        }

        # validation gate
        if self.validator:
            try:
                if not self.validator.validate(packet):
                    return Result(
                        status="rejected",
                        error="validation_failed"
                    ).to_dict()
            except Exception as e:
                return Result(
                    status="validator_error",
                    error=str(e)
                ).to_dict()

        # execution gate
        try:
            output = self.executor.execute(packet)

            return Result(
                status="ok",
                data=output
            ).to_dict()

        except Exception as e:
            return Result(
                status="execution_error",
                error=str(e)
            ).to_dict()
EOF

# =========================================================
# DEBUG RUNNER (SAFE WRAPPER)
# =========================================================

mkdir -p runtime

cat > runtime/debug_runner.py << 'EOF'
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
EOF

# =========================================================
# CLEAN ENTRYPOINT
# =========================================================

cat > run.py << 'EOF'
from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.debug_runner import DebugRunner


def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    runner = DebugRunner(kernel, enabled=True)

    for i in range(3):
        out = runner.run(
            task="test_task",
            context={"i": i}
        )
        print(out)


if __name__ == "__main__":
    main()
EOF

# =========================================================
# DONE
# =========================================================

echo "[✓] Kernel successfully updated to v20.4"
echo "[→] Run: python run.py"
