class Validator:
    def validate(self, packet: dict) -> bool:
        try:
            if not isinstance(packet, dict):
                return False
            if "task" not in packet:
                return False
            if not isinstance(packet.get("task"), str):
                return False
            return True
        except Exception:
            return False
