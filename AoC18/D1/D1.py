def calibrate(fileVar):
    with open(fileVar) as file_handle:
        x = 0
        for line in file_handle:
            x += int(line.strip().strip("+"))
    print(x)

calibrate(r'e:\aoc18\d1\input.txt')    
