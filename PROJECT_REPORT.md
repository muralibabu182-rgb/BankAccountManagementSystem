# Bank Account Management System Using Java - Project Report

> Educational mini-project. Not a real banking application. Data is kept in memory only and is lost when the program ends.

**Contents:** 1 Overview | 2 Folder structure | 3 Source code (see `SOURCE_CODE.md` and the `src` folder) | 4 Compile and run | 5 Sample output | 6 OOP traceability | 7 README (see `README.md`) | 8 Test cases | 9 Viva questions | 10 Final checklist

---

## 1. Project Overview

**Title:** Bank Account Management System Using Java

**Problem statement:** Manual or ad-hoc record keeping of bank accounts is error-prone. A small program is needed that can create accounts, move money safely between them, keep a history of every transaction and refuse invalid operations, so that students can see how OOP organises a real-world problem.

**Objectives**
- Build a menu-driven console application with Scanner input and console output.
- Apply all 21 mandatory Java OOP concepts in code that actually does useful work.
- Keep business rules (BankService) separate from the menu (Main).
- Handle invalid input without crashing.

**Scope:** Create Savings/Current accounts, deposit, withdraw, transfer, balance, details, search, list, history, close, statistics, exit. Single user, in-memory storage.

**Main features:** see README Section 3.

**Technologies used:** Java (Java 8-compatible syntax), `java.util` (Scanner, LinkedHashMap, ArrayList), `java.math.BigDecimal`, `java.time.LocalDateTime`. No frameworks or external libraries.

**Limitations:** in-memory data only (lost on exit), no database/file storage, no login or PIN, no interest or fees, simple validation rules, one user at a time.

---

## 2. Project Folder Structure

```
BankAccountManagementSystem/
|-- README.md
|-- PROJECT_REPORT.md
|-- SOURCE_CODE.md
|-- compile_and_run.bat
|-- src/
|   `-- com/
|       `-- bank/
|           |-- model/
|           |   |-- AccountType.java
|           |   |-- BankAccount.java
|           |   |-- CurrentAccount.java
|           |   |-- Person.java
|           |   |-- SavingsAccount.java
|           |   |-- Transaction.java
|           |   `-- TransactionType.java
|           |-- service/
|           |   |-- BankException.java
|           |   |-- BankService.java
|           |   `-- TransactionOperations.java
|           `-- app/
|               `-- Main.java
`-- out/            (created by javac; contains the .class files)
```

---

## 3. Complete Source Code

All 11 Java files are in the `src` folder, each at the exact relative path above. They are also collected, with their paths, in `SOURCE_CODE.md`.

---

## 4. How to Compile and Run (Windows)

**Step 1 - Check Java**
Open Command Prompt (or the VS Code terminal) and run:
```
java -version
javac -version
```
Both must print a version (JDK 8 or later). If `javac` is "not recognized", install a JDK and add its `bin` folder to PATH.

**Step 2 - Open the folder in VS Code**
1. Install the "Extension Pack for Java" (optional but helpful).
2. File > Open Folder > choose `BankAccountManagementSystem` (the folder that contains `src`).
3. Open the terminal with Ctrl + ` (backtick). The terminal must be in the project root.

**Step 3 - Compile all files**
```
mkdir out
javac -d out src\com\bank\model\*.java src\com\bank\service\*.java src\com\bank\app\*.java
```
PowerShell alternative (compiles every .java file found):
```
javac -d out (Get-ChildItem -Recurse src -Filter *.java).FullName
```
`-d out` puts the compiled `.class` files in the folder `out`, in package folders.

**Step 4 - Run**
```
java -cp out com.bank.app.Main
```
`-cp out` tells Java where the classes are; `com.bank.app.Main` is the fully qualified class name.

**Shortcut:** run `compile_and_run.bat` from the project root.

**Common errors**

