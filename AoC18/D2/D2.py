def calibrate(fileVar):
    from collections import Counter
    c1 = 0
    c2 = 0
    with open(fileVar) as file_handle:
        for line in file_handle:
            if 2 in Counter(line).values():
                c1 += 1
            if 3 in Counter(line).values():
                c2 += 1
        print (c1*c2)
    

calibrate(r'e:\aoc18\d2\input.txt')    
