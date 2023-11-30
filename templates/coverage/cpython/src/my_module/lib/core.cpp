#define PY_SSIZE_T_CLEAN
#include <Python.h>

void print_python_version() {
    //
    printf("Python version: %s", Py_GetVersion());
}

static PyObject* py_print_python_version(PyObject* self, PyObject* args) {
    print_python_version();
    return Py_None;
};

long is_prime(long n) {
    //
    if (n < 2) {
        return 0;
    }
    for (long i = 2; i < n; i++) {
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}

static PyObject* py_is_prime(PyObject* self, PyObject* args) {
    //
    int n;
    if (!PyArg_ParseTuple(args, "i", &n)) {
        return NULL;
    }
    return PyBool_FromLong(is_prime(n));
};

static PyMethodDef lib_methods[] = {
    //
    {"print_python_version", py_print_python_version, METH_VARARGS, "Print Python version"},
    {"is_prime", py_is_prime, METH_VARARGS, "Check if a number is prime"},
    {NULL, NULL, 0, NULL}
    //
};

static struct PyModuleDef lib_module = {
    //
    PyModuleDef_HEAD_INIT, "lib", "Python API", -1, lib_methods
    //
};

PyMODINIT_FUNC PyInit_lib(void) {
    //
    return PyModule_Create(&lib_module);
}