| Error message | Cause and fix |
|---|---|
| `'javac' is not recognized` | JDK not installed or not on PATH. Install a JDK and reopen the terminal. |
| `package com.bank.model does not exist` | Files were compiled separately or from the wrong folder. Compile all three package folders in one command, from the project root. |
| `Could not find or load main class com.bank.app.Main` | Run from the project root and use `-cp out` with the full name `com.bank.app.Main` (not `Main`). Compile first. |
| `class X is public, should be declared in a file named X.java` | The file name must match the public class name exactly (capital letters included). |
| `error: no source files` / `file not found` | The path is wrong. Check you are in the folder that contains `src`. |
| `cannot find symbol` | A file was edited incorrectly or an import is missing. Check the spelling and the `import` lines. |

---

## 5. Sample Console Output

This output was produced by actually running the compiled program with the inputs shown (typed values appear after each prompt). Dates and times will differ on your computer. Transaction IDs are global, so they are not consecutive for one account (account 1 shows 1, 3, 4, 5 because other accounts used IDs 2 and 6).

Covered: creating a savings account, creating a current account, deposit, withdrawal, an invalid withdrawal, a transfer, searching an account, transaction history, closing an account (and a rejected deposit to the closed account), statistics and exit.

```
=========================================
     BANK ACCOUNT MANAGEMENT SYSTEM
=========================================

1. Create New Account
2. Deposit Money
3. Withdraw Money
4. Transfer Money
5. Check Account Balance
6. View Account Details
7. Search Account
8. Display All Accounts
9. View Transaction History
10. Close Account
11. View Total Accounts
0. Exit

[ ... main menu is displayed again ... ]
Enter your choice: 1

--- Create New Account ---
Enter customer name        : ravi kumar
Enter age                  : 25
Enter phone number (10 digits): 9876543210
Enter address              : 12 Gandhi Road, Hosur
Select account type:
  1. Savings Account (minimum opening deposit Rs. 500.00)
  2. Current Account (minimum opening deposit Rs. 1000.00)
Enter type (1 or 2)      : 1
Enter opening deposit      : 5000

SUCCESS: Savings Account created.
Account Number  : 1000000001
Account Type    : Savings Account
Holder Name     : Ravi Kumar
Age             : 25
Phone           : ******3210
Address         : 12 Gandhi Road, Hosur
Balance         : Rs. 5000.00
Status          : ACTIVE
Opened On       : 2026-10-14 01:36:25
Account Rule    : Savings - minimum opening deposit Rs. 500.00

[ ... main menu is displayed again ... ]
Enter your choice: 1

--- Create New Account ---
Enter customer name        : Anitha S
Enter age                  : 32
Enter phone number (10 digits): 9123456780
Enter address              : 45 Main Street, Hosur
Select account type:
  1. Savings Account (minimum opening deposit Rs. 500.00)
  2. Current Account (minimum opening deposit Rs. 1000.00)
Enter type (1 or 2)      : 2
Enter opening deposit      : 10000

SUCCESS: Current Account created.
Account Number  : 1000000002
Account Type    : Current Account
Holder Name     : Anitha S
Age             : 32
Phone           : ******6780
Address         : 45 Main Street, Hosur
Balance         : Rs. 10000.00
Status          : ACTIVE
Opened On       : 2026-10-14 01:36:27
Account Rule    : Current - minimum opening deposit Rs. 1000.00

[ ... main menu is displayed again ... ]
Enter your choice: 2

--- Deposit Money ---
Enter account number : 1000000001
Enter amount to deposit: 2500
SUCCESS: Rs. 2500.00 deposited. New balance: Rs. 7500.00

[ ... main menu is displayed again ... ]
Enter your choice: 3

--- Withdraw Money ---
Enter account number : 1000000001
Enter amount to withdraw: 1000
SUCCESS: Rs. 1000.00 withdrawn. New balance: Rs. 6500.00

[ ... main menu is displayed again ... ]
Enter your choice: 3

--- Withdraw Money ---
Enter account number : 1000000001
Enter amount to withdraw: 99999
FAILED: Insufficient balance. Available: Rs. 6500.00, requested: Rs. 99999.00.

[ ... main menu is displayed again ... ]
Enter your choice: 4

--- Transfer Money ---
Enter source account number      : 1000000001
Enter destination account number : 1000000002
Enter amount to transfer          : 1500
SUCCESS: Rs. 1500.00 transferred from account 1000000001 to account 1000000002.
Source account balance is now Rs. 5000.00.

[ ... main menu is displayed again ... ]
Enter your choice: 7

--- Search Account ---
1. Search by account number
2. Search by customer name
Enter option: 1
Enter account number: 1000000002

SUCCESS: Account found.
Account Number  : 1000000002
Account Type    : Current Account
Holder Name     : Anitha S
Age             : 32
Phone           : ******6780
Address         : 45 Main Street, Hosur
Balance         : Rs. 11500.00
Status          : ACTIVE
Opened On       : 2026-10-14 01:36:27
Account Rule    : Current - minimum opening deposit Rs. 1000.00

[ ... main menu is displayed again ... ]
Enter your choice: 9

--- Transaction History ---
Enter account number: 1000000001

Transaction History - Account 1000000001 (Ravi Kumar)
------------------------------------------------------------------------------------
ID    Date/Time            Type                   Amount Related A/C   Balance After
------------------------------------------------------------------------------------
1     2026-10-14 01:36:25  Opening Deposit       5000.00 -                   5000.00
3     2026-10-14 01:36:28  Deposit               2500.00 -                   7500.00
4     2026-10-14 01:36:29  Withdrawal            1000.00 -                   6500.00
5     2026-10-14 01:36:30  Transfer Out          1500.00 1000000002          5000.00
------------------------------------------------------------------------------------
Total transactions: 4

[ ... main menu is displayed again ... ]
Enter your choice: 1

--- Create New Account ---
Enter customer name        : Meena Devi
Enter age                  : 40
Enter phone number (10 digits): 9988776655
Enter address              : 7 Park Lane, Hosur
Select account type:
  1. Savings Account (minimum opening deposit Rs. 500.00)
  2. Current Account (minimum opening deposit Rs. 1000.00)
Enter type (1 or 2)      : 1
Enter opening deposit      : 500

SUCCESS: Savings Account created.
Account Number  : 1000000003
Account Type    : Savings Account
Holder Name     : Meena Devi
Age             : 40
Phone           : ******6655
Address         : 7 Park Lane, Hosur
Balance         : Rs. 500.00
Status          : ACTIVE
Opened On       : 2026-10-14 01:36:34
Account Rule    : Savings - minimum opening deposit Rs. 500.00

[ ... main menu is displayed again ... ]
Enter your choice: 3

--- Withdraw Money ---
Enter account number : 1000000003
Enter amount to withdraw: 500
SUCCESS: Rs. 500.00 withdrawn. New balance: Rs. 0.00

[ ... main menu is displayed again ... ]
Enter your choice: 10

--- Close Account ---
Enter account number: 1000000003
Account to close: Savings Account[number=1000000003, holder=Meena Devi, balance=Rs. 0.00, status=ACTIVE]
Type CLOSE (capital letters) to close account 1000000003: CLOSE
SUCCESS: Account 1000000003 has been closed.

[ ... main menu is displayed again ... ]
Enter your choice: 2

--- Deposit Money ---
Enter account number : 1000000003
Enter amount to deposit: 100
FAILED: Account 1000000003 is closed. No operations are allowed on a closed account.

[ ... main menu is displayed again ... ]
Enter your choice: 8

--- All Accounts ---
----------------------------------------------------------------------------------
No.  Account No.  Holder                 Type              Balance (Rs.) Status 
----------------------------------------------------------------------------------
1    1000000001   Ravi Kumar             Savings Account         5000.00 ACTIVE 
2    1000000002   Anitha S               Current Account        11500.00 ACTIVE 
3    1000000003   Meena Devi             Savings Account            0.00 CLOSED 
----------------------------------------------------------------------------------

[ ... main menu is displayed again ... ]
Enter your choice: 11

--- Account Statistics ---
Total accounts created : 3
Accounts stored        : 3
Active accounts        : 2
Closed accounts        : 1
Active percentage      : 66.7%

[ ... main menu is displayed again ... ]
Enter your choice: 0

Thank you for using the BANK ACCOUNT MANAGEMENT SYSTEM.
Note: all data was stored in memory only and is now discarded.
```

