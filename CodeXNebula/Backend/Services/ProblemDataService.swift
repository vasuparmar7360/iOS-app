//
//  ProblemDataService.swift
//  CodeXNebula
//
//  Structured local question database. UI loads from here.
//  To add questions: insert new CodingProblem entries below.
//

import Foundation

// MARK: - AI Integration Hooks (future Gemini API)
protocol AIHintProvider {
    func fetchHint(for problemId: String, code: String) async -> String
    func explainCode(_ code: String, language: String) async -> String
    func suggestOptimization(_ code: String, language: String) async -> String
}

class ProblemDataService {
    static let shared = ProblemDataService()
    private init() {}

    // MARK: - Standard Chapter Names (Original)
    private let standardChapters = [
        "Introduction", "Variables", "Data Types", "Operators",
        "Conditional Statements", "Loops", "Functions", "Arrays",
        "Pointers", "Object Oriented Programming"
    ]

    func getChapters(for languageId: String) async -> [Chapter] {
        return standardChapters.enumerated().map { index, title in
            Chapter(
                id: "\(languageId)_ch\(index + 1)",
                title: title,
                description: "Learn \(title.lowercased()) in \(languageId.uppercased()).",
                languageId: languageId,
                sortOrder: index + 1
            )
        }
    }

    func getProblems(for chapterId: String, languageId: String) async -> [CodingProblem] {
        let db = database(for: languageId)
        return db[chapterId] ?? fallback(chapterId: chapterId, languageId: languageId)
    }

    // MARK: - Fallback
    private func fallback(chapterId: String, languageId: String) -> [CodingProblem] {
        [
            make(chapterId, languageId, "e", "Hello World",
                 "Write a program that prints 'Hello, World!'.",
                 .easy, "None", "None", "Hello, World!", "The program outputs the greeting.",
                 starterFor(languageId, .easy)),
            make(chapterId, languageId, "m", "Swap Two Variables",
                 "Swap two variables without using a third variable.",
                 .medium, "Values can be integers or floats.", "a=5, b=10", "a=10, b=5", "Use arithmetic or XOR trick.",
                 starterFor(languageId, .medium)),
            make(chapterId, languageId, "h", "Fibonacci Sequence",
                 "Print first N Fibonacci numbers using recursion.",
                 .hard, "1 <= N <= 30", "7", "0 1 1 2 3 5 8", "Each number is sum of two preceding ones.",
                 starterFor(languageId, .hard))
        ]
    }

    // MARK: - Helper
    private func make(_ chapter: String, _ lang: String, _ suffix: String,
                      _ title: String, _ desc: String, _ diff: ProblemDifficulty,
                      _ constraints: String, _ input: String, _ output: String,
                      _ explanation: String, _ starter: String) -> CodingProblem {
        CodingProblem(
            id: "\(chapter)_\(suffix)",
            title: title,
            description: desc,
            languageId: lang,
            chapterId: chapter,
            difficulty: diff,
            xpReward: diff.xpReward,
            isCompleted: false,
            constraints: [constraints],
            notes: nil,
            sampleInput: input,
            sampleOutput: output,
            explanation: explanation,
            starterCode: starter,
            estimatedTime: diff == .easy ? "5 mins" : diff == .medium ? "15 mins" : "35 mins",
            tags: [diff.rawValue]
        )
    }

    // MARK: - Starter Code by Language + Difficulty
    private func starterFor(_ lang: String, _ diff: ProblemDifficulty) -> String {
        switch lang.lowercased() {
        case "cpp", "c++":
            return "#include <iostream>\nusing namespace std;\n\nint main() {\n    // Your solution here\n    return 0;\n}"
        case "python":
            return "def solve():\n    # Your solution here\n    pass\n\nsolve()"
        case "java":
            return "public class Main {\n    public static void main(String[] args) {\n        // Your solution here\n    }\n}"
        case "swift":
            return "import Foundation\n\nfunc solve() {\n    // Your solution here\n}\n\nsolve()"
        default:
            return "#include <stdio.h>\n\nint main() {\n    // Your solution here\n    return 0;\n}"
        }
    }

