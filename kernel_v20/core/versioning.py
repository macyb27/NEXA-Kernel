"""
NEXA-Kernel v2.0 Core Versioning Module
Execution contract versioning.
"""

__version__ = "2.0.6"


class ExecutionContractVersion:
    """Execution contract version tracker."""

    VERSION = "v2.0.6"

    @staticmethod
    def validate():
        return True

    @staticmethod
    def info():
        return {
            "contract_version": ExecutionContractVersion.VERSION,
            "stable": True
        }
