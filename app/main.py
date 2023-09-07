from fastapi import FastAPI, HTTPException, Path

app = FastAPI()


@app.get("/", response_model=dict)
async def index() -> dict:
    """
    An endpoint that returns a Hello World message.
    """
    return {"message": "Hello World"}


@app.get("/hello/{name}", response_model=dict)
async def hello(name: str = Path(..., title="The name to say hello")) -> dict:
    """
    An endpoint that takes a name as a parameter in the path and returns a welcome message.
    """
    if not name.isalpha():
        message: str = "Name should only contain alphabets"
        raise HTTPException(status_code=400, detail=message)
    return {"message": f"Hello, {name}"}
