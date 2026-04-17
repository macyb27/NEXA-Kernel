import json
from observability.events import create_event

class Logger:
    def log(self, event_type: str, payload: dict):
        event = create_event(event_type, payload)
        print("[OBS]", json.dumps(event))
        return event
