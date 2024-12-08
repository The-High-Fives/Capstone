import serial
import keyboard
import pyglet

import serial
import sys

spart_ports = ['COM4', 'COM5', 'COM6'] # guess
baud_rate = 19200  # also a guess

def main():

    if len(sys.argv) != 2:
        print("Usage: python bootloader5.py <instruction_file>")
        sys.exit()

    # Open the SPART port
    for port in spart_ports:
        try:
            ser = serial.Serial(port, baud_rate, timeout = 0.1, bytesize = serial.EIGHTBITS,
                                stopbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)
            print(f"{port} is available")

            music_player = pyglet.media.Player()
            music = pyglet.media.StaticSource(pyglet.media.load("music.wav", streaming=False))

            while True:
                if keyboard.read_key() == 's':
                    break
            
            start_code = 'a' & 0xFF
            ser.write(start_code.to_bytes(1, 'little'))
            while True:
                c = ser.read()
                
                match c:
                    case b'p':
                        print("Playing music")
                        music_player.queue(music)
                        music_player.play()
                    case b'h':
                        print("Stopping music")
                        music_player.pause()
                    case b'r':
                        print("Resuming music")
                        music_player.play()
                    case b'q':
                        print("Exiting")
                        break
                    case _:
                        print("Invalid command")
            
            break

        except serial.SerialException:
            print(f"Error: Could not open port {port}")
        finally:
            if 'ser' in locals() and ser.is_open:
                ser.close()

if __name__ == "__main__":
    main()