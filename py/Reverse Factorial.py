def reverse_factorial(num):
    #I hate doing this
    if num < 1:
        return None
    
    n = 1
    while num > 1:
        n += 1
        if num % n == 0:
            num //= n
        else:
            return None

    return n if num == 1 else None

number = int(input("Enter a number to find its reverse factorial: "))
result = reverse_factorial(number)

if result:
    print(f"The reverse factorial of {number} is {result}!")
else:
    print(f"{number} is not a factorial of any integer.")
