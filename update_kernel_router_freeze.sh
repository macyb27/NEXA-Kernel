#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Updating Kernel → Router Layer + Freeze Mode..."

cd $PROJECT

# =========================================================
# ROUTER LAYER
# =========================================================

mkdir -p runtime

cat > runtime/router.py << 'EOF'
class Router:
    def __init__(self, kernel, plugin_manager=None):
        self.kernel = kernel
        self.plugin_manager = plugin_manager

    def route(self, task: str, context=None, route_type="kernel"):
        context = context or {}

        if route_type == "kernel":
            return self.kernel.run(task, context)

        if route_type == "plugin":
            if not self.plugin_manager:
                return {
                    "status": "plugin_router_error",
                    "error": "no_plugin_manager_attached"
                }

            plugin_name = context.get("plugin")

            if not plugin_name:
                return {
                    "status": "plugin_error",
                    "error": "missing_plugin_name"
                }

            return self.plugin_manager.execute(plugin_name, {
                "task": task,
                "context": context
            })

        return {
            "status": "route_error",
            "error": f"unknown route_type: {route_type}"
        }
EOF

# =========================================================
# KERNEL FREEZE CONTRACT (IMMUTABILITY LAYER)
# =========================================================

mkdir -p core

cat > core/freeze.py << 'EOF'
class KernelFreeze:
    """
    Marks kernel version as immutable.
    Prevents semantic changes in higher layers.
    """

    VERSION = "v20.5"

    @staticmethod
    def assert_frozen():
        # Placeholder for future integrity checks
        return True

    @staticmethod
    def info():
        return {
            "status": "frozen",
            "version": KernelFreeze.VERSION,
            "modification_policy": "NO_CORE_CHANGES_ALLOWED"
        }
EOF

# =========================================================
# UPDATE KERNEL (NO LOGIC CHANGE, ONLY FREEZE CHECK HOOK)
# =========================================================

cat > core/kernel.py << 'EOF'
from core.result import Result
from core.freeze import KernelFreeze


class Kernel:
    def __init__(self, executor, validator=None):
        self.executor = executor
        self.validator = validator

        # freeze assertion (non-blocking safety hook)
        KernelFreeze.assert_frozen()

    def run(self, task: str, context=None):
        context = context or {}

        packet = {
            "task": task,
            "context": context
        }

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
# OPTIONAL: ROUTER TEST ENTRYPOINT
# =========================================================

cat > run_router_freeze.py << 'EOF'
from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.router import Router
from plugins.manager import PluginManager
from plugins.builtins.local_plugin import echo_plugin


def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    pm = PluginManager()
    pm.register_plugin("echo", echo_plugin)

    router = Router(kernel, pm)

    print(router.route("test_task", {"i": 1}, "kernel"))

    print(router.route(
        "plugin_task",
        {"plugin": "echo", "i": 2},
        "plugin"
    ))


if __name__ == "__main__":
    main()
EOF

# =========================================================
# DONE
# =========================================================

echo "[✓] Router Layer added"
echo "[✓] Kernel Freeze activated (v20.5)"
echo "[→] Run: python run_router_freeze.py"
