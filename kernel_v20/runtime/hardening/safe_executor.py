import threading
import time


class SafeExecutor:
    def __init__(self, timeout=2.0):
        self.timeout = timeout

    def execute(self, fn, packet):
        result = {}

        def target():
            try:
                result["data"] = fn(packet)
                result["status"] = "ok"
            except Exception as e:
                result["status"] = "error"
                result["error"] = str(e)

        thread = threading.Thread(target=target)
        thread.start()
        thread.join(self.timeout)

        if thread.is_alive():
            return {
                "status": "timeout",
                "error": "execution_timeout"
            }

        return result
