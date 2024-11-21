import serial
import time
import math
import sys

spart_port = 'COM5' # guess
baud_rate = 19200  # also a guess

# Banked base addresses for a 4-bank system
BANK_BASE_ADDRESSES = [0x55000000, 0x55000004, 0x55000008, 0x5500000C] # also a guess??

def mem_write(address, data):
    """
    Writes data to a specified address over SPART in little-endian format.
    """
    # send address, byte by byte in little-endian order
    for i in range(4):
        addr_byte = (address >> (8 * i)) & 0xFF
        ser.write(addr_byte.to_bytes(1, 'little'))
    
    # we dont need this but anyway
    # send data, byte by byte in little-endian order
    for i in range(4):
        data_byte = (data >> (8 * i)) & 0xFF
        ser.write(data_byte.to_bytes(1, 'little'))
        print(f"Sent Data Byte: {data_byte:02X}")

def send_instruction_count(count):
    """
    Sends the number of instructions as a 4-byte integer.
    """
    ser.write(count.to_bytes(4, 'little'))
    print(f"Sent instruction count: {count}")

def send_instructions(filename):
    """
    Sends instructions from the specified hex file in a banked memory structure.
    """
    with open(filename, "rb") as f: # binary read mode!
        instructions = f.readlines()

    # Send instruction count first
    num_instructions = len(instructions)
    send_instruction_count(num_instructions)

    # Load each instruction into the appropriate bank
    bank_counters = [0] * 4  # Track offsets within each bank
    for index, line in enumerate(instructions):
        instruction = int(line.strip(), 16)  # Convert hex string to integer
        bank = index % 4  # Determine bank based on instruction index
        address = BANK_BASE_ADDRESSES[bank] + (bank_counters[bank] * 4)
        
        mem_write(address, instruction)
        bank_counters[bank] += 1  # Move to next address in this bank

    print("All instructions sent.")

# need to look into the ECALL thing
def poll_for_completion(end_address):
    """
    Polls the device for completion by reading a specific address until
    a non-zero value (indicating an 'ECALL') is detected.
    """
    read_data = 0
    while read_data == 0:
        read_data = mem_read(end_address)
        print("IN PROGRESS : Polling for completion.")

    print("ECALL detected. Bootloading complete.")

def mem_read(address):
    """
    Reads data from a specified address over SPART.
    """
    for i in range(4):
        addr_byte = (address >> (8 * i)) & 0xFF
        ser.write(addr_byte.to_bytes(1, 'little'))

    read_data = ser.read(4)  # Read 4 bytes
    return int.from_bytes(read_data, 'little')

# Main 
if __name__ == "__main__":
    # Open the SPART port
    try:
        ser = serial.Serial(spart_port, baud_rate, timeout = 2, bytesize = serial.EIGHTBITS,
                            stopbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)
        print(f"{spart_port} is available")

        # Send the instructions from the hex file
        filename = './whoami.hex'  # up for grabs!
        send_instructions(filename)

        # Start polling for the end signal
        exe_end_address = 0xaa800000  # 'ECALL' address also up for grabs!!
        poll_for_completion(exe_end_address)

    except serial.SerialException:
        print(f"Error: Could not open port {spart_port}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
