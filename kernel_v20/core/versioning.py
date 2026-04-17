class ExecutionContractVersion:
    VERSION = "v20.6"

    @staticmethod
    def validate():
        return True

    @staticmethod
    def info():
        return {
            "contract_version": ExecutionContractVersion.VERSION,
            "stable": True
        }
