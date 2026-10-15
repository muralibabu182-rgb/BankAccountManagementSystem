# Bank Account Management System Using Java

**Type:** Console-based, menu-driven mini-project  |  **Language:** Java (Java 8-compatible syntax)  |  **Libraries:** standard Java only

> Educational project. It simulates basic banking operations and is **not** a real banking application. It is not connected to any bank, payment gateway or real account, and it stores no PINs or passwords.

## 1. Objective
To build a menu-driven console application that creates bank accounts and performs basic banking operations, while demonstrating the main Object-Oriented Programming concepts of Java (classes, inheritance, abstraction, interfaces, polymorphism, packages and more).

## 2. Software Requirements
- JDK 8 or later (tested with the JDK 21 compiler using `-source 8 -target 8`)
- Any editor: VS Code, IntelliJ IDEA, Eclipse or NetBeans
- No Maven, Gradle, database or external library is needed

## 3. Features
1. Create a Savings or Current account (unique 10-digit account number is generated)
2. Deposit, withdraw and transfer money
3. Check balance, view full account details, search by account number (or by customer name)
4. Display all accounts, transaction history and the total number of accounts
5. Close an account (only when it is open and its balance is zero)
6. Input validation with clear messages; the program does not crash on invalid input

**Banking rules (configurable educational constants, not real bank policy)**

| Rule | Value | Where defined |
|---|---|---|
| Minimum opening deposit, Savings | Rs. 500.00 | `SavingsAccount.MIN_OPENING_BALANCE` |
| Minimum opening deposit, Current | Rs. 1000.00 | `CurrentAccount.MIN_OPENING_BALANCE` |
| Customer age | 18 to 100 | `BankService.MIN_AGE`, `MAX_AGE` |
| Phone number | exactly 10 digits | `BankService.PHONE_LENGTH` |
| Amounts | greater than zero, at most 2 decimals | `BankAccount.isValidAmount`, `BankService` |

A transfer is fully validated before any balance changes, so a failed transfer leaves both balances unchanged. Closed accounts reject deposits, withdrawals and transfers. All money uses `BigDecimal`.

## 4. Class Hierarchy
```
BankAccount (abstract)  implements nothing itself; HAS-A Person (composition)
   |-- SavingsAccount
   |-- CurrentAccount

TransactionOperations (interface)  <--  BankService (implements)
Person, Transaction, BankException, AccountType (enum), TransactionType (enum)
```
`Person` holds customer details. A bank account *has a* customer, it is not a kind of person, so composition is used instead of inheritance there.

## 5. Package Structure
```
src/com/bank/
    model/    Person, BankAccount, SavingsAccount, CurrentAccount,
              AccountType, TransactionType, Transaction
    service/  TransactionOperations, BankService, BankException
    app/      Main   (console menu only)
```

## 6. Compile and Run (Windows)
From the project root (the folder that contains `src`):
```
mkdir out
javac -d out src\com\bank\model\*.java src\com\bank\service\*.java src\com\bank\app\*.java
java -cp out com.bank.app.Main
```
Or double-click / run `compile_and_run.bat`.

## 7. OOP Concepts Implemented
Encapsulation, constants and variable scope, operators and precedence, type casting, enum, control flow, array of objects, Scanner and `printf`, constructor overloading and chaining, method overloading, static members, `this`, String methods, inheritance, `super`, overriding and dynamic binding, abstract class, interface, `toString`/`equals`/`hashCode`, `final` method, custom packages, custom exception. The exact class and method for each is listed in `PROJECT_REPORT.md` (Section 6).

## 8. Limitations
- Data is stored **in memory** (a `LinkedHashMap`) and is **lost when the program ends**. There is no database or file storage.
- Single user, no login, no interest, fees or overdraft.
- Closed accounts stay in memory (marked CLOSED) so their history can still be viewed.
- Phone numbers and names use simple rules (digits only; letters and spaces only).

## 9. Conclusion
The project shows how Java OOP concepts organise a real-world problem into small, testable classes with business rules kept separate from the user interface. It compiles with standard Java and runs as a simple menu-driven console program.
