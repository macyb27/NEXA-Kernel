import time
import uuid

def create_event(event_type: str, payload: dict):
    return {
        "id": str(uuid.uuid4()),
        "type": event_type,
        "timestamp": time.time(),
        "payload": payload
    }
