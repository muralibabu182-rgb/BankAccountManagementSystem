# Complete Source Code

Every file is shown with its exact relative path.

---

**File: src/com/bank/model/AccountType.java**

```java
package com.bank.model;

/**
 * ENUM: a fixed set of named constants.
 * AccountType is used when creating accounts (see BankService.createAccount)
 * and when printing the type of an account.
 */
public enum AccountType {
    SAVINGS("Savings Account"),
    CURRENT("Current Account");

    // Each constant carries a readable name for console output.
    private final String displayName;

    AccountType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
```

---

**File: src/com/bank/model/BankAccount.java**

```java
package com.bank.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

/**
 * ABSTRACT CLASS: the common parent of SavingsAccount and CurrentAccount.
 * It cannot be instantiated (new BankAccount(...) is a compile error), but
 * a BankAccount REFERENCE can point to a SavingsAccount or CurrentAccount
 * object. That is what makes dynamic binding possible.
 *
 * The account HAS-A Person (the account holder) - composition.
 */
public abstract class BankAccount {

    // ---------- STATIC VARIABLES AND CONSTANTS (shared by the whole class) ----------
    public static final String CURRENCY_LABEL = "Rs.";                 // final constant
    public static final long NO_RELATED_ACCOUNT = 0L;                  // final constant
    public static final DateTimeFormatter DATE_TIME_FORMAT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");        // final constant

    // Counts how many accounts have been created (increased in the constructor).
    private static int totalAccountsCreated = 0;
    // Next account number to hand out (long, because it has 10 digits).
    private static long nextAccountNumber = 1000000001L;

    // ---------- INSTANCE VARIABLES (each account has its own copy) ----------
    private final long accountNumber;          // never changes after creation
    private final Person holder;               // the customer who owns the account
    private BigDecimal balance;                // BigDecimal avoids double rounding errors
    private boolean active;                    // true = open, false = closed
    private final LocalDateTime openedOn;
    private final List<Transaction> transactions;

    /**
     * Constructor used by subclasses through super(...).
     * ENCAPSULATION: the balance can only be changed through deposit()/withdraw().
     */
    protected BankAccount(long accountNumber, Person holder, BigDecimal openingBalance) {
        // 'this.x' = instance variable, 'x' = constructor parameter.
        this.accountNumber = accountNumber;
        this.holder = holder;
        this.balance = openingBalance.setScale(2, RoundingMode.HALF_UP);
        this.active = true;
        this.openedOn = LocalDateTime.now();
        this.transactions = new ArrayList<>();

        totalAccountsCreated++;     // keeps the static counter correct

        // The opening deposit is the first entry in the transaction history.
        this.transactions.add(new Transaction(TransactionType.OPENING_DEPOSIT,
                this.balance, accountNumber, this.balance));
    }

    // ---------- STATIC METHODS ----------

    /** Static method: returns how many accounts have been created so far. */
    public static int getTotalAccountsCreated() {
        return totalAccountsCreated;
    }

    /** Static method: hands out the next account number (10-digit long). */
    public static long generateAccountNumber() {
        long number = nextAccountNumber;
        nextAccountNumber += 1;     // compound assignment operator
        return number;
    }

    /** Formats a money value with exactly two decimals, e.g. 2500.00 */
    public static String formatAmount(BigDecimal amount) {
        // Locale.US makes sure the decimal separator is always a dot.
        return String.format(Locale.US, "%.2f", amount);
    }

    /** Formats a money value with the currency label, e.g. Rs. 2500.00 */
    public static String formatMoney(BigDecimal amount) {
        return CURRENCY_LABEL + " " + formatAmount(amount);
    }

    // ---------- ABSTRACT METHODS (each subclass MUST implement these) ----------

    /** Which kind of account this is (uses the AccountType enum). */
    public abstract AccountType getAccountType();

    /** Minimum opening deposit; different for each account type. */
    public abstract BigDecimal getMinimumOpeningBalance();

    // ---------- FINAL METHOD ----------

    /**
     * final: the "amount must be greater than zero" rule is fixed for every
     * account type, so subclasses are not allowed to override (change) it.
     */
    public final boolean isValidAmount(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }

    // ---------- BANKING OPERATIONS ----------

    // METHOD OVERLOADING: deposit(amount) and deposit(amount, type, relatedAccount)
    // have the same name but different parameter lists.
    public void deposit(BigDecimal amount) {
        deposit(amount, TransactionType.DEPOSIT, NO_RELATED_ACCOUNT);
    }

    public void deposit(BigDecimal amount, TransactionType type, long relatedAccount) {
        if (!active) {
            throw new IllegalStateException("Account " + accountNumber + " is closed.");
        }
        if (!isValidAmount(amount)) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }
        BigDecimal exactAmount = amount.setScale(2, RoundingMode.HALF_UP);
        balance = balance.add(exactAmount);
        transactions.add(new Transaction(type, exactAmount, accountNumber, relatedAccount, balance));
    }

    public void withdraw(BigDecimal amount) {
        withdraw(amount, TransactionType.WITHDRAWAL, NO_RELATED_ACCOUNT);
    }

    public void withdraw(BigDecimal amount, TransactionType type, long relatedAccount) {
        if (!active) {
            throw new IllegalStateException("Account " + accountNumber + " is closed.");
        }
        if (!isValidAmount(amount)) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }
        BigDecimal exactAmount = amount.setScale(2, RoundingMode.HALF_UP);
        if (exactAmount.compareTo(balance) > 0) {
            throw new IllegalArgumentException("Insufficient balance.");
        }
        balance = balance.subtract(exactAmount);
        transactions.add(new Transaction(type, exactAmount, accountNumber, relatedAccount, balance));
    }

    /** Closes the account. Only allowed when it is open and the balance is zero. */
    public void close() {
        if (!active) {
            throw new IllegalStateException("Account " + accountNumber + " is already closed.");
        }
        if (balance.compareTo(BigDecimal.ZERO) != 0) {
            throw new IllegalStateException("Balance must be zero before closing.");
        }
        active = false;
    }

    // ---------- DISPLAY ----------

    /**
     * Builds the account details text. Subclasses OVERRIDE this method and call
     * super.getAccountSummary() to reuse this common part.
     */
    public String getAccountSummary() {
        StringBuilder text = new StringBuilder();
        text.append(String.format("Account Number  : %d%n", accountNumber));
        text.append(String.format("Account Type    : %s%n", getAccountType().getDisplayName()));
        text.append(String.format("Holder Name     : %s%n", holder.getName()));
        text.append(String.format("Age             : %d%n", holder.getAge()));
        text.append(String.format("Phone           : %s%n", holder.getMaskedPhoneNumber()));
        text.append(String.format("Address         : %s%n", holder.getAddress()));
        text.append(String.format("Balance         : %s%n", formatMoney(balance)));
        // Conditional (ternary) operator: picks one of two values.
        text.append(String.format("Status          : %s%n", active ? "ACTIVE" : "CLOSED"));
        text.append(String.format("Opened On       : %s%n", openedOn.format(DATE_TIME_FORMAT)));
        return text.toString();
    }

    // METHOD OVERLOADING: same name, different parameters.
    public void displayAccount() {
        displayAccount(false);
    }

    public void displayAccount(boolean showTransactionHistory) {
        // getAccountSummary() is resolved at run time (DYNAMIC BINDING).
        System.out.print(getAccountSummary());
        if (showTransactionHistory) {
            System.out.println();
            displayTransactionHistory();
        }
    }

    public void displayTransactionHistory() {
        System.out.println("Transaction History - Account " + accountNumber + " (" + holder.getName() + ")");
        System.out.println("------------------------------------------------------------------------------------");
        System.out.printf("%-5s %-20s %-16s %12s %-12s %14s%n",
                "ID", "Date/Time", "Type", "Amount", "Related A/C", "Balance After");
        System.out.println("------------------------------------------------------------------------------------");
        for (int i = 0; i < transactions.size(); i++) {
            Transaction t = transactions.get(i);
            String related = t.hasRelatedAccount() ? String.valueOf(t.getRelatedAccountNumber()) : "-";
            System.out.printf("%-5d %-20s %-16s %12s %-12s %14s%n",
                    t.getTransactionId(), t.getFormattedTimestamp(), t.getType().getDisplayName(),
                    formatAmount(t.getAmount()), related, formatAmount(t.getBalanceAfter()));
        }
        System.out.println("------------------------------------------------------------------------------------");
        System.out.println("Total transactions: " + transactions.size());
    }

    // ---------- GETTERS (no setters for accountNumber/balance: protects the data) ----------

    public long getAccountNumber() {
        return accountNumber;
    }

    public Person getHolder() {
        return holder;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public boolean isActive() {
        return active;
    }

    public List<Transaction> getTransactions() {
        return Collections.unmodifiableList(transactions);
    }

    // ---------- OBJECT CLASS METHODS ----------

    @Override
    public String toString() {
        return getAccountType().getDisplayName() + "[number=" + accountNumber
                + ", holder=" + holder.getName() + ", balance=" + formatMoney(balance)
                + ", status=" + (active ? "ACTIVE" : "CLOSED") + "]";
    }

    /** Two accounts are the same account when the account number is the same.
     *  The mutable balance is deliberately NOT used. */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof BankAccount)) {
            return false;
        }
        BankAccount other = (BankAccount) obj;
        return this.accountNumber == other.accountNumber;
    }

    @Override
    public int hashCode() {
        return Long.hashCode(accountNumber);
    }
}
```

