import numpy as np
import time
import socket
import base64
import cv2
import sys
# noinspection PyUnresolvedReferences
import os
from pylepton import Lepton
try:
    HOST = raw_input('Please Enter The Raspberry Local IP ex:192.168.1.7\n')
    PORT = input('Please Enter New PORT ID (Recommeded Above 1000) ex:4000\n')
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(10)
    print("waiting for response from client at port ", PORT)
    conn, addr = s.accept()
    print('Connected by', addr, "Connection :", conn)
    with Lepton("/dev/spidev0.1") as l:
        num = 0
        while True:
            frame, _ = l.capture()
            cv2.normalize(frame, frame, 0, 65535, cv2.NORM_MINMAX)  # extend contrast
            np.right_shift(frame, 8, frame)  # fit data into 8 bits
            frame = np.uint8(frame)
            resized = cv2.resize(frame, (200, 200), interpolation=cv2.INTER_AREA)
            str1 = base64.b64encode(resized) + str.encode('\n')
            # print("str len= ", sys.getsizeof(str1))
            conn.sendall(str1)
            time.sleep(0.02)
except KeyboardInterrupt:
    print('Interrupted')
    conn.close()
    time.sleep(0.04)
    sys.exit(0)
    os._exit(0)