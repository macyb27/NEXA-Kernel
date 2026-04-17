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
