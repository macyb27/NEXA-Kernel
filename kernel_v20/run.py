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
