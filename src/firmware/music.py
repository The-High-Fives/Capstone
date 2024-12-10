import serial
import keyboard
import pyglet
import sys

spart_ports = ['COM4', 'COM5', 'COM6'] # guess
baud_rate = 19200  # also a guess

def main():
    # Open the SPART port
    for port in spart_ports:
        try:
            ser = serial.Serial(port, baud_rate, bytesize = serial.EIGHTBITS,
                                stopbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)
            print(f"{port} is available")

            music_player = pyglet.media.Player()
            music = pyglet.media.StaticSource(pyglet.media.load("music.wav", streaming=False))

            sf_player = pyglet.media.Player()
            soundeffect = pyglet.media.StaticSource(pyglet.media.load("gameover.wav", streaming=False))
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
                    case b'a':
                        sf_player.queue(soundeffect)
                        sf_player.play()
                    case _:
                        print("Invalid command")
        except serial.SerialException:
            print(f"Error: Could not open port {port}")
        finally:
            if 'ser' in locals() and ser.is_open:
                ser.close()

if __name__ == "__main__":
    main()