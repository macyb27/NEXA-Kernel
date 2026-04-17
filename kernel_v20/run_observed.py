from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.observed_runner import ObservedRunner

def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    runner = ObservedRunner(kernel)

    for i in range(3):
        result = runner.run(
            task="test_task",
            context={"i": i}
        )
        print(result)

if __name__ == "__main__":
    main()
