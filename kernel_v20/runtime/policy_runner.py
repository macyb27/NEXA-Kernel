from core.kernel import Kernel
from observability.policy_engine import PolicyEngine


class PolicyRunner:
    def __init__(self, kernel: Kernel):
        self.kernel = kernel
        self.policy = PolicyEngine()

    def add_policy(self, rule_fn):
        self.policy.add_rule(rule_fn)

    def run(self, task, context=None):
        context = context or {}

        packet = {
            "task": task,
            "context": context
        }

        decision = self.policy.evaluate(packet)

        if not decision["allowed"]:
            return {
                "status": "rejected_by_policy",
                "reason": decision["reason"]
            }

        return self.kernel.run(task, context)