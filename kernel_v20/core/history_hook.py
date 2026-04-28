from observability.history.store import ExecutionHistoryStore

# Global singleton instance
history_store = ExecutionHistoryStore()


def record_execution(task, context, result):
    """
    Record an execution to history.

    Args:
        task: Task identifier
        context: Execution context
        result: Execution result

    Returns:
        The original result (passthrough)
    """
    history_store.add(task, context, result)
    return result


def get_history(*args, **kwargs):
    """Query execution history with filters."""
    return history_store.query(*args, **kwargs)


def clear_history():
    """Clear all execution history."""
    history_store.clear()


def export_history(filepath, format="json"):
    """Export history to a file."""
    return history_store.export(filepath, format)