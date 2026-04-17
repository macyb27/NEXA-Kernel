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