---

**File: src/com/bank/model/CurrentAccount.java**

```java
package com.bank.model;

import java.math.BigDecimal;

/**
 * INHERITANCE: CurrentAccount IS-A BankAccount.
 */
public class CurrentAccount extends BankAccount {

    // Educational rule (not a real bank policy): configurable constant.
    public static final BigDecimal MIN_OPENING_BALANCE = new BigDecimal("1000.00");

    public CurrentAccount(long accountNumber, Person holder) {
        this(accountNumber, holder, MIN_OPENING_BALANCE);
    }

    public CurrentAccount(long accountNumber, Person holder, BigDecimal openingBalance) {
        super(accountNumber, holder, openingBalance);
    }

    @Override
    public AccountType getAccountType() {
        return AccountType.CURRENT;
    }

    @Override
    public BigDecimal getMinimumOpeningBalance() {
        return MIN_OPENING_BALANCE;
    }

    @Override
    public String getAccountSummary() {
        return super.getAccountSummary()
                + String.format("Account Rule    : Current - minimum opening deposit %s%n",
                        formatMoney(MIN_OPENING_BALANCE));
    }
}
```

---

**File: src/com/bank/model/Person.java**

```java
package com.bank.model;

/**
 * Person stores the personal details of a customer.
 *
 * RELATIONSHIP: a BankAccount HAS-A Person (composition), it does not
 * extend Person. An account is not a kind of person, so inheritance would be
 * illogical. Inheritance is used where it is natural:
 * BankAccount -> SavingsAccount / CurrentAccount.
 *
 * ENCAPSULATION: all fields are private; they are read and changed only
 * through public getters and setters.
 */
public class Person {

    // Instance variables: every Person object has its own copy.
    private String name;
    private int age;
    private String phoneNumber;
    private String address;

    // CONSTRUCTOR OVERLOADING (1): default constructor.
    // this(...) is CONSTRUCTOR CHAINING: it calls the parameterized constructor.
    public Person() {
        this("Unknown", 0, "0000000000", "Not provided");
    }

    // CONSTRUCTOR OVERLOADING (2): parameterized constructor.
    // 'this.name' is the instance variable, 'name' is the constructor parameter.
    public Person(String name, int age, String phoneNumber, String address) {
        this.name = name;
        this.age = age;
        this.phoneNumber = phoneNumber;
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    /** Shows only the last 4 digits so the full phone number is not printed unnecessarily. */
    public String getMaskedPhoneNumber() {
        if (phoneNumber.length() <= 4) {
            return phoneNumber;
        }
        return "******" + phoneNumber.substring(phoneNumber.length() - 4);
    }

    @Override
    public String toString() {
        return "Person[name=" + name + ", age=" + age + ", phone=" + getMaskedPhoneNumber() + "]";
    }
}
```

