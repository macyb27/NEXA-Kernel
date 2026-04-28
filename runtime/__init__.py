"""
NEXA-Kernel Runtime Package (Legacy)
This package is deprecated. Use kernel_v20.runtime instead.
"""

import warnings

warnings.warn(
    "kernel_v20.runtime is the canonical implementation. "
    "This root-level runtime package is deprecated.",
    DeprecationWarning,
    stacklevel=2
)

from runtime.runner import Runner

__version__ = "2.0.6"
__all__ = ["Runner"]
