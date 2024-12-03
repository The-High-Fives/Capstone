import serial

spart_port = 'COM4' # guess
baud_rate = 19200  # also a guess

ser = serial.Serial(spart_port, baud_rate, timeout = 2, bytesize = serial.EIGHTBITS,
                            stopbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)

# number = 1
# ser.write(number.to_bytes(1, 'little'))
# print(str(ser.read()))

for i in range(128):
    ser.write(i.to_bytes(1, 'little'))
    print(str(ser.read()))