    // MARK: - Full Problem Database
    private func database(for languageId: String) -> [String: [CodingProblem]] {
        var db: [String: [CodingProblem]] = [:]
        let lang = languageId.lowercased()

        // ch1 - Introduction
        let ch1 = "\(lang)_ch1"
        db[ch1] = [
            make(ch1, lang, "e", "Your First Program",
                 "Write a program that prints 'Hello, CodeX Nebula!' to the console.",
                 .easy, "No input required", "None", "Hello, CodeX Nebula!",
                 "Use the language's print statement.", starterFor(lang, .easy)),
            make(ch1, lang, "m", "User Input and Output",
                 "Read a user's name from input and print 'Welcome, <name>!'.",
                 .medium, "Name length <= 50 characters", "Alice", "Welcome, Alice!",
                 "Combine input reading with string formatting.", starterFor(lang, .medium)),
            make(ch1, lang, "h", "Basic Calculator",
                 "Build a calculator that reads two numbers and an operator (+, -, *, /) and outputs the result.",
                 .hard, "Operator is one of +, -, *, /. Divisor != 0.", "10 + 5", "15",
                 "Use conditionals to handle each operator.", starterFor(lang, .hard))
        ]

        // ch2 - Variables
        let ch2 = "\(lang)_ch2"
        db[ch2] = [
            make(ch2, lang, "e", "Declare and Print Variables",
                 "Declare an integer, a float, and a string variable. Assign values and print each one.",
                 .easy, "Use valid variable names", "None", "42\n3.14\nCodeX",
                 "Each variable type has a different declaration syntax.", starterFor(lang, .easy)),
            make(ch2, lang, "m", "Swap Two Variables",
                 "Given two integers A and B, swap their values and print them.",
                 .medium, "-10^9 <= A, B <= 10^9", "A=5 B=10", "A=10 B=5",
                 "Use a temporary variable or arithmetic swap.", starterFor(lang, .medium)),
            make(ch2, lang, "h", "Student Record Manager",
                 "Declare variables for student name, age, grade (float), and enrollment year. Read all values and print a formatted report.",
                 .hard, "Grade is between 0.0 and 10.0. Year is 4 digits.", "Alice 20 9.5 2023",
                 "Name: Alice | Age: 20 | Grade: 9.5 | Year: 2023",
                 "Format the output using string interpolation or printf.", starterFor(lang, .hard))
        ]

        // ch3 - Data Types
        let ch3 = "\(lang)_ch3"
        db[ch3] = [
            make(ch3, lang, "e", "Size of Data Types",
                 "Print the size in bytes of int, float, double, and char.",
                 .easy, "No input required", "None", "int: 4 bytes\nfloat: 4 bytes\ndouble: 8 bytes\nchar: 1 byte",
                 "Use sizeof() or the language equivalent.", starterFor(lang, .easy)),
            make(ch3, lang, "m", "Type Conversion",
                 "Read a float from input, convert it to int (truncation), and print both values.",
                 .medium, "0.0 <= input <= 10^6", "9.87", "Float: 9.87  Int: 9",
                 "Explicit casting removes the decimal part.", starterFor(lang, .medium)),
            make(ch3, lang, "h", "Overflow Detection",
                 "Read an int. Check if doubling it overflows a 32-bit signed integer. Print 'Overflow' or the result.",
                 .hard, "-2^31 <= N <= 2^31 - 1", "2000000000", "Overflow",
                 "Max 32-bit int is 2,147,483,647. Compare before multiplying.", starterFor(lang, .hard))
        ]

        // ch4 - Operators
        let ch4 = "\(lang)_ch4"
        db[ch4] = [
            make(ch4, lang, "e", "Arithmetic Operations",
                 "Read two integers. Print their sum, difference, product, and quotient.",
                 .easy, "Divisor != 0", "8 4", "12\n4\n32\n2",
                 "Apply +, -, *, / operators sequentially.", starterFor(lang, .easy)),
            make(ch4, lang, "m", "Bitwise Flags",
                 "Given an integer N, use bitwise AND to check if bits 1, 2, and 3 are set. Print which bits are set.",
                 .medium, "0 <= N <= 255", "7", "Bit 1 set\nBit 2 set\nBit 3 set",
                 "Use N & 1, N & 2, N & 4 to test individual bits.", starterFor(lang, .medium)),
            make(ch4, lang, "h", "Expression Evaluator",
                 "Read a string containing a mathematical expression like '3 + 5 * 2' and evaluate it respecting operator precedence.",
                 .hard, "Operators: +, -, *, /. Integers only.", "3 + 5 * 2", "13",
                 "Multiplication and division have higher precedence than addition and subtraction.", starterFor(lang, .hard))
        ]

        // ch5 - Conditional Statements
        let ch5 = "\(lang)_ch5"
        db[ch5] = [
            make(ch5, lang, "e", "Odd or Even",
                 "Read an integer and print whether it is 'Odd' or 'Even'.",
                 .easy, "-10^9 <= N <= 10^9", "7", "Odd",
                 "Use the modulus operator: N % 2 == 0 means Even.", starterFor(lang, .easy)),
            make(ch5, lang, "m", "Grade Classification",
                 "Given a score (0-100), print the grade: A (90-100), B (80-89), C (70-79), D (60-69), F (<60).",
                 .medium, "0 <= score <= 100", "85", "B",
                 "Use if-else if ladder to check each range.", starterFor(lang, .medium)),
            make(ch5, lang, "h", "Leap Year Checker",
                 "Determine if a given year is a leap year. A year is a leap year if divisible by 4, except century years must be divisible by 400.",
                 .hard, "1 <= year <= 9999", "2000", "Leap Year",
                 "Year 2000 is divisible by 400 so it's a leap year. 1900 is not.", starterFor(lang, .hard))
        ]

        // ch6 - Loops
        let ch6 = "\(lang)_ch6"
        db[ch6] = [
            make(ch6, lang, "e", "Print 1 to N",
                 "Read integer N. Print all numbers from 1 to N, each on a new line.",
                 .easy, "1 <= N <= 1000", "5", "1\n2\n3\n4\n5",
                 "Use a for or while loop from 1 to N.", starterFor(lang, .easy)),
            make(ch6, lang, "m", "Multiplication Table",
                 "Read integer N. Print its full multiplication table from 1 to 10.",
                 .medium, "1 <= N <= 100", "3",
                 "3 x 1 = 3\n3 x 2 = 6\n...\n3 x 10 = 30",
                 "Loop from 1 to 10 and multiply each by N.", starterFor(lang, .medium)),
            make(ch6, lang, "h", "Prime Numbers up to N",
                 "Read integer N. Print all prime numbers from 2 to N.",
                 .hard, "2 <= N <= 10^6", "20", "2 3 5 7 11 13 17 19",
                 "Use the Sieve of Eratosthenes for O(N log log N) efficiency.", starterFor(lang, .hard))
        ]

        // ch7 - Functions
        let ch7 = "\(lang)_ch7"
        db[ch7] = [
            make(ch7, lang, "e", "Sum of Two Numbers",
                 "Write a function sum(a, b) that returns the sum of two integers. Read two numbers, call the function, and print the result.",
                 .easy, "-10^9 <= a, b <= 10^9", "3 7", "10",
                 "Define the function before main and call it with the inputs.", starterFor(lang, .easy)),
            make(ch7, lang, "m", "Is Prime Function",
                 "Write a function isPrime(n) that returns true if n is prime. Use it to print 'Prime' or 'Not Prime'.",
                 .medium, "1 <= N <= 10^6", "17", "Prime",
                 "Check divisibility from 2 to sqrt(N).", starterFor(lang, .medium)),
            make(ch7, lang, "h", "Recursive Fibonacci",
                 "Write a recursive function fib(n) that returns the N-th Fibonacci number. Print fib(N).",
                 .hard, "0 <= N <= 30", "10", "55",
                 "fib(0)=0, fib(1)=1, fib(n)=fib(n-1)+fib(n-2). Add memoization to avoid TLE.", starterFor(lang, .hard))
        ]

        // ch8 - Arrays
        let ch8 = "\(lang)_ch8"
        db[ch8] = [
            make(ch8, lang, "e", "Array Sum",
                 "Read N integers into an array. Print their sum.",
                 .easy, "1 <= N <= 1000, -10^9 <= arr[i] <= 10^9", "5\n1 2 3 4 5", "15",
                 "Iterate the array accumulating the sum.", starterFor(lang, .easy)),
            make(ch8, lang, "m", "Reverse an Array",
                 "Read N integers. Print them in reversed order.",
                 .medium, "1 <= N <= 10^5", "5\n1 2 3 4 5", "5 4 3 2 1",
                 "Use two pointers from both ends and swap inward.", starterFor(lang, .medium)),
            make(ch8, lang, "h", "Maximum Subarray Sum",
                 "Find the contiguous subarray with the largest sum (Kadane's Algorithm).",
                 .hard, "1 <= N <= 10^5, -10^9 <= arr[i] <= 10^9", "8\n-2 1 -3 4 -1 2 1 -5 4", "6",
                 "The subarray [4, -1, 2, 1] has the largest sum of 6.", starterFor(lang, .hard))
        ]

        // ch9 - Pointers
        let ch9 = "\(lang)_ch9"
        db[ch9] = [
            make(ch9, lang, "e", "Address of Variable",
                 "Declare an integer variable. Print its value and its memory address.",
                 .easy, "No input", "None", "Value: 42\nAddress: 0x...",
                 "Use & to get the address in C/C++.", starterFor(lang, .easy)),
            make(ch9, lang, "m", "Swap Using Pointers",
                 "Write a function that takes two integer pointers and swaps their values. Verify the swap in main.",
                 .medium, "Values are integers", "A=10 B=20", "A=20 B=10",
                 "Dereference pointers with * to read and write values.", starterFor(lang, .medium)),
            make(ch9, lang, "h", "Dynamic Array with Pointers",
                 "Dynamically allocate an array of N integers. Fill with 1..N, compute sum, then free memory.",
                 .hard, "1 <= N <= 10^5", "5", "Sum: 15",
                 "Use malloc/new for allocation and free/delete to prevent memory leaks.", starterFor(lang, .hard))
        ]

        // ch10 - OOP
        let ch10 = "\(lang)_ch10"
        db[ch10] = [
            make(ch10, lang, "e", "Simple Class",
                 "Create a class 'Car' with attributes brand and year. Instantiate it and print the values.",
                 .easy, "No input", "None", "Brand: Toyota\nYear: 2023",
                 "Define class members and use a constructor to initialise.", starterFor(lang, .easy)),
            make(ch10, lang, "m", "Bank Account Class",
                 "Create a BankAccount class with deposit() and withdraw() methods. Read a series of transactions and print the final balance.",
                 .medium, "Balance cannot go negative. Transactions <= 100.", "1000\nD 500\nW 200", "Balance: 1300",
                 "Encapsulate balance with getter. Validate withdrawal amount.", starterFor(lang, .medium)),
            make(ch10, lang, "h", "Inheritance and Polymorphism",
                 "Create a base class 'Shape' with a virtual area() method. Derive 'Circle' and 'Rectangle'. Read type and dimensions, print area.",
                 .hard, "Dimensions > 0. Pi = 3.14159.", "Circle 5", "Area: 78.54",
                 "Use virtual/override so the correct area() is called at runtime.", starterFor(lang, .hard))
        ]

        return db
    }
}
