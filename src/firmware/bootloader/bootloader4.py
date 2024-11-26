import serial
import sys
import time

def send_file_over_uart(filename, port="COM5", baudrate=19200):
    try:
        # Open serial port
        ser = serial.Serial(port, baudrate)
        ser.parity = serial.PARITY_NONE
        ser.bytesize = serial.EIGHTBITS
        ser.stopbits = serial.STOPBITS_ONE
        
        # Wait for 'B' from bootloader
        print("Waiting for 'B'...")
        while True:
            if ser.in_waiting:
                data = ser.read()
                if data == b'B':
                    print("Received 'B', starting transmission")
                    break

        # Count instructions in file
        with open(filename, "r") as f:
            instr_count = sum(1 for line in f if line.strip())
        
        # Send instruction count as 4 bytes (little endian)
        count_bytes = instr_count.to_bytes(4, byteorder='little')
        print(f"Sending instruction count: {instr_count} ({count_bytes.hex()})")
        ser.write(count_bytes)
        
        # Send instructions
        with open(filename, "r") as f:
            for i, line in enumerate(f, 1):
                if not line.strip():
                    continue
                    
                # Convert hex string to bytes (4 bytes per instruction)
                instr = bytes.fromhex(line.strip())
                print(f"Sending instruction {i}/{instr_count}: {instr.hex()}")
                ser.write(instr)
                time.sleep(0.01)  # Small delay between instructions
        
        # Wait for 'A' acknowledgment
        print("Waiting for acknowledgment ('A')...")
        start_time = time.time()
        while time.time() - start_time < 5:  # 5 second timeout
            if ser.in_waiting:
                data = ser.read()
                if data == b'A':
                    print("Received acknowledgment!")
                    break
                else:
                    print(f"Received unexpected data: {data.hex()}")
        else:
            print("Timeout waiting for acknowledgment")

        print("Transfer complete")
        ser.close()

    except Exception as e:
        print(f"Error: {e}")
        if 'ser' in locals():
            ser.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python bootloader.py <filename>")
        sys.exit(1)
    
    filename = sys.argv[1]
    send_file_over_uart(filename)