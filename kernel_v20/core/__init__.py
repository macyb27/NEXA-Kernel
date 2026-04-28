"""
NEXA-Kernel v2.0 Core Package
Execution kernel core components
"""

from .errors import KernelError, ValidationError, ExecutionError
from .executor import Executor
from .validator import Validator
from .result import Result
from .kernel import Kernel

__version__ = "2.0.6"
__all__ = [
    "KernelError",
    "ValidationError",
    "ExecutionError",
    "Executor",
    "Validator",
    "Result",
    "Kernel",
]