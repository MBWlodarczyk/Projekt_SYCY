#!/usr/bin/env python
#-- coding: utf-8 --

import sys
from ctypes import *

def encipher(v, k):
    y = c_uint32(v[0])
    z = c_uint32(v[1])
    suma = c_uint32(0)
    delta = 0x9e3779b9
    n = 32
    w = [0,0]

    while(n>0):
        suma.value += delta
        y.value += ( z.value << 4 ) + k[0] ^ z.value + suma.value ^ ( z.value >> 5 ) + k[1]
        z.value += ( y.value << 4 ) + k[2] ^ y.value + suma.value ^ ( y.value >> 5 ) + k[3]
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w

def decipher(v, k):
    y = c_uint32(v[0])
    z = c_uint32(v[1])
    suma = c_uint32(0xc6ef3720)
    delta = 0x9e3779b9
    n = 32
    w = [0,0]

    while(n>0):
        z.value -= ( y.value << 4 ) + k[2] ^ y.value + suma.value ^ ( y.value >> 5 ) + k[3]
        y.value -= ( z.value << 4 ) + k[0] ^ z.value + suma.value ^ ( z.value >> 5 ) + k[1]
        suma.value -= delta
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w

if name == "main":
    key = [3189148321, 381982883, 1585950744 , 1457420293]
    v = [1385482522,639876499]
    enc = encipher(v,key)
    print(enc)
    print(decipher(enc,key))
