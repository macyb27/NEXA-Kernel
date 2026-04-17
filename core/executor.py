class Executor:
    def __init__(self, handler):
        self.handler = handler

    def execute(self, packet: dict):
        return self.handler(packet)