---

## 6. Mandatory OOP Traceability Report

| Req. | Java concept | Class / file | Method or code location | How it is demonstrated |
|---|---|---|---|---|
| A | Classes and encapsulation | `Person.java`, `BankAccount.java`, `Transaction.java`, `BankService.java` | private fields; getters/setters in `Person`; getters only in `BankAccount` | 11 types (classes, one interface, two enums). Fields are private. The balance can change only through `deposit()` / `withdraw()`, never by a setter. |
| B | Data types, constants, variable scope | `BankAccount`, `BankService`, `SavingsAccount`, `Main` | `int` age and `totalAccountsCreated`; `long accountNumber`; `double` in `getActiveAccountPercentage()`; `boolean active`; `String` names; enums `AccountType`; constants `MIN_OPENING_BALANCE`, `MIN_AGE`, `CURRENCY_LABEL` | `final` constants hold fixed values. Instance variables (`balance`), static variables (`totalAccountsCreated`) and local variables (`running` in `Main.main`, `count` in `getActiveAccountCount`) are all used and commented. |
| C | Operators and precedence | `BankService.isAgeValid()`, `getActiveAccountPercentage()`; `BankAccount` | `age >= MIN_AGE && age <= MAX_AGE`; `(double) active / total * 100`; `nextAccountNumber += 1`; `active ? "ACTIVE" : "CLOSED"` | Arithmetic, relational, logical, assignment and conditional operators are used. The comments above both methods explain the precedence order. |
| D | Type conversion and casting | `BankService.getActiveAccountPercentage()` | `(double) active / total * 100` | An `int` is cast to `double` only for a percentage in the statistics report, to avoid integer division. Money is never cast; it stays `BigDecimal`. |
| E | Enum | `AccountType.java`, `TransactionType.java` | `BankService.createAccount()` switch; `Main.readAccountType()`; `BankAccount.getAccountType()` | `AccountType` has `SAVINGS` and `CURRENT` and a display name. It decides which subclass is created and is printed in all account views. |
| F | Control flow | `Main`, `BankService`, `BankAccount` | `if`/`else if`: `Main.searchAccount()`; `switch`: `Main.main()`, `BankService.createAccount()`; `for`: `Main.printAccountTable()`, `BankAccount.displayTransactionHistory()`; `while`: `Main.main()`; `do-while`: `createAccount()`; `break`: `isPhoneValid()` and switch cases; `continue`: `getActiveAccountCount()`; `return`: throughout | Every statement type is used for real work (menu loop, validation, listing, counting). |
| G | Array of objects | `BankService.getAllAccounts()`, `Main.printAccountTable(BankAccount[])` | `BankAccount[] allAccounts = bankService.getAllAccounts();` | The array holds Savings and Current accounts together and is used to print the accounts table and the name-search results. Storage and lookup use a `LinkedHashMap<Long, BankAccount>` (fast search, no duplicate keys). |
| H | Console input and formatted output | `Main.readLine()`, `readAmount()`, `printAccountTable()`; `BankAccount.formatAmount()` | `Scanner`; `System.out.printf(...)`; `String.format(Locale.US, "%.2f", amount)` | All input comes from `Scanner`. Money always prints with two decimals. Invalid text throws `BankException` that is caught in `main`, so the program never terminates unexpectedly. |
| I | Constructor overloading | `Person`, `Transaction`, `SavingsAccount`, `CurrentAccount` | `Person()` and `Person(String,int,String,String)`; two `Transaction` constructors; `SavingsAccount(long, Person)` and `(long, Person, BigDecimal)` | A default constructor and parameterized constructors exist; the shorter ones chain to the longer ones with `this(...)`. |
| J | Method overloading | `BankAccount` | `displayAccount()` / `displayAccount(boolean)`; `deposit(amount)` / `deposit(amount, type, related)`; `withdraw(...)` | Same method name, different parameter lists. `Main.viewAccountDetails()` calls both `displayAccount` versions. |
| K | Static variables and methods | `BankAccount`, `Transaction` | `static int totalAccountsCreated`; `static getTotalAccountsCreated()`; `static generateAccountNumber()`; `Transaction.transactionCounter` | The counter is incremented in the `BankAccount` constructor, so it only counts accounts that were really created. Menu option 11 reads it with `BankAccount.getTotalAccountsCreated()`. |
| L | `this` keyword | `Person`, `BankAccount`, `Transaction`, `SavingsAccount` | `this.name = name;` in constructors; `this(...)` in `Person()` and `SavingsAccount(long, Person)` | `this.field` separates instance variables from parameters; `this(...)` chains constructors. |
| M | String methods | `Main`, `BankService` | `trim()`: `Main.readLine()`, `createAccount()`; `equalsIgnoreCase()`: `Main.viewAccountDetails()`; `equals()`: `Main.searchAccount()`, `Main.closeAccount()`; `contains()`: `BankService.searchByName()`; `split()`: `BankService.toTitleCase()`; also `substring`, `toLowerCase`, `matches` | Used for cleaning input, validating names, confirming "CLOSE", searching by name and formatting names ("ravi kumar" becomes "Ravi Kumar"). |
| N | Inheritance | `BankAccount`, `SavingsAccount`, `CurrentAccount` | `class SavingsAccount extends BankAccount`; `class CurrentAccount extends BankAccount` | One base class with two subclasses. `Person` is not a parent of accounts: an account HAS-A person (composition), which is the logical relationship. |
| O | `super` keyword | `SavingsAccount`, `CurrentAccount` | `super(accountNumber, holder, openingBalance)` in constructors; `super.getAccountSummary()` in `getAccountSummary()` | The constructor calls the parent constructor; the overridden method reuses the parent text and appends its own rule line. |
| P | Overriding and dynamic binding | `SavingsAccount`, `CurrentAccount`, `BankService.createAccount()`, `Main` | `@Override getAccountType()`, `getMinimumOpeningBalance()`, `getAccountSummary()`; `BankAccount account = new SavingsAccount(...)` | The variable type is `BankAccount`; at run time the subclass method runs. The output shows "Savings - minimum opening deposit Rs. 500.00" for savings and "Current - ... Rs. 1000.00" for current accounts. |
| Q | Abstract class | `BankAccount.java` | `public abstract class BankAccount`; `abstract getAccountType()`; `abstract getMinimumOpeningBalance()` | Cannot be instantiated; both subclasses must implement the two abstract methods. |
| R | Interface | `TransactionOperations.java`, `BankService.java`, `Main.java` | `interface TransactionOperations` (deposit, withdraw, transfer); `BankService implements TransactionOperations`; `TransactionOperations operations = bankService;` | `Main` performs deposit, withdraw and transfer through the interface reference. |
| S | Object class methods | `BankAccount`, `Person`, `Transaction` | `toString()` in all three; `equals()` and `hashCode()` in `BankAccount` | `toString()` output is shown when closing an account ("Account to close: Savings Account[number=...]"). `equals`/`hashCode` use only the immutable account number, never the balance. |
| T | `final` method | `BankAccount.java` | `public final boolean isValidAmount(BigDecimal amount)` | Final because the "amount must be greater than zero" rule must be identical for every account type. It is called from `BankService.requireValidAmount()`. |
| U | Custom packages | all files | `com.bank.model`, `com.bank.service`, `com.bank.app` | Three packages with matching folders, `package` declarations and `import` statements. `Main` contains only menu code; rules are in `BankService`. |

