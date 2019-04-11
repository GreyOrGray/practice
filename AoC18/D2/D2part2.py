def calibrate(fileVar):
    from collections import Counter
    with open(fileVar) as file_handle1:
        for line1 in file_handle1:
            with open(fileVar) as file_handle2:
                for line2 in file_handle2:
                    c1 = Counter(line1)
                    c2 = Counter(line2)
                    c3 = Counter(line1)
                    c1.subtract(c2)
                    c3.subtract(c2)
                    if sum(c3.values()) == 0:
                        c1 += Counter()
                        if sum(c1.values()) == 1:
                            count = 0
                            while count <= 1:
                                count = 0
                                test = line1
                                for i,v in enumerate(line1):
                                    if line1[i] != line2[i]:
                                        test = test[:i] + "" + test[i+1:]
                                        count += 1
                                if count == 1:
                                    print (line1, line2, test)
                            
                                    return

        #print (c1*c2)
    

calibrate(r'e:\aoc18\d2\input.txt')    
