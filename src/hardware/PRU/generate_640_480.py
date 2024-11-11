with open("buffer_2_173.mem", "w") as outfile:
    for x in range(307200):
        if (x < 45000 and x > 10000):
            outfile.write("3\n")
        elif (x < 100000 and x > 60000):
            outfile.write("1\n")
        elif (x < 220000 and x > 160000):
            outfile.write("2\n")
        else :
            outfile.write("0\n")
