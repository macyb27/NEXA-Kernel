from core.kernel import Kernel
from core.executor import Executor
from core.validator import Validator
from runtime.router import Router

# fallback handler (falls examples fehlt)
def handler(packet):
    return {"echo": packet}

def main():
    kernel = Kernel(
        executor=Executor(handler),
        validator=Validator()
    )

    router = Router(kernel)

    for i in range(3):
        result = router.route("task", {"i": i})
        print(result)

if __name__ == "__main__":
    main()
