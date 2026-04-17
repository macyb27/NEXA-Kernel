class KernelError(Exception):
    pass


class ValidationError(KernelError):
    pass


class ExecutionError(KernelError):
    pass
