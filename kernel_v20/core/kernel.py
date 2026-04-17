from core.result import Result
from core.freeze import KernelFreeze


class Kernel:
    def __init__(self, executor, validator=None):
        self.executor = executor
        self.validator = validator

        # freeze assertion (non-blocking safety hook)
        KernelFreeze.assert_frozen()

    def run(self, task: str, context=None):
        context = context or {}

        packet = {
            "task": task,
            "context": context
        }

        if self.validator:
            try:
                if not self.validator.validate(packet):
                    return Result(
                        status="rejected",
                        error="validation_failed"
                    ).to_dict()
            except Exception as e:
                return Result(
                    status="validator_error",
                    error=str(e)
                ).to_dict()

        try:
            output = self.executor.execute(packet)

            return Result(
                status="ok",
                data=output
            ).to_dict()

        except Exception as e:
            return Result(
                status="execution_error",
                error=str(e)
            ).to_dict()