---

**File: src/com/bank/model/SavingsAccount.java**

```java
package com.bank.model;

import java.math.BigDecimal;

/**
 * INHERITANCE: SavingsAccount IS-A BankAccount.
 */
public class SavingsAccount extends BankAccount {

    // Educational rule (not a real bank policy): configurable constant.
    public static final BigDecimal MIN_OPENING_BALANCE = new BigDecimal("500.00");

    // CONSTRUCTOR OVERLOADING + CHAINING: this(...) uses the minimum opening balance.
    public SavingsAccount(long accountNumber, Person holder) {
        this(accountNumber, holder, MIN_OPENING_BALANCE);
    }

    public SavingsAccount(long accountNumber, Person holder, BigDecimal openingBalance) {
        // SUPER (constructor): calls the BankAccount constructor.
        super(accountNumber, holder, openingBalance);
    }

    // METHOD OVERRIDING: implements the abstract methods of BankAccount.
    @Override
    public AccountType getAccountType() {
        return AccountType.SAVINGS;
    }

    @Override
    public BigDecimal getMinimumOpeningBalance() {
        return MIN_OPENING_BALANCE;
    }

    // METHOD OVERRIDING + SUPER (method): reuse the parent text, then add our own line.
    @Override
    public String getAccountSummary() {
        return super.getAccountSummary()
                + String.format("Account Rule    : Savings - minimum opening deposit %s%n",
                        formatMoney(MIN_OPENING_BALANCE));
    }
}
```

---

**File: src/com/bank/model/Transaction.java**

```java
package com.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * One successful money movement on an account.
 * Objects are immutable (all fields final) so history cannot be altered later.
 */
public class Transaction {

    // STATIC VARIABLE: one copy shared by all Transaction objects.
    // It gives every transaction a unique, increasing id.
    private static int transactionCounter = 0;

    // Instance variables
    private final int transactionId;
    private final TransactionType type;
    private final BigDecimal amount;
    private final long accountNumber;
    private final long relatedAccountNumber;
    private final BigDecimal balanceAfter;
    private final LocalDateTime timestamp;

    // CONSTRUCTOR OVERLOADING (1): for deposits/withdrawals (no other account involved).
    // CONSTRUCTOR CHAINING: this(...) forwards to the longer constructor.
    public Transaction(TransactionType type, BigDecimal amount, long accountNumber,
                       BigDecimal balanceAfter) {
        this(type, amount, accountNumber, BankAccount.NO_RELATED_ACCOUNT, balanceAfter);
    }

    // CONSTRUCTOR OVERLOADING (2): for transfers (the other account is recorded).
    public Transaction(TransactionType type, BigDecimal amount, long accountNumber,
                       long relatedAccountNumber, BigDecimal balanceAfter) {
        transactionCounter++;
        this.transactionId = transactionCounter;
        this.type = type;
        this.amount = amount;
        this.accountNumber = accountNumber;
        this.relatedAccountNumber = relatedAccountNumber;
        this.balanceAfter = balanceAfter;
        this.timestamp = LocalDateTime.now();
    }

    public int getTransactionId() {
        return transactionId;
    }

    public TransactionType getType() {
        return type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public long getAccountNumber() {
        return accountNumber;
    }

    public long getRelatedAccountNumber() {
        return relatedAccountNumber;
    }

    public boolean hasRelatedAccount() {
        return relatedAccountNumber != BankAccount.NO_RELATED_ACCOUNT;
    }

    public BigDecimal getBalanceAfter() {
        return balanceAfter;
    }

    public String getFormattedTimestamp() {
        return timestamp.format(BankAccount.DATE_TIME_FORMAT);
    }

    @Override
    public String toString() {
        return "Transaction #" + transactionId + " [" + type.getDisplayName() + " "
                + BankAccount.formatMoney(amount) + " on " + getFormattedTimestamp() + "]";
    }
}
```

