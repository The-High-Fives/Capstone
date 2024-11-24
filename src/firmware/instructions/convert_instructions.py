import sys

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 convert_instructions.py <instruction_file>")
        return

    instruction_file = sys.argv[1]

    if (instruction_file[-4:] != ".hex"):
        print("Instruction file must be a .hex file")
        return

    with open(instruction_file, 'r') as f:
        instructions = f.readlines()

    for i in range(len(instructions)):
        instructions[i] = instructions[i].strip()

        if (len(instructions[i]) != 8):
            continue

        byte1 = instructions[i][0:2]
        byte2 = instructions[i][2:4]
        byte3 = instructions[i][4:6]
        byte4 = instructions[i][6:8]

        with open('init0.hex', 'a') as f:
            f.write(f"{byte1}\n")
        with open('init1.hex', 'a') as f:
            f.write(f"{byte2}\n")
        with open('init2.hex', 'a') as f:
            f.write(f"{byte3}\n")
        with open('init3.hex', 'a') as f:
            f.write(f"{byte4}\n")


if __name__ == '__main__':
    main()