---

## 7. README

See `README.md` in the project folder.

---

## 8. Test Cases

Test data: assume a fresh start of the program. Accounts created in order get the numbers 1000000001, 1000000002, ... "Actual result" and "Pass/Fail" are blank for you to fill in while testing. (The author ran scripted sessions that exercised these scenarios, but you should run and record your own results.)

| ID | Operation | Input | Expected result | Actual result | Pass/Fail |
|---|---|---|---|---|---|
| TC01 | Create savings account | Name `ravi kumar`, age 25, phone 9876543210, address `12 Gandhi Road, Hosur`, type 1, deposit 5000 | Account 1000000001 created; name shown as "Ravi Kumar"; balance Rs. 5000.00; phone shown masked | | |
| TC02 | Create current account | Name `Anitha S`, age 32, valid phone, address, type 2, deposit 10000 | Account 1000000002 created; type Current Account | | |
| TC03 | Unique account numbers | Create three accounts | Numbers are 1000000001, 1000000002, 1000000003; none repeats | | |
| TC04 | Empty name | Name left empty | FAILED: Customer name must not be empty. | | |
| TC05 | Name with digits | `Ravi123` | FAILED: name must contain only letters and spaces | | |
| TC06 | Age below 18 | 17 | FAILED: Age must be between 18 and 100. | | |
| TC07 | Age not a number | `abc` | FAILED: Age must be a whole number | | |
| TC08 | Invalid phone | `12345` | FAILED: Phone number must contain exactly 10 digits. | | |
| TC09 | Address too short | `abc` | FAILED: Address must have at least 5 characters. | | |
| TC10 | Invalid account type | `3` | FAILED: Invalid account type. Enter 1 or 2. | | |
| TC11 | Opening deposit below minimum (savings) | 100 | FAILED: must be at least Rs. 500.00; no account created | | |
| TC12 | Opening deposit below minimum (current) | 500 | FAILED: must be at least Rs. 1000.00 | | |
| TC13 | Opening deposit not a number | `abc` | FAILED: Invalid amount | | |
| TC14 | Valid deposit | Account 1000000001, 2500 | SUCCESS; new balance Rs. 7500.00 | | |
| TC15 | Deposit negative amount | -50 | FAILED: Amount must be greater than zero; balance unchanged | | |
| TC16 | Deposit zero | 0 | FAILED: Amount must be greater than zero | | |
| TC17 | Deposit with 3 decimals | 10.555 | FAILED: Invalid amount (maximum two decimal places) | | |
| TC18 | Deposit to missing account | 9999999999, 100 | FAILED: Account 9999999999 does not exist. | | |
| TC19 | Non-numeric account number | `abc` | FAILED: Invalid account number | | |
| TC20 | Valid withdrawal | 1000 from balance 7500 | SUCCESS; balance Rs. 6500.00 | | |
| TC21 | Withdraw more than balance | 99999 from balance 6500 | FAILED: Insufficient balance; balance still Rs. 6500.00 | | |
| TC22 | Withdraw negative amount | -10 | FAILED: Amount must be greater than zero | | |
| TC23 | Withdraw exactly the balance | Full balance | SUCCESS; balance Rs. 0.00 | | |
| TC24 | Valid transfer | 1000000001 to 1000000002, 1500 | SUCCESS; source decreases by 1500.00, destination increases by 1500.00 | | |
| TC25 | Transfer to same account | 1000000001 to 1000000001 | FAILED: Source and destination accounts must be different. | | |
| TC26 | Transfer to missing account | to 5555555555 | FAILED: Account 5555555555 does not exist.; no balance changes | | |
| TC27 | Transfer with insufficient funds | 99999 | FAILED: Insufficient balance; BOTH balances unchanged (check with option 8) | | |
| TC28 | Transfer negative amount | -5 | FAILED: Amount must be greater than zero; both balances unchanged | | |
| TC29 | Check balance | Existing account | Holder, status and balance shown | | |
| TC30 | Search by account number | Existing / missing number | Details shown / "does not exist" message | | |
| TC31 | Search by name | Option 2, `ravi` | Matching accounts listed (case-insensitive) | | |
| TC32 | Display all accounts | Option 8 with no accounts | "No accounts have been created yet." | | |
| TC33 | Display all accounts | Option 8 with accounts | Table with all accounts, Active/Closed status, two-decimal balances | | |
| TC34 | Transaction history | Account that did deposit, withdrawal, transfer | Opening deposit, deposit, withdrawal and transfer rows with date/time, amount, related account and balance after | | |
| TC35 | Close account with balance | Account with balance above zero | FAILED: cannot be closed while it has a balance | | |
| TC36 | Close account (valid) | Zero balance, type `CLOSE` | SUCCESS: Account closed; status CLOSED | | |
| TC37 | Close cancelled | Zero balance, type `close` (lowercase) | "Account closing cancelled"; account stays ACTIVE | | |
| TC38 | Operations on closed account | Deposit, withdraw, transfer using the closed account | FAILED: Account ... is closed | | |
| TC39 | Invalid menu input | `99`, `abc`, empty line | FAILED: Invalid choice...; menu shown again; no crash | | |
| TC40 | View total accounts | Option 11 | Correct totals of created, active and closed accounts, and active percentage | | |
| TC41 | Exit | Option 0 | Goodbye message and note that data is discarded; program ends | | |