---

**File: src/com/bank/model/TransactionType.java**

```java
package com.bank.model;

/**
 * ENUM describing what kind of money movement a Transaction records.
 */
public enum TransactionType {
    OPENING_DEPOSIT("Opening Deposit"),
    DEPOSIT("Deposit"),
    WITHDRAWAL("Withdrawal"),
    TRANSFER_OUT("Transfer Out"),
    TRANSFER_IN("Transfer In");

    private final String displayName;

    TransactionType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
```

---

**File: src/com/bank/service/BankException.java**

```java
package com.bank.service;

/**
 * Custom checked exception for every business-rule failure
 * (invalid amount, insufficient balance, closed account, ...).
 * The menu catches it and prints getMessage() instead of crashing.
 */
public class BankException extends Exception {

    private static final long serialVersionUID = 1L;

    public BankException(String message) {
        super(message);
    }
}
```

---

**File: src/com/bank/service/BankService.java**

```java
package com.bank.service;

import com.bank.model.AccountType;
import com.bank.model.BankAccount;
import com.bank.model.CurrentAccount;
import com.bank.model.Person;
import com.bank.model.SavingsAccount;
import com.bank.model.TransactionType;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * All banking rules live here, separate from the console menu (Main).
 *
 * STORAGE: accounts are kept in memory in a LinkedHashMap with the account
 * number as key. Lookup is fast, a key cannot appear twice (no duplicate
 * account numbers) and accounts stay in the order they were created.
 * All data is lost when the program ends (there is no database or file).
 */
public class BankService implements TransactionOperations {

    // Final constants for fixed configuration values (educational rules).
    public static final int MIN_AGE = 18;
    public static final int MAX_AGE = 100;
    public static final int PHONE_LENGTH = 10;
    public static final int MIN_ADDRESS_LENGTH = 5;

    // Instance variable: the in-memory "database".
    private final Map<Long, BankAccount> accounts = new LinkedHashMap<>();

    // ------------------------------------------------------------------
    // Account creation
    // ------------------------------------------------------------------

    public BankAccount createAccount(String name, int age, String phone, String address,
                                     AccountType type, BigDecimal openingDeposit)
            throws BankException {

        // String method trim() removes leading/trailing spaces from user input.
        String cleanName = (name == null) ? "" : name.trim();
        String cleanPhone = (phone == null) ? "" : phone.trim();
        String cleanAddress = (address == null) ? "" : address.trim();

        if (cleanName.isEmpty()) {
            throw new BankException("Customer name must not be empty.");
        }
        if (cleanName.length() < 2 || !cleanName.matches("[A-Za-z ]+")) {
            throw new BankException("Name must have at least 2 characters and contain only letters and spaces.");
        }
        if (!isAgeValid(age)) {
            throw new BankException("Age must be between " + MIN_AGE + " and " + MAX_AGE + ".");
        }
        if (!isPhoneValid(cleanPhone)) {
            throw new BankException("Phone number must contain exactly " + PHONE_LENGTH + " digits.");
        }
        if (cleanAddress.length() < MIN_ADDRESS_LENGTH) {
            throw new BankException("Address must have at least " + MIN_ADDRESS_LENGTH + " characters.");
        }
        if (type == null) {
            throw new BankException("Account type must be selected.");
        }

        BigDecimal minimum = getMinimumOpeningBalance(type);
        if (openingDeposit == null || openingDeposit.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BankException("Opening deposit must be greater than zero.");
        }
        if (openingDeposit.compareTo(minimum) < 0) {
            throw new BankException("Opening deposit must be at least " + BankAccount.formatMoney(minimum)
                    + " for a " + type.getDisplayName() + ".");
        }

        // Generate an account number and make sure it is not already used.
        long number;
        do {
            number = BankAccount.generateAccountNumber();
        } while (accounts.containsKey(number));

        Person holder = new Person(toTitleCase(cleanName), age, cleanPhone, cleanAddress);

        // DYNAMIC BINDING: the reference type is the parent (BankAccount),
        // the object type is the child (SavingsAccount or CurrentAccount).
        BankAccount account;
        switch (type) {
            case SAVINGS:
                account = new SavingsAccount(number, holder, openingDeposit);
                break;
            case CURRENT:
                account = new CurrentAccount(number, holder, openingDeposit);
                break;
            default:
                throw new BankException("Unsupported account type.");
        }

        accounts.put(number, account);
        return account;
    }

    private BigDecimal getMinimumOpeningBalance(AccountType type) throws BankException {
        switch (type) {
            case SAVINGS:
                return SavingsAccount.MIN_OPENING_BALANCE;
            case CURRENT:
                return CurrentAccount.MIN_OPENING_BALANCE;
            default:
                throw new BankException("Unsupported account type.");
        }
    }

    /*
     * OPERATOR PRECEDENCE: relational operators (>=, <=) are evaluated BEFORE
     * the logical AND (&&), so this is read as
     *     (age >= MIN_AGE) && (age <= MAX_AGE)
     * and no extra brackets are needed.
     */
    private boolean isAgeValid(int age) {
        return age >= MIN_AGE && age <= MAX_AGE;
    }

    private boolean isPhoneValid(String phone) {
        if (phone.length() != PHONE_LENGTH) {
            return false;
        }
        boolean valid = true;
        for (int i = 0; i < phone.length(); i++) {
            if (!Character.isDigit(phone.charAt(i))) {
                valid = false;
                break;              // stop at the first non-digit character
            }
        }
        return valid;
    }

    /** Uses String.split() to turn "ravi  kumar" into "Ravi Kumar". */
    private String toTitleCase(String name) {
        String[] words = name.split("\\s+");
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < words.length; i++) {
            if (i > 0) {
                result.append(' ');
            }
            result.append(words[i].substring(0, 1).toUpperCase())
                  .append(words[i].substring(1).toLowerCase());
        }
        return result.toString();
    }

    // ------------------------------------------------------------------
    // Searching
    // ------------------------------------------------------------------

    public BankAccount findAccount(long accountNumber) throws BankException {
        BankAccount account = accounts.get(accountNumber);
        if (account == null) {
            throw new BankException("Account " + accountNumber + " does not exist.");
        }
        return account;
    }

    /** Case-insensitive search of the holder name using String.contains(). */
    public BankAccount[] searchByName(String keyword) throws BankException {
        String key = (keyword == null) ? "" : keyword.trim().toLowerCase();
        if (key.isEmpty()) {
            throw new BankException("Search text must not be empty.");
        }
        List<BankAccount> matches = new ArrayList<>();
        for (BankAccount account : accounts.values()) {
            if (account.getHolder().getName().toLowerCase().contains(key)) {
                matches.add(account);
            }
        }
        return matches.toArray(new BankAccount[0]);
    }

    /** Returns all accounts as an ARRAY OF OBJECTS (BankAccount[]). */
    public BankAccount[] getAllAccounts() {
        return accounts.values().toArray(new BankAccount[0]);
    }

    // ------------------------------------------------------------------
    // TransactionOperations (interface implementation)
    // Every check is done BEFORE any balance changes.
    // ------------------------------------------------------------------

    @Override
    public void deposit(long accountNumber, BigDecimal amount) throws BankException {
        BankAccount account = findAccount(accountNumber);
        requireActive(account);
        requireValidAmount(account, amount);
        account.deposit(amount);
    }

    @Override
    public void withdraw(long accountNumber, BigDecimal amount) throws BankException {
        BankAccount account = findAccount(accountNumber);
        requireActive(account);
        requireValidAmount(account, amount);
        requireSufficientFunds(account, amount);
        account.withdraw(amount);
    }

    @Override
    public void transfer(long fromAccountNumber, long toAccountNumber, BigDecimal amount)
            throws BankException {
        if (fromAccountNumber == toAccountNumber) {
            throw new BankException("Source and destination accounts must be different.");
        }
        BankAccount from = findAccount(fromAccountNumber);
        BankAccount to = findAccount(toAccountNumber);
        requireActive(from);
        requireActive(to);
        requireValidAmount(from, amount);
        requireSufficientFunds(from, amount);

        // Reaching this line means ALL validations passed, so both steps below
        // are safe. A failed transfer therefore never changes any balance.
        from.withdraw(amount, TransactionType.TRANSFER_OUT, toAccountNumber);
        to.deposit(amount, TransactionType.TRANSFER_IN, fromAccountNumber);
    }

    private void requireActive(BankAccount account) throws BankException {
        if (!account.isActive()) {
            throw new BankException("Account " + account.getAccountNumber()
                    + " is closed. No operations are allowed on a closed account.");
        }
    }

    private void requireValidAmount(BankAccount account, BigDecimal amount) throws BankException {
        // isValidAmount() is the FINAL method of BankAccount.
        if (!account.isValidAmount(amount)) {
            throw new BankException("Amount must be greater than zero.");
        }
        if (amount.stripTrailingZeros().scale() > 2) {
            throw new BankException("Amount can have at most two decimal places.");
        }
    }

    private void requireSufficientFunds(BankAccount account, BigDecimal amount) throws BankException {
        if (amount.compareTo(account.getBalance()) > 0) {
            throw new BankException("Insufficient balance. Available: "
                    + BankAccount.formatMoney(account.getBalance())
                    + ", requested: " + BankAccount.formatMoney(amount) + ".");
        }
    }

    // ------------------------------------------------------------------
    // Closing accounts
    // ------------------------------------------------------------------

    /** Checks that an account can be closed and returns it. Changes nothing. */
    public BankAccount validateCanClose(long accountNumber) throws BankException {
        BankAccount account = findAccount(accountNumber);
        if (!account.isActive()) {
            throw new BankException("Account " + accountNumber + " is already closed.");
        }
        if (account.getBalance().compareTo(BigDecimal.ZERO) != 0) {
            throw new BankException("Account cannot be closed while it has a balance of "
                    + BankAccount.formatMoney(account.getBalance())
                    + ". Withdraw or transfer the full balance first.");
        }
        return account;
    }

    public void closeAccount(long accountNumber) throws BankException {
        BankAccount account = validateCanClose(accountNumber);
        account.close();
    }

    // ------------------------------------------------------------------
    // Counts and report values
    // ------------------------------------------------------------------

    public int getStoredAccountCount() {
        return accounts.size();
    }

    public int getActiveAccountCount() {
        int count = 0;
        for (BankAccount account : accounts.values()) {
            if (!account.isActive()) {
                continue;           // skip closed accounts, go to the next one
            }
            count++;
        }
        return count;
    }

    public int getClosedAccountCount() {
        return getStoredAccountCount() - getActiveAccountCount();
    }

    /**
     * TYPE CONVERSION / CASTING: (double) converts an int to a double ONLY for
     * this percentage report. Without the cast, int / int would drop the
     * decimals (e.g. 1 / 2 = 0). No money value is ever cast, so financial
     * calculations stay exact (BigDecimal).
     *
     * OPERATOR PRECEDENCE: the cast binds tighter than / and *, and / and *
     * are evaluated left to right:  ((double) active / total) * 100
     */
    public double getActiveAccountPercentage() {
        int active = getActiveAccountCount();
        int total = getStoredAccountCount();
        return (total == 0) ? 0.0 : (double) active / total * 100;
    }
}
```

