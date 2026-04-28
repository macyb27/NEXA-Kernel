"""
NEXA-Kernel v2.0
================

A flexible execution kernel system with plugin support, observability,
and intelligent routing capabilities.

Usage:
    from kernel_v20.core import Kernel, Executor, Validator
    from kernel_v20.runtime import Router

    kernel = Kernel(Executor(my_handler), Validator())
    result = kernel.run("my_task", {"key": "value"})

Components:
    - core: Core kernel, executor, validator, result types
    - runtime: Task runners, routing, and intelligence
    - observability: Metrics, logging, tracing, policy engine
    - plugins: Plugin management and registry
"""

__version__ = "2.0.6"
__author__ = "macyb27"
