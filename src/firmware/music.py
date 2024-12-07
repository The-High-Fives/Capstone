import serial
import keyboard

spart_port = 'COM6' # guess
baud_rate = 19200  # also a guess

ser = serial.Serial(spart_port, baud_rate, timeout = 0.1, bytesize = serial.EIGHTBITS,
                    topbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)

while True:
    if keyboard.read_key() == 's':
        break

# start program
start_code = 'a' & 0xFF
ser.write(start_code.to_bytes(1, 'little'))

while True:
    ser.read