---

## 9. Viva Preparation (Questions and Answers)

**1. What is a class and an object?** A class is a blueprint that defines fields and methods. An object is an instance of that class created with `new`. `SavingsAccount` is a class; `new SavingsAccount(...)` creates an object.

**2. What is encapsulation and where is it used here?** Hiding data by making fields private and giving controlled access through methods. In `BankAccount` the `balance` is private and can change only through `deposit()` and `withdraw()`, which check the rules.

**3. What is inheritance?** One class acquires the fields and methods of another using `extends`. `SavingsAccount` and `CurrentAccount` extend `BankAccount`, so they reuse its code.

**4. Why is Person not a parent of the accounts?** Inheritance means "is-a". An account is not a person. The account "has a" person, so `BankAccount` contains a `Person` object (composition).

**5. What is polymorphism?** One interface, many forms. A `BankAccount` reference can hold a `SavingsAccount` or a `CurrentAccount`, and the same call, `getAccountSummary()`, behaves differently for each.

**6. What is dynamic binding?** The method to execute is chosen at run time from the actual object type. In `createAccount()` the variable is `BankAccount account` but it refers to a `SavingsAccount` or `CurrentAccount`, so the overridden method of that subclass runs.

**7. What is abstraction, and what is an abstract class?** Abstraction hides details and shows only what is needed. An abstract class cannot be instantiated and may contain abstract methods without a body. `BankAccount` is abstract and declares `getAccountType()` and `getMinimumOpeningBalance()`, which each subclass must implement.

