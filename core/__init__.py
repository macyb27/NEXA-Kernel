"""
NEXA-Kernel Core Package (Legacy)
This package is deprecated. Use kernel_v20.core instead.
"""

import warnings

warnings.warn(
    "kernel_v20.core is the canonical implementation. "
    "This root-level core package is deprecated.",
    DeprecationWarning,
    stacklevel=2
)

from core.errors import KernelError, ValidationError, ExecutionError
from core.executor import Executor
from core.validator import Validator
from core.kernel import Kernel

__version__ = "2.0.6"
__all__ = [
    "KernelError",
    "ValidationError",
    "ExecutionError",
    "Executor",
    "Validator",
    "Kernel",
]
