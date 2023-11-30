from __future__ import annotations
import os
from typing import Union
import contextlib

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import sqlalchemy
import sqlalchemy.orm
import sqlalchemy.util
import sqlalchemy.exc
from redis.client import Redis
from redis.exceptions import ConnectionError as RedisConnectionError

ENV_KEYS = [
    "REDIS_HOST",
    "REDIS_PORT",
    "REDIS_PASSWORD",
    "POSTGRES_HOST",
    "POSTGRES_PORT",
    "POSTGRES_USER",
    "POSTGRES_PASSWORD",
]


class SQLAlchemyBase(sqlalchemy.orm.DeclarativeBase):
    ...


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
db: sqlalchemy.engine.Engine
redis: Redis


@app.on_event("startup")
async def start_up_event() -> None:
    global db, redis

    db = sqlalchemy.create_engine(
        sqlalchemy.URL.create(
            drivername="postgresql+psycopg",
            username=os.getenv("POSTGRES_USER", "postgres"),
            password=os.getenv("POSTGRES_PASSWORD", "postgres"),
            host=os.getenv("POSTGRES_HOST", "localhost"),
            port=int(os.getenv("POSTGRES_PORT", 5432)),
            database=os.getenv("POSTGRES_DB", "postgres"),
        ),
    )

    redis = Redis(
        host=os.getenv("REDIS_HOST", "localhost"),
        port=int(os.getenv("REDIS_PORT", 6379)),
        password=os.getenv("REDIS_PASSWORD", None),
    )


@app.get("/")
def health() -> dict[None, None]:
    return {}


@app.get("/env", response_model=dict[str, str])
def environment() -> dict[str, str]:
    return {key: os.getenv(key, "undefined") for key in ENV_KEYS}


@app.get("/ping", response_model=dict[str, Union[str, None]])
def ping() -> dict[str, str]:
    health = {"postgres": "error", "redis": "error"}
    with contextlib.suppress(sqlalchemy.exc.OperationalError):
        SQLAlchemyBase.metadata.create_all(db)
        health["postgres"] = "ok"
    with contextlib.suppress(RedisConnectionError):
        redis.ping()
        health["redis"] = "ok"
    return health
