class Validator:
    def validate(self, packet: dict) -> bool:
        if not isinstance(packet, dict):
            return False

        if "task" not in packet:
            return False

        return True