**8. What is an interface? Difference from an abstract class?** An interface declares method signatures that implementing classes must provide. `TransactionOperations` is implemented by `BankService`. A class can implement many interfaces but extend only one class; an abstract class can hold fields and ready-made methods.

**9. Explain constructor overloading.** Several constructors with different parameters. `Person()` and `Person(name, age, phone, address)`; `SavingsAccount(number, holder)` calls `this(...)` to reuse the longer constructor.

**10. Explain method overloading and how it differs from overriding.** Overloading: same name, different parameters, in the same class, resolved at compile time (`displayAccount()` and `displayAccount(boolean)`). Overriding: a subclass gives its own version of an inherited method with the same signature, resolved at run time (`getAccountSummary()`).

**11. What do `this` and `super` do?** `this` refers to the current object (`this.name = name`) or calls another constructor (`this(...)`). `super` refers to the parent: `super(...)` calls the parent constructor and `super.getAccountSummary()` calls the parent's method.

**12. What do `static` and `final` mean?** `static` members belong to the class, not an object: `totalAccountsCreated` is shared by all accounts. `final` means it cannot change (constants), cannot be overridden (the method `isValidAmount`), or cannot be extended (a final class).

**13. Why use packages?** To organise classes, avoid name clashes and separate responsibilities: `model` (data), `service` (rules), `app` (menu). Folder names must match the package names.

