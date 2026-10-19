#pragma once
#include <stddef.h>
#define QUBITS_PER_PAGE ((size_t)8)
static const size_t PAGE_0=(size_t)0;
static const size_t PAGE_1=(size_t)1;
static const size_t PAGE_2=(size_t)2;
static const size_t PAGE_3=(size_t)3;
static const size_t PAGE_4=(size_t)4;
#define QUBIT_GLOBAL_ADDR(p,q) ((p)*8+(q))