---

**File: src/com/bank/service/TransactionOperations.java**

```java
package com.bank.service;

import java.math.BigDecimal;

/**
 * INTERFACE: declares WHAT money operations exist, not HOW they work.
 * BankService implements it. Main uses it through an interface reference:
 *     TransactionOperations operations = bankService;
 */
public interface TransactionOperations {

    void deposit(long accountNumber, BigDecimal amount) throws BankException;

    void withdraw(long accountNumber, BigDecimal amount) throws BankException;

    void transfer(long fromAccountNumber, long toAccountNumber, BigDecimal amount)
            throws BankException;
}
```

---

**File: src/com/bank/app/Main.java**

```java
package com.bank.app;

import com.bank.model.AccountType;
import com.bank.model.BankAccount;
import com.bank.model.CurrentAccount;
import com.bank.model.SavingsAccount;
import com.bank.service.BankException;
import com.bank.service.BankService;
import com.bank.service.TransactionOperations;

import java.math.BigDecimal;
import java.util.Scanner;

/**
 * Console menu only. All banking rules are in BankService.
 * Educational project: it is NOT a real banking application.
 */
public class Main {

    // Static final constants (application configuration).
    private static final String APP_TITLE = "BANK ACCOUNT MANAGEMENT SYSTEM";
    private static final String LINE = "=========================================";

    // Static variables shared by all menu methods.
    private static final Scanner scanner = new Scanner(System.in);
    private static final BankService bankService = new BankService();
    // INTERFACE REFERENCE: money operations are used through the interface type.
    private static final TransactionOperations operations = bankService;
    private static boolean inputEnded = false;

    public static void main(String[] args) {
        boolean running = true;                 // local variable (exists only in main)

        while (running) {                       // menu repeats until Exit
            printMenu();
            int choice = readMenuChoice();
            if (inputEnded) {
                break;                          // no more input available: leave safely
            }
            try {
                switch (choice) {
                    case 1:
                        createAccount();
                        break;
                    case 2:
                        depositMoney();
                        break;
                    case 3:
                        withdrawMoney();
                        break;
                    case 4:
                        transferMoney();
                        break;
                    case 5:
                        checkBalance();
                        break;
                    case 6:
                        viewAccountDetails();
                        break;
                    case 7:
                        searchAccount();
                        break;
                    case 8:
                        displayAllAccounts();
                        break;
                    case 9:
                        viewTransactionHistory();
                        break;
                    case 10:
                        closeAccount();
                        break;
                    case 11:
                        viewTotalAccounts();
                        break;
                    case 0:
                        running = false;
                        break;
                    default:
                        System.out.println("FAILED: Invalid choice. Please enter a number from 0 to 11.");
                }
            } catch (BankException e) {
                // Every business-rule failure ends up here with a clear message.
                System.out.println("FAILED: " + e.getMessage());
            }
        }

        System.out.println();
        System.out.println("Thank you for using the " + APP_TITLE + ".");
        System.out.println("Note: all data was stored in memory only and is now discarded.");
        scanner.close();
    }

    // ------------------------------------------------------------------
    // Menu operations
    // ------------------------------------------------------------------

    private static void createAccount() throws BankException {
        System.out.println();
        System.out.println("--- Create New Account ---");
        String name = readLine("Enter customer name        : ");
        int age = readAge("Enter age                  : ");
        String phone = readLine("Enter phone number (10 digits): ");
        String address = readLine("Enter address              : ");
        AccountType type = readAccountType();
        BigDecimal deposit = readAmount("Enter opening deposit      : ");

        BankAccount account = bankService.createAccount(name, age, phone, address, type, deposit);

        System.out.println();
        System.out.println("SUCCESS: " + type.getDisplayName() + " created.");
        account.displayAccount();
    }

    private static void depositMoney() throws BankException {
        System.out.println();
        System.out.println("--- Deposit Money ---");
        long number = readAccountNumber("Enter account number : ");
        BigDecimal amount = readAmount("Enter amount to deposit: ");
        operations.deposit(number, amount);
        System.out.println("SUCCESS: " + BankAccount.formatMoney(amount) + " deposited. New balance: "
                + BankAccount.formatMoney(bankService.findAccount(number).getBalance()));
    }

    private static void withdrawMoney() throws BankException {
        System.out.println();
        System.out.println("--- Withdraw Money ---");
        long number = readAccountNumber("Enter account number : ");
        BigDecimal amount = readAmount("Enter amount to withdraw: ");
        operations.withdraw(number, amount);
        System.out.println("SUCCESS: " + BankAccount.formatMoney(amount) + " withdrawn. New balance: "
                + BankAccount.formatMoney(bankService.findAccount(number).getBalance()));
    }

    private static void transferMoney() throws BankException {
        System.out.println();
        System.out.println("--- Transfer Money ---");
        long from = readAccountNumber("Enter source account number      : ");
        long to = readAccountNumber("Enter destination account number : ");
        BigDecimal amount = readAmount("Enter amount to transfer          : ");
        operations.transfer(from, to, amount);
        System.out.println("SUCCESS: " + BankAccount.formatMoney(amount) + " transferred from account "
                + from + " to account " + to + ".");
        System.out.println("Source account balance is now "
                + BankAccount.formatMoney(bankService.findAccount(from).getBalance()) + ".");
    }

    private static void checkBalance() throws BankException {
        System.out.println();
        System.out.println("--- Check Account Balance ---");
        long number = readAccountNumber("Enter account number: ");
        BankAccount account = bankService.findAccount(number);
        System.out.println("Account Holder : " + account.getHolder().getName());
        System.out.println("Status         : " + (account.isActive() ? "ACTIVE" : "CLOSED"));
        System.out.println("Balance        : " + BankAccount.formatMoney(account.getBalance()));
    }

    private static void viewAccountDetails() throws BankException {
        System.out.println();
        System.out.println("--- View Account Details ---");
        long number = readAccountNumber("Enter account number: ");
        BankAccount account = bankService.findAccount(number);
        String answer = readLine("Include transaction history? (yes/no): ");
        System.out.println();
        // equalsIgnoreCase(): "YES", "yes" and "Yes" are all accepted.
        if (answer.equalsIgnoreCase("yes") || answer.equalsIgnoreCase("y")) {
            account.displayAccount(true);       // overloaded method with a parameter
        } else {
            account.displayAccount();           // overloaded method without parameters
        }
    }

    private static void searchAccount() throws BankException {
        System.out.println();
        System.out.println("--- Search Account ---");
        System.out.println("1. Search by account number");
        System.out.println("2. Search by customer name");
        String option = readLine("Enter option: ");
        if (option.equals("1")) {
            long number = readAccountNumber("Enter account number: ");
            System.out.println();
            System.out.println("SUCCESS: Account found.");
            bankService.findAccount(number).displayAccount();
        } else if (option.equals("2")) {
            String keyword = readLine("Enter part of the customer name: ");
            BankAccount[] matches = bankService.searchByName(keyword);
            if (matches.length == 0) {
                System.out.println("No account matches \"" + keyword + "\".");
            } else {
                System.out.println("SUCCESS: " + matches.length + " account(s) found.");
                printAccountTable(matches);
            }
        } else {
            System.out.println("FAILED: Invalid search option. Enter 1 or 2.");
        }
    }

    private static void displayAllAccounts() {
        System.out.println();
        System.out.println("--- All Accounts ---");
        // ARRAY OF OBJECTS: BankAccount[] holds Savings and Current accounts together.
        BankAccount[] allAccounts = bankService.getAllAccounts();
        if (allAccounts.length == 0) {
            System.out.println("No accounts have been created yet.");
            return;
        }
        printAccountTable(allAccounts);
    }

    private static void printAccountTable(BankAccount[] list) {
        String separator = "----------------------------------------------------------------------------------";
        System.out.println(separator);
        System.out.printf("%-4s %-12s %-22s %-16s %14s %-7s%n",
                "No.", "Account No.", "Holder", "Type", "Balance (Rs.)", "Status");
        System.out.println(separator);
        for (int i = 0; i < list.length; i++) {
            BankAccount account = list[i];
            System.out.printf("%-4d %-12d %-22s %-16s %14s %-7s%n",
                    i + 1, account.getAccountNumber(), account.getHolder().getName(),
                    account.getAccountType().getDisplayName(),
                    BankAccount.formatAmount(account.getBalance()),
                    account.isActive() ? "ACTIVE" : "CLOSED");
        }
        System.out.println(separator);
    }

    private static void viewTransactionHistory() throws BankException {
        System.out.println();
        System.out.println("--- Transaction History ---");
        long number = readAccountNumber("Enter account number: ");
        System.out.println();
        bankService.findAccount(number).displayTransactionHistory();
    }

    private static void closeAccount() throws BankException {
        System.out.println();
        System.out.println("--- Close Account ---");
        long number = readAccountNumber("Enter account number: ");
        BankAccount account = bankService.validateCanClose(number);   // checks first
        // Prints the account using its overridden toString() method.
        System.out.println("Account to close: " + account);
        String confirmation = readLine("Type CLOSE (capital letters) to close account "
                + account.getAccountNumber() + ": ");
        // equals() is case-sensitive, so only the exact word CLOSE is accepted.
        if (!confirmation.equals("CLOSE")) {
            System.out.println("Account closing cancelled. The account is still active.");
            return;
        }
        bankService.closeAccount(number);
        System.out.println("SUCCESS: Account " + number + " has been closed.");
    }

    private static void viewTotalAccounts() {
        System.out.println();
        System.out.println("--- Account Statistics ---");
        // Static method: called with the class name, not an object.
        System.out.println("Total accounts created : " + BankAccount.getTotalAccountsCreated());
        System.out.println("Accounts stored        : " + bankService.getStoredAccountCount());
        System.out.println("Active accounts        : " + bankService.getActiveAccountCount());
        System.out.println("Closed accounts        : " + bankService.getClosedAccountCount());
        System.out.printf("Active percentage      : %.1f%%%n", bankService.getActiveAccountPercentage());
    }

    // ------------------------------------------------------------------
    // Console input helpers (never crash on bad input)
    // ------------------------------------------------------------------

    private static void printMenu() {
        System.out.println();
        System.out.println(LINE);
        System.out.println("     " + APP_TITLE);
        System.out.println(LINE);
        System.out.println();
        System.out.println("1. Create New Account");
        System.out.println("2. Deposit Money");
        System.out.println("3. Withdraw Money");
        System.out.println("4. Transfer Money");
        System.out.println("5. Check Account Balance");
        System.out.println("6. View Account Details");
        System.out.println("7. Search Account");
        System.out.println("8. Display All Accounts");
        System.out.println("9. View Transaction History");
        System.out.println("10. Close Account");
        System.out.println("11. View Total Accounts");
        System.out.println("0. Exit");
        System.out.println();
    }

    /** Reads one line, trims it, and handles the end of input safely. */
    private static String readLine(String prompt) {
        System.out.print(prompt);
        if (!scanner.hasNextLine()) {
            inputEnded = true;
            return "";
        }
        return scanner.nextLine().trim();
    }

    /** Returns the menu number, or -1 when the text is not a number. */
    private static int readMenuChoice() {
        String text = readLine("Enter your choice: ");
        try {
            return Integer.parseInt(text);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static int readAge(String prompt) throws BankException {
        String text = readLine(prompt);
        if (!text.matches("\\d{1,3}")) {
            throw new BankException("Age must be a whole number (digits only).");
        }
        return Integer.parseInt(text);
    }

    private static long readAccountNumber(String prompt) throws BankException {
        String text = readLine(prompt);
        if (!text.matches("\\d{1,18}")) {
            throw new BankException("Invalid account number. Enter digits only (for example 1000000001).");
        }
        return Long.parseLong(text);
    }

    /** Reads money as BigDecimal. A leading minus is accepted here so that the
     *  service can reject negative amounts with a clear message. */
    private static BigDecimal readAmount(String prompt) throws BankException {
        String text = readLine(prompt);
        if (!text.matches("-?\\d{1,12}(\\.\\d{1,2})?")) {
            throw new BankException("Invalid amount. Enter a number such as 1500 or 1500.50 (maximum two decimal places).");
        }
        return new BigDecimal(text).setScale(2);
    }

    private static AccountType readAccountType() throws BankException {
        System.out.println("Select account type:");
        System.out.println("  1. Savings Account (minimum opening deposit "
                + BankAccount.formatMoney(SavingsAccount.MIN_OPENING_BALANCE) + ")");
        System.out.println("  2. Current Account (minimum opening deposit "
                + BankAccount.formatMoney(CurrentAccount.MIN_OPENING_BALANCE) + ")");
        String choice = readLine("Enter type (1 or 2)      : ");
        switch (choice) {
            case "1":
                return AccountType.SAVINGS;
            case "2":
                return AccountType.CURRENT;
            default:
                throw new BankException("Invalid account type. Enter 1 or 2.");
        }
    }
}
```
