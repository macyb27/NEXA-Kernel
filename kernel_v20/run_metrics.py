from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler
from runtime.metrics_runner import MetricsRunner


def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    runner = MetricsRunner(kernel)

    for i in range(5):
        result = runner.run(
            task="test_task",
            context={"i": i}
        )
        print(result)

    print("\n[METRICS REPORT]")
    print(runner.report())


if __name__ == "__main__":
    main()
