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

            while True:
                music_player = pyglet.media.Player()
                music = pyglet.media.StaticSource(pyglet.media.load("music.mp3", streaming=False))
                music_player.queue(music)
                while True:
                    c = ser.read()
                    
                    match c:
                        case b's':
                            print("Stopping music")
                            gameover = pyglet.media.Player()
                            gameover_sf = pyglet.media.StaticSource(pyglet.media.load("gameover.wav", streaming=False))
                            gameover.queue(gameover_sf)
                            gameover.play()
                            break

                        case b'a':
                            sf_player = pyglet.media.Player()
                            soundeffect = pyglet.media.StaticSource(pyglet.media.load("click.wav", streaming=False))
                            sf_player.queue(soundeffect)
                            sf_player.play()
                        case _:
                            print("Playing music")
                            music_player.play()
                        
        except serial.SerialException:
            print(f"Error: Could not open port {port}")
        finally:
            if 'ser' in locals() and ser.is_open:
                ser.close()

if __name__ == "__main__":
    main()