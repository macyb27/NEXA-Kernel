from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler


def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    for i in range(3):
        result = kernel.run(
            task="test_task",
            context={"i": i}
        )
        print(result)


if __name__ == "__main__":
    main()
