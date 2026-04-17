class RouterIntelligence:
    def __init__(self):
        self.stats = {
            "kernel": {"success": 1, "fail": 1},
            "plugin": {"success": 1, "fail": 1}
        }

    def score(self, route_type):
        s = self.stats.get(route_type, {"success": 1, "fail": 1})
        return s["success"] / (s["success"] + s["fail"])

    def update(self, route_type, success=True):
        if route_type not in self.stats:
            self.stats[route_type] = {"success": 0, "fail": 0}

        if success:
            self.stats[route_type]["success"] += 1
        else:
            self.stats[route_type]["fail"] += 1

    def snapshot(self):
        return self.stats
