from observability.history.store import ExecutionHistoryStore

history_store = ExecutionHistoryStore()


def record_execution(task, context, result):
    history_store.add(task, context, result)
    return result
