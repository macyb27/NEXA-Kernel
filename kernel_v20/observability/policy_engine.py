class PolicyEngine:
    def __init__(self):
        self.rules = []

    def add_rule(self, rule_fn):
        self.rules.append(rule_fn)

    def evaluate(self, packet: dict) -> dict:
        for rule in self.rules:
            result = rule(packet)
            if result is not True:
                return {
                    "allowed": False,
                    "reason": result
                }

        return {"allowed": True}
