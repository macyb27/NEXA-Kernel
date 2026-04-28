#!/usr/bin/env python3
"""
NEXA-Kernel Intelligent Router Runner
Delegates to kernel_v20 implementation.
"""

import sys
import os

# Add kernel_v20 to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'kernel_v20'))

from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from runtime.router import Router

# Fallback handler
def handler(packet):
    return {"echo": packet.get("task"), "context": packet.get("context")}


def main():
    print("[NEXA-Kernel v2.0] Intelligent Router Starting...")

    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    router = Router(kernel)

    for i in range(3):
        result = router.route("task", {"i": i})
        print(result)


if __name__ == "__main__":
    main()
