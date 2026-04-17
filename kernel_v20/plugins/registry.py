class PluginRegistry:
    def __init__(self):
        self.plugins = {}

    def register(self, name, plugin_fn):
        self.plugins[name] = plugin_fn

    def get(self, name):
        return self.plugins.get(name)
