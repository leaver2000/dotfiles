import datetime

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pydantic


class Item(pydantic.BaseModel):
    message: str


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api", response_model=Item)
def api() -> dict[str, str]:
    return {"message": f"Hello API! {datetime.datetime.now()}"}
