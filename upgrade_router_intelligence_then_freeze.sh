#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Upgrading Router Intelligence → then preparing Kernel Freeze..."

cd $PROJECT

# =========================================================
# 1. INTELLIGENT ROUTER (UPGRADED)
# =========================================================

mkdir -p runtime

cat > runtime/router.py << 'EOF'
from runtime.router_intelligence import RouterIntelligence


class Router:
    def __init__(self, kernel, plugin_manager=None):
        self.kernel = kernel
        self.plugin_manager = plugin_manager
        self.intel = RouterIntelligence()

    def route(self, task: str, context=None, route_type=None):
        context = context or {}

        # -----------------------------
        # AUTO ROUTE SELECTION (INTELLIGENCE)
        # -----------------------------
        if route_type is None:
            kernel_score = self.intel.score("kernel")
            plugin_score = self.intel.score("plugin")

            route_type = "kernel" if kernel_score >= plugin_score else "plugin"

        # -----------------------------
        # KERNEL PATH
        # -----------------------------
        if route_type == "kernel":
            result = self.kernel.run(task, context)
            success = result.get("status") == "ok"
            self.intel.update("kernel", success)
            return result

        # -----------------------------
        # PLUGIN PATH
        # -----------------------------
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

            result = self.plugin_manager.execute(plugin_name, {
                "task": task,
                "context": context
            })

            success = result.get("status") in ["ok", "success"]
            self.intel.update("plugin", success)

            return result

        return {
            "status": "route_error",
            "error": f"unknown route_type: {route_type}"
        }
EOF

# =========================================================
# 2. ROUTER INTELLIGENCE CORE (ENHANCED)
# =========================================================

cat > runtime/router_intelligence.py << 'EOF'
class RouterIntelligence:
    def __init__(self):
        self.stats = {
            "kernel": {"success": 1, "fail": 1},
            "plugin": {"success": 1, "fail": 1}
        }

    def score(self, route_type):
        s = self.stats.get(route_type, {"success": 1, "fail": 1})
        return s["success"] / (s["success"] + s["fail"])

    def update(self, route_type, success=True):
        if route_type not in self.stats:
            self.stats[route_type] = {"success": 0, "fail": 0}

        if success:
            self.stats[route_type]["success"] += 1
        else:
            self.stats[route_type]["fail"] += 1

    def snapshot(self):
        return self.stats
EOF

# =========================================================
# 3. OPTIONAL: ROUTER TEST ENTRY
# =========================================================

cat > run_router_intelligent.py << 'EOF'
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

    for i in range(5):
        print(router.route("task_" + str(i), {"i": i}))


if __name__ == "__main__":
    main()
EOF

# =========================================================
# 4. KERNEL FREEZE LAYER (FINAL LOCK)
# =========================================================

cat > core/freeze.py << 'EOF'
class KernelFreeze:
    """
    Final architecture freeze marker.
    No structural changes allowed beyond this point.
    """

    VERSION = "v21.0"

    @staticmethod
    def assert_frozen():
        return True

    @staticmethod
    def info():
        return {
            "status": "F
