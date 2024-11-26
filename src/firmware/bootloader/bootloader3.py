import serial
import sys
import threading
import time

def read_from_uart(ser):
    """
    Continuously reads from the UART port and prints the data.

    Args:
        ser (serial.Serial): The open serial port.
    """
    try:
        data = ser.read(ser.in_waiting or 1)
        # convert bytes to hex
        print(f"Received: {data.decode('utf-8')}")
    except serial.SerialException as e:
        print(f"Error reading from UART: {e}")

def send_file_over_uart(filename, port="COM5", baudrate=19200):

    try:
        # Open the file in binary read mode
        ser = serial.Serial(port, baudrate)
        ser.parity = serial.PARITY_NONE
        ser.bytesize = serial.EIGHTBITS
        ser.stopbits = serial.STOPBITS_ONE
        ser.xonxoff = 0
        ser.rtscts = 0
        
        # Start the reading thread
        read_thread = threading.Thread(target=read_from_uart, args=(ser,))
        read_thread.daemon = True
        read_thread.start()

        with open(filename, "r") as f:
            for line in f:
                # Convert the hex line to binary
                binary_data = bytes.fromhex(line.strip())
                print(f"Sent: {binary_data}")
                # Send the binary data
                ser.write(binary_data)

        read_thread.join()


        print(f"Successfully sent file: {filename}")

    except FileNotFoundError as e:
        print(f"Error: File not found: {filename}")
    except serial.SerialException as e:
        print(f"Error: Serial communication error: {e}")
    finally:
        # Close the serial port (if opened)
        if ser:
            ser.close()

if __name__ == "__main__":
    # Check if there's at least one argument (filename)
    if len(sys.argv) < 2:
        print("Usage: python send_file_uart.py <filename>")
        exit(1)

    # Get the filename from the first argument
    filename = sys.argv[1] # added to command line instead

    # Send the file
    send_file_over_uart(filename)