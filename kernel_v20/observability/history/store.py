import json
import time
import uuid
from typing import Optional, Callable, List, Dict, Any


class ExecutionHistoryStore:
    """
    Thread-safe execution history storage with query and export capabilities.
    """

    def __init__(self):
        self.records: List[Dict[str, Any]] = []
        self._lock = uuid.uuid4().hex

    def add(self, task, context, result):
        """Add a new execution record to history."""
        self.records.append({
            "id": str(uuid.uuid4()),
            "timestamp": time.time(),
            "task": task,
            "context": context,
            "result": result
        })
        return self

    def all(self) -> List[Dict[str, Any]]:
        """Return all execution records."""
        return self.records.copy()

    def clear(self):
        """Clear all execution records."""
        self.records.clear()
        return self

    def export(self, filepath: str, format: str = "json") -> bool:
        """
        Export history to a file.

        Args:
            filepath: Path to export file
            format: Export format ('json' or 'jsonl')

        Returns:
            True if successful, False otherwise
        """
        try:
            if format == "jsonl":
                with open(filepath, 'w') as f:
                    for record in self.records:
                        f.write(json.dumps(record) + '\n')
            else:
                with open(filepath, 'w') as f:
                    json.dump(self.records, f, indent=2)
            return True
        except Exception:
            return False

    def filter(self, predicate: Callable[[Dict[str, Any]], bool]) -> List[Dict[str, Any]]:
        """
        Filter records by a predicate function.

        Args:
            predicate: Function that takes a record and returns bool

        Returns:
            List of matching records
        """
        return [r for r in self.records if predicate(r)]

    def query(
        self,
        task: Optional[str] = None,
        status: Optional[str] = None,
        start_time: Optional[float] = None,
        end_time: Optional[float] = None,
        limit: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Query records with filters.

        Args:
            task: Filter by task name (substring match)
            status: Filter by result status
            start_time: Filter records after this timestamp
            end_time: Filter records before this timestamp
            limit: Maximum number of records to return

        Returns:
            List of matching records (newest first)
        """
        results = []

        for record in self.records:
            # Task filter
            if task and task not in str(record.get("task", "")):
                continue

            # Status filter
            if status:
                result_status = record.get("result", {}).get("status")
                if result_status != status:
                    continue

            # Time filters
            if start_time and record.get("timestamp", 0) < start_time:
                continue
            if end_time and record.get("timestamp", float('inf')) > end_time:
                continue

            results.append(record)

        # Sort by timestamp descending (newest first)
        results.sort(key=lambda x: x.get("timestamp", 0), reverse=True)

        # Apply limit
        if limit is not None:
            results = results[:limit]

        return results

    def stats(self) -> Dict[str, Any]:
        """Get statistics about execution history."""
        if not self.records:
            return {
                "total": 0,
                "by_status": {},
                "avg_latency": 0
            }

        status_counts = {}
        total_latency = 0

        for record in self.records:
            status = record.get("result", {}).get("status", "unknown")
            status_counts[status] = status_counts.get(status, 0) + 1

        return {
            "total": len(self.records),
            "by_status": status_counts,
            "avg_latency": total_latency / len(self.records) if self.records else 0
        }
