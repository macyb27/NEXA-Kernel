def handler(packet):
    return {
        "echo": packet["task"],
        "context": packet["context"]
    }
