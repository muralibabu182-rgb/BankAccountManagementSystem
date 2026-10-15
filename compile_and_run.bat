@echo off
REM Compiles all Java files into the "out" folder and starts the program.
if not exist out mkdir out
javac -d out src\com\bank\model\*.java src\com\bank\service\*.java src\com\bank\app\*.java
if errorlevel 1 (
    echo.
    echo Compilation failed. Read the error messages above.
    pause
    exit /b 1
)
java -cp out com.bank.app.Main
pause
