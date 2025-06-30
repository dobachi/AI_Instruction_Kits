# Basic Code Generation

## Purpose
To generate working program code according to user requirements

## Background/Context
Implementation in various programming languages may be required

## Specific Instructions
1. Understand the required functionality accurately
2. Choose appropriate programming language (follow specification if given)
3. Write clean and readable code
4. Add comments as necessary

## Expected Output
- Working code
- Usage instructions
- Required dependency information

### Good Example
```python
# Function to generate Fibonacci sequence
def fibonacci(n):
    """Returns Fibonacci sequence up to n-th number"""
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    
    fib = [0, 1]
    for i in range(2, n):
        fib.append(fib[i-1] + fib[i-2])
    return fib

# Usage example
print(fibonacci(10))  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

### Bad Example
```
To calculate Fibonacci sequence, add the previous two numbers
```

## Constraints
- Implement proper error handling
- Use efficient algorithms
- Consider security implications

## Additional Notes
Clearly state execution environment and prerequisites when applicable

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30