**14. How is exception handling done?** Rule violations throw the custom `BankException`. `Main.main()` wraps the menu in `try { ... } catch (BankException e)` and prints the message, so the program continues. Numbers typed as text are validated before conversion so `NumberFormatException` does not escape.

**15. Why BigDecimal instead of double for money?** `double` cannot represent many decimal values exactly (0.1 + 0.2 is not exactly 0.3), so balances could drift. `BigDecimal` stores exact decimal values; it is compared with `compareTo()` and printed with two decimals.

**16. Why a LinkedHashMap for accounts?** The account number is the key, so searching is fast and a key cannot be duplicated. It also keeps insertion order for listing. It is an in-memory structure, so data is lost when the program stops.

**17. How does a transfer avoid partial completion?** `BankService.transfer()` first checks that the accounts differ, both exist and are active, the amount is valid and the source has enough money. Only after every check passes does it withdraw from one account and deposit into the other.

**18. How are transactions validated and recorded?** Amount must be greater than zero (the `final` method `isValidAmount`), within two decimals, the account must be active and the balance sufficient. Each successful operation adds an immutable `Transaction` object (type, amount, time, related account, balance after) to the account's history.

**19. Why override `equals()` and `hashCode()` using only the account number?** The account number never changes and identifies the account. The balance changes, so using it would make equal accounts become unequal (and break hash-based collections).

