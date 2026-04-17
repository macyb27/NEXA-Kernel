import json
import time
import uuid


class ExecutionHistoryStore:
    def __init__(self):
        self.records = []

    def add(self, task, context, result):
        self.records.append({
            "id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "task": task,
            "context": context,
            "result": result
        })

    def all(self):
        return self.records
