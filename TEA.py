from ctypes import *

#enkrypcja
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

#dekrypcja
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
#lamanie cezara
def ceasar(message,letters):
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
#funkcja głowna
if __name__ == '__main__':

    message = 'GIEWIVrGMTLIVrHIQS'  # encrypted message
    LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    ceasar(message,LETTERS)

    key = [0xbe168aa1, 0x16c498a3, 0x5e87b018, 0x56de7805]
    #tekst do zakodowania
    secret=list("tekst mega tajny nie znajdowalny")
    cypher=[]
    if len(secret)%2==1:
        secret.append(" ")
    for i in range(int(len(secret)/2)):
        cypher.append(encipher([ord(secret[2*i]),ord(secret[2*i+1])],key)[0])
        cypher.append(encipher([ord(secret[2*i]),ord(secret[2*i+1])],key)[1])
    print(cypher)
    decode=[]
    for i in range(int(len(secret)/2)):
        decode.append(chr(decipher([(cypher[2*i]),cypher[2*i+1]],key)[0]))
        decode.append(chr(decipher([(cypher[2*i]),cypher[2*i+1]],key)[1]))
    print(convert(decode))
