class Executor:
    def __init__(self, handler):
        self.handler = handler

    def execute(self, packet: dict):
        if not isinstance(packet, dict):
            raise ValueError("Packet must be dict")

        if "task" not in packet:
            raise ValueError("Missing task field")

        return self.handler(packet)
