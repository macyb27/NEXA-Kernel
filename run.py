#!/usr/bin/env python3
"""
NEXA-Kernel Runner Entry Point
Delegates to kernel_v20 implementation.
"""

import sys
import os

# Add kernel_v20 to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'kernel_v20'))

from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from examples.simple_executor import handler


def main():
    print("[NEXA-Kernel v2.0] Starting...")
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
