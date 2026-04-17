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
