PROGRAM FlashLogin

VAR
    inputUser : STRING[32];
    inputPassword : STRING[32];

    storedUser : STRING[32] := 'admin';
    storedPassword : STRING[32] := 'flash123';

    loginAttempt : BOOL := FALSE;
    loginSuccess : BOOL := FALSE;
    loginFailure : BOOL := FALSE;

END_VAR


IF loginAttempt THEN

    IF (inputUser = storedUser) AND (inputPassword = storedPassword) THEN
        loginSuccess := TRUE;
        loginFailure := FALSE;
    ELSE
        loginSuccess := FALSE;
        loginFailure := TRUE;
    END_IF;

    loginAttempt := FALSE;

END_IF;

END_PROGRAM