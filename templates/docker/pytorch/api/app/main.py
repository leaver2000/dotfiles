import torch
import pydantic
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


class Item(pydantic.BaseModel):
    message: str


@app.get("/api", response_model=Item)
def api() -> dict[str, str]:
    return {"message": f"INFO: {torch.cuda.get_device_name(device)}"}
