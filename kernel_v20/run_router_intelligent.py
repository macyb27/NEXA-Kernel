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
