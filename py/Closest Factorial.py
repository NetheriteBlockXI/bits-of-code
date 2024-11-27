#im better than those filthy reverse factorial.py users lol

import math

# Function to find the closest integer n such that n! ≈ approx_factorial
def find_closest_factorial(approx_value):
    n = 1  # Start from 1
    factorial = 1
    while factorial < approx_value:
        n += 1
        factorial *= n
    return n if abs(factorial - approx_value) < abs(math.factorial(n-1) - approx_value) else n - 1

# Take user input for the approximate factorial
approx_factorial = float(input("Enter the approximate factorial value: "))

# Print 4 empty lines for spacing
print("\n" * 4)

# Find the closest factorial number
original_number = find_closest_factorial(approx_factorial)
print(original_number)