**20. What is the role of the static counter?** `BankAccount.totalAccountsCreated` is incremented in the constructor, so it counts every account that was really created, even after some are closed. A static method returns it.

---

## 10. Final Verification Checklist

How it was verified: the source was compiled with the JDK 21 compiler using `-source 8 -target 8` (no errors, only obsolete-option notices), and scripted console sessions were run, including the invalid-input cases. It was **not** run on a real Java 8 installation, because only JDK 21 was available when it was written. Please run the compile commands from Section 4 on your own computer as the final check.

| # | Requirement | Implemented in | Status |
|---|---|---|---|
| A | Classes and encapsulation (4+ classes, private fields, getters/setters) | `Person`, `BankAccount`, `Transaction`, `BankService` | Verified |
| B | int, long, double, boolean, String, enum; constants; instance/local/static variables | `BankAccount`, `BankService`, `Main` | Verified |
| C | Operators and precedence comment | `BankService.isAgeValid()`, `getActiveAccountPercentage()` | Verified |
| D | Type conversion with explanation | `BankService.getActiveAccountPercentage()` | Verified |
| E | Enum used in the application | `AccountType`, `TransactionType` | Verified |
| F | if, if-else, switch, for, while, break, continue, return | `Main`, `BankService` | Verified |
| G | Array of objects used meaningfully | `BankService.getAllAccounts()`, `Main.printAccountTable()` | Verified |
| H | Scanner input, printf/String.format output, invalid input handled | `Main`, `BankAccount.formatAmount()` | Verified |
| I | Constructor overloading and chaining | `Person`, `Transaction`, `SavingsAccount`, `CurrentAccount` | Verified |
| J | Method overloading | `BankAccount.displayAccount()`, `deposit()`, `withdraw()` | Verified |
| K | Static counter and static method | `BankAccount.totalAccountsCreated`, `getTotalAccountsCreated()` | Verified |
| L | `this` and `this(...)` | `Person`, `SavingsAccount`, `CurrentAccount` | Verified |
| M | trim, equalsIgnoreCase, equals, contains, split | `Main`, `BankService` | Verified (indexOf and compareTo for Strings are not used; equals and contains satisfy the requirement) |
| N | Inheritance (base + 2 subclasses) | `BankAccount` to `SavingsAccount`, `CurrentAccount` | Verified |
| O | `super` in constructor and overridden method | `SavingsAccount`, `CurrentAccount` | Verified |
| P | Overriding and dynamic binding | `BankService.createAccount()`, `getAccountSummary()` | Verified |
| Q | Abstract class with abstract methods | `BankAccount` | Verified |
| R | Interface, implemented and used by reference | `TransactionOperations`, `BankService`, `Main` | Verified |
| S | `toString()`, `equals()`, `hashCode()` | `BankAccount`, `Person`, `Transaction` | Verified |
| T | `final` method with comment | `BankAccount.isValidAmount()` | Verified |
| U | Two or more custom packages | `com.bank.model`, `com.bank.service`, `com.bank.app` | Verified |

Banking rules 1-15 (unique numbers, positive amounts, no overdraw, valid and atomic transfers, no operations on closed accounts, transaction history with type/amount/time/accounts, two-decimal output, BigDecimal, no credentials) are implemented in `BankService` and `BankAccount` and are covered by test cases TC01-TC41.
