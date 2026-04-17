#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="kernel_v20"

echo "[+] Extending Kernel v20 with Policy + Plugin Layer..."

cd $PROJECT

# =========================================================
# 🧠 POLICY LAYER
# =========================================================

echo "[+] Creating observability/policy_engine.py"

mkdir -p observability

cat > observability/policy_engine.py << 'EOF'
class PolicyEngine:
    def __init__(self):
        self.rules = []

    def add_rule(self, rule_fn):
        self.rules.append(rule_fn)

    def evaluate(self, packet: dict) -> dict:
        for rule in self.rules:
            result = rule(packet)
            if result is not True:
                return {
                    "allowed": False,
                    "reason": result
                }

        return {"allowed": True}
EOF

# =========================================================
# 🧠 POLICY WRAPPER RUNNER
# =========================================================

echo "[+] Creating runtime/policy_runner.py"

mkdir -p runtime

cat > runtime/policy_runner.py << 'EOF'
from core.kernel import Kernel
from observability.policy_engine import PolicyEngine


class PolicyRunner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
        self.policy = PolicyEngine()

    def add_policy(self, rule_fn):
        self.policy.add_rule(rule_fn)

    def run(self, task, context=None):
        context = context or {}

        packet = {
            "task": task,
            "context": context
        }

        decision = self.policy.evaluate(packet)

        if not decision["allowed"]:
            return {
                "status": "rejected_by_policy",
                "reason": decision["reason"]
            }

        return self.kernel.run(task, context)
EOF

# =========================================================
# 🧠 PLUGIN SYSTEM
# =========================================================

echo "[+] Creating plugins/registry.py"

mkdir -p plugins

cat > plugins/registry.py << 'EOF'
class PluginRegistry:
    def __init__(self):
        self.plugins = {}

    def register(self, name, plugin_fn):
        self.plugins[name] = plugin_fn

    def get(self, name):
        return self.plugins.get(name)
EOF

# =========================================================
# 🧠 PLUGIN MANAGER
# =========================================================

echo "[+] Creating plugins/manager.py"

cat > plugins/manager.py << 'EOF'
from plugins.registry import PluginRegistry


class PluginManager:
    def __init__(self):
        self.registry = PluginRegistry()

    def register_plugin(self, name, fn):
        self.registry.register(name, fn)

    def execute(self, name, packet):
        plugin = self.registry.get(name)

        if not plugin:
            return {
                "status": "plugin_not_found",
                "plugin": name
            }

        return plugin(packet)
EOF

# =========================================================
# 🧠 PLUGIN ENTRYPOINT EXAMPLE
# =========================================================

echo "[+] Creating plugins/builtins/local_plugin.py"

mkdir -p plugins/builtins

cat > plugins/builtins/local_plugin.py << 'EOF'
def echo_plugin(packet):
    return {
        "plugin": "echo_plugin",
        "echo": packet.get("task"),
        "context": packet.get("context")
    }
EOF

# =========================================================
# 🧠 PLUGIN ENTRYPOINT WRAPPER TEST
# =========================================================

echo "[+] Creating run_plugins.py"

cat > run_plugins.py << 'EOF'
from plugins.manager import PluginManager
from plugins.builtins.local_plugin import echo_plugin


def main():
    pm = PluginManager()
    pm.register_plugin("echo", echo_plugin)

    result = pm.execute("echo", {
        "task": "hello_plugin",
        "context": {"i": 1}
    })

    print(result)


if __name__ == "__main__":
    main()
EOF

# =========================================================
# DONE
# =========================================================

echo "[✓] Policy + Plugin system applied successfully"
echo "[→] Run plugin test: python run_plugins.py"
