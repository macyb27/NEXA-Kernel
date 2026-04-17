from core.errors import ValidationError, ExecutionError


class Kernel:
    def __init__(self, executor, validator=None):
        self.executor = executor
        self.validator = validator

    def run(self, task: str, context=None):
        packet = {
            "task": task,
            "context": context or {}
        }

        if self.validator and not self.validator.validate(packet):
            raise ValidationError("Invalid task packet")

        try:
            return self.executor.execute(packet)

        except Exception as e:
            raise ExecutionError(str(e))
