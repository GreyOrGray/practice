def calibrate(fileVar):
    x = 0
    y =[]
    y.append(x)
    while 1==1:
        with open(fileVar) as file_handle:
            for line in file_handle:
                x += int(line.strip().strip("+"))
                if x in y:
                    print(x)
                    #print(y)
                    return
                else:
                    y.append(x)

    print(y)

calibrate(r'e:\aoc18\d1\input.txt')    
