import threading
import time


class SafeExecutor:
    """
    Thread-based safe executor with timeout protection.
    Always returns consistent response format: {status, data?, error?}
    """

    def __init__(self, timeout=2.0):
        self.timeout = timeout

    def execute(self, fn, packet):
        result = {
            "status": "ok",
            "data": None,
            "error": None
        }

        def target():
            try:
                result["data"] = fn(packet)
                result["status"] = "ok"
            except Exception as e:
                result["status"] = "error"
                result["error"] = str(e)

        thread = threading.Thread(target=target, daemon=True)
        thread.start()
        thread.join(self.timeout)

        if thread.is_alive():
            return {
                "status": "timeout",
                "data": None,
                "error": f"execution_timeout_after_{self.timeout}s"
            }

        return result
