class KernelFreeze:
    """
    Final architecture freeze marker.
    No structural changes allowed beyond this point.
    """

    VERSION = "v21.0"

    @staticmethod
    def assert_frozen():
        return True

    @staticmethod
    def info():
        return {
            "status": "frozen",
            "version": KernelFreeze.VERSION,
            "modification_policy": "NO_CORE_CHANGES_ALLOWED"
        }
