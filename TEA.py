from ctypes import *

import multiprocessing as mp

# enkrypcja
def encipher(v, k):
    y = c_uint32(v[0])
    z = c_uint32(v[1])
    sum = c_uint32(0)
    delta = 0x9E3779B9
    n = 32
    w = [0, 0]

    while (n > 0):
        sum.value += delta
        y.value += (z.value << 4) + k[0] ^ z.value + sum.value ^ (z.value >> 5) + k[1]
        z.value += (y.value << 4) + k[2] ^ y.value + sum.value ^ (y.value >> 5) + k[3]
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w


# dekrypcja
def decipher(v, k):
    y = c_uint32(v[0])
    z = c_uint32(v[1])
    sum = c_uint32(0xC6EF3720)
    delta = 0x9E3779B9
    n = 32
    w = [0, 0]

    while (n > 0):
        z.value -= (y.value << 4) + k[2] ^ y.value + sum.value ^ (y.value >> 5) + k[3]
        y.value -= (z.value << 4) + k[0] ^ z.value + sum.value ^ (z.value >> 5) + k[1]
        sum.value -= delta
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w


# lamanie cezara
def ceasar(message, letters):
    for key in range(len(LETTERS)):
        translated = ''
        for symbol in message:
            if symbol in LETTERS:
                num = LETTERS.find(symbol)
                num = num - key
                if num < 0:
                    num = num + len(LETTERS)
                translated = translated + LETTERS[num]
            else:
                translated = translated + symbol
        print('Hacking key #%s: %s' % (key, translated))


def convert(s):
    # initialization of string to ""
    new = ""

    # traverse in the string
    for x in s:
        new += x

        # return string
    return new


# funkcja głowna
if __name__ == '__main__':

    message = 'GIEWIVrGMTLIVrHIQS'  # encrypted message
    LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    ceasar(message, LETTERS)

    # tekst do zakodowania
    secret = list("%PDFtekst mega tajny nie znajdowalny")
    cypher = []
    a = 0
    b = 0
    key = [0x68756c6b, 0x69737468, 0x00000000, 0x00121212]
    for i in range(int(len(secret) / 2)):
        cypher.append(encipher([ord(secret[2 * i]), ord(secret[2 * i + 1])], key)[0])
        cypher.append(encipher([ord(secret[2 * i]), ord(secret[2 * i + 1])], key)[1])
    print(cypher)
    flag=False
    for x in range(pow(2,32)-1):
        if flag:
            break
        for y in range(pow(2,32)-1):
            if flag:
                break
            key = [0x68756c6b, 0x69737468, x, y]
            print("Checking...")
            print(key)
            if len(secret) % 2 == 1:
                secret.append(" ")
            decode = []

            decode.append(chr(decipher([(cypher[0]), cypher[1]], key)[0] % 110000))
            decode.append(chr(decipher([(cypher[0]), cypher[1]], key)[1] % 110000))
            decode.append(chr(decipher([(cypher[2]), cypher[3]], key)[0] % 110000))
            decode.append(chr(decipher([(cypher[2]), cypher[3]], key)[1] % 110000))

            if convert(decode).startswith("%PDF"):
                print("Found")
                print("Its pdf")
                print("Text:")
                for i in range(int(len(secret) / 2)):
                    decode.append(chr(decipher([(cypher[2 * i]), cypher[2 * i + 1]], key)[0] % 110000))
                    decode.append(chr(decipher([(cypher[2 * i]), cypher[2 * i + 1]], key)[1] % 110000))
                print(convert(decode))
                print("Key:")
                print(key)
                flag=True

