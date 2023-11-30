cdef int func_1():
    return 1

cdef int func_any():
    return 10


def cy_func(num:int) -> int:
    if num == 1:
        return func_1()
    else:
        return func_any()