def echo_plugin(packet):
    return {
        "plugin": "echo_plugin",
        "echo": packet.get("task"),
        "context": packet.get("context")
    }
