# Write a function that tests whether a string is a palindrome.

def Palindrome4(inputValue):
    return('Yep' if inputValue == inputValue[::-1] else 'Nope')
   
 
print(Palindrome4('gray'))
print(Palindrome4('wakawakaw'))