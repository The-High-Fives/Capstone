import serial

spart_port = 'COM5' # guess
baud_rate = 19200  # also a guess

def send_instruction_count(count):
    """
    Sends the number of instructions as a 4-byte integer.
    """
    for i in range(4):
        number = (count >> (8 * i)) & 0xFF
        ser.write(number.to_bytes(1, 'little'))
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
    for line in instructions:
        instruction = int(line.strip(), 16)  # Convert hex string to integer
        for i in range(4):
            instruction_byte = (instruction >> (8 * i)) & 0xFF
            ser.write(instruction_byte.to_bytes(1, 'little'))

    print("All instructions sent.")

if __name__ == "__main__":
    # Open the SPART port
    try:
        ser = serial.Serial(spart_port, baud_rate, timeout = 2, bytesize = serial.EIGHTBITS,
                            stopbits = serial.STOPBITS_ONE, parity = serial.PARITY_NONE)
        print(f"{spart_port} is available")

        # Send the instructions from the hex file
        filename = './whoami.hex'  # up for grabs!
        send_instructions(filename)

        hello = str(ser.read(5))
        print(hello)

    except serial.SerialException:
        print(f"Error: Could not open port {spart_port}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()