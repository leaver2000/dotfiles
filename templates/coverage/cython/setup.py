import os
from setuptools import Extension, setup
from Cython.Build import cythonize
from pathlib import Path
import numpy as np

os.environ["TEST"] = "TRUE"
TEST = bool(os.environ.get("TEST", False))

PACKAGE_DIR = "src"
PROJECT_NAME = "my_module"
ROOT_DIR = Path(__file__).parent / PACKAGE_DIR

compiler_directives: dict[str, int | bool] = {"language_level": 3}
define_macros: list[tuple[str, str]] = [
    ("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")
]

if TEST:
    # in order to compile the cython code for test coverage
    # we need to include the following compiler directives...
    compiler_directives.update({"linetrace": True, "profile": True})
    # and include the following trace macros
    define_macros.extend([("CYTHON_TRACE", "1"), ("CYTHON_TRACE_NOGIL", "1")])


def get_sources(pattern: str) -> list[str]:
    return [file.as_posix() for file in ROOT_DIR.rglob(pattern)]


extension_modules = cythonize(
    [
        Extension(
            f"{PROJECT_NAME}.lib",
            sources=get_sources("*.pyx"),
            include_dirs=[np.get_include()],
            define_macros=define_macros,
        ),
    ],
    compiler_directives=compiler_directives,
)

setup(ext_modules=extension_modules)
