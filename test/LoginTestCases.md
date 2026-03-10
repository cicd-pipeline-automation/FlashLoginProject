# FlashLogin PLC Project – Test Cases

**Project:** FlashLoginProject  
**Module:** FlashLogin.st  
**Author:** PLC Developer  
**Date:** 2026-03-10  
**Version:** 1.0.0  

---

## 1. Test Objective

Verify the behavior of the **FlashLogin program** to ensure correct authentication logic:

- Correct credentials grant access
- Incorrect credentials deny access
- Login attempt flag resets after processing
- Login failure and success flags behave as expected
- Limits on maximum login attempts (if implemented)

---

## 2. Test Environment

| Parameter            | Value/Description |
|----------------------|-----------------|
| PLC Target           | FlashPLCControllerV1 |
| Language             | Structured Text (IEC-61131-3) |
| Compiler Options     | Optimization: High, Warnings as Errors |
| Output               | FlashLogin.app |

---

## 3. Test Cases

| Test Case ID | Description | Input | Expected Output | Remarks |
|--------------|-------------|-------|----------------|---------|
| TC-001 | Successful login with correct credentials | inputUser = "admin"<br>inputPassword = "flash123"<br>loginAttempt = TRUE | loginSuccess = TRUE<br>loginFailure = FALSE<br>loginAttempt = FALSE | Basic positive test |
| TC-002 | Failed login with incorrect username | inputUser = "user"<br>inputPassword = "flash123"<br>loginAttempt = TRUE | loginSuccess = FALSE<br>loginFailure = TRUE<br>loginAttempt = FALSE | Should deny access |
| TC-003 | Failed login with incorrect password | inputUser = "admin"<br>inputPassword = "wrong"<br>loginAttempt = TRUE | loginSuccess = FALSE<br>loginFailure = TRUE<br>loginAttempt = FALSE | Password mismatch |
| TC-004 | Login attempt not triggered | inputUser = "admin"<br>inputPassword = "flash123"<br>loginAttempt = FALSE | loginSuccess = FALSE<br>loginFailure = FALSE | No change in flags |
| TC-005 | Multiple failed attempts | inputUser = "user"<br>inputPassword = "wrong"<br>loginAttempt = TRUE (repeat 3 times) | loginSuccess = FALSE<br>loginFailure = TRUE<br>loginAttempt = FALSE | Optional: enforce MaxAttempts from config.xml |
| TC-006 | Correct login after failed attempts | inputUser = "admin"<br>inputPassword = "flash123"<br>loginAttempt = TRUE | loginSuccess = TRUE<br>loginFailure = FALSE<br>loginAttempt = FALSE | Resets failure flag after success |

---

## 4. Test Execution Steps

1. Set `inputUser` and `inputPassword` values in PLC memory.  
2. Set `loginAttempt = TRUE`.  
3. Allow one PLC scan cycle to execute the program.  
4. Check output flags `loginSuccess` and `loginFailure`.  
5. Reset `loginAttempt = FALSE`.  
6. Record test results in test log.

---

## 5. Acceptance Criteria

- `loginSuccess` must be TRUE only if both username and password match stored values.  
- `loginFailure` must be TRUE only if login attempt fails.  
- `loginAttempt` flag must reset automatically after each check.  
- Program must handle repeated failed attempts correctly.  

---

## 6. Notes

- This test document assumes **FlashLogin.program logic** matches the code in `FlashLogin.st`.  
- For automated testing, consider **simulating login sequences via PLC test scripts**.  
- Future enhancements may include **timeout handling**, **lockout logic**, or **audit logging**.
