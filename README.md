
---

# 1. Complete Project Structure

Example repository:

```
FlashLoginProject/
│
├── Jenkinsfile
│
├── build/
│   └── build.ps1
│
├── project/
│   ├── FlashLogin.project
│   └── config.xml
│
├── src/
│   ├── FlashLogin.st
│   └── LoginTypes.st
│
├── test/
│   └── LoginTestCases.md
│
├── bin/
│   └── (Generated build artifacts)
│
└── README.md
```

Explanation:

| Folder      | Purpose                       |
| ----------- | ----------------------------- |
| src         | Structured Text source code   |
| project     | Solution Center project files |
| build       | build automation scripts      |
| bin         | compiled output               |
| Jenkinsfile | CI/CD pipeline                |
| test        | test documentation            |

---

# 2. Structured Text Login Program

File:

```
src/FlashLogin.st
```

```pascal
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
```

---

# 3. Supporting Type File

```
src/LoginTypes.st
```

```pascal
TYPE LoginStatus :
(
    IDLE,
    AUTHENTICATED,
    FAILED
);
END_TYPE
```

---

# 4. Build Script (Production Automation)

File:

```
build/build.ps1
```

PowerShell script to compile project.

```powershell
Write-Host "Starting Solution Center build..."

$projectPath = "..\project\FlashLogin.project"
$outputFolder = "..\bin"

if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}

$solutionCenterCLI = "C:\Program Files\SolutionCenter\bin\SolutionCenterCLI.exe"

& "$solutionCenterCLI" build $projectPath --output $outputFolder

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build Failed"
    exit 1
}

Write-Host "Build Completed Successfully"
```

---

# 5. Jenkins Pipeline (Production Ready)

File:

```
Jenkinsfile
```

```groovy
pipeline {

    agent any

    environment {
        BUILD_OUTPUT = "bin"
        ARTIFACT_PATTERN = "bin/*.app"
    }

    stages {

        stage('Checkout Source') {

            steps {
                git branch: 'main',
                url: 'https://github.com/company/FlashLoginProject.git'
            }

        }

        stage('Verify Environment') {

            steps {
                powershell 'Get-ChildItem'
            }

        }

        stage('Build PLC Project') {

            steps {
                powershell './build/build.ps1'
            }

        }

        stage('Verify Build Output') {

            steps {
                powershell 'Get-ChildItem bin'
            }

        }

        stage('Archive Artifact') {

            steps {
                archiveArtifacts artifacts: 'bin/*.app', fingerprint: true
            }

        }

        stage('Send Build Email') {

            steps {

                emailext(
                    subject: "FlashLogin PLC Build Success - ${BUILD_NUMBER}",
                    body: """
                    Build Completed Successfully.

                    Job Name: ${JOB_NAME}
                    Build Number: ${BUILD_NUMBER}

                    The compiled artifact from the bin folder is attached.

                    """,
                    to: "plc-dev-team@company.com",
                    attachmentsPattern: "bin/*.app"
                )

            }

        }

    }

    post {

        success {
            echo "Build Completed Successfully"
        }

        failure {

            emailext(
                subject: "FlashLogin Build FAILED",
                body: "Build failed. Check Jenkins logs.",
                to: "plc-dev-team@company.com"
            )

        }

    }

}
```

---

# 6. Jenkins Plugin Requirements

Install these plugins:

| Plugin                 | Purpose             |
| ---------------------- | ------------------- |
| Pipeline               | pipeline execution  |
| Git                    | repository checkout |
| Email Extension Plugin | send build emails   |
| Pipeline Utility Steps | artifact utilities  |

---

# 7. Jenkins Email Configuration

Go to:

```
Manage Jenkins
→ Configure System
→ Extended Email Notification
```

Example SMTP:

```
SMTP Server: smtp.company.com
Port: 587
Use TLS: true

Username: jenkins@company.com
Password: ********
```

Default email:

```
jenkins@company.com
```

---

# 8. Create Jenkins Job

Steps:

```
Jenkins Dashboard
→ New Item
→ Pipeline
```

Name:

```
FlashLogin-CICD
```

Pipeline Source:

```
Pipeline script from SCM
```

SCM:

```
Git
```

Repository:

```
https://github.com/company/FlashLoginProject.git
```

Branch:

```
main
```

Script path:

```
Jenkinsfile
```

Save.

---

# 9. Execution Flow

When pipeline runs:

```
Developer commits code
      │
      ▼
Git repository updated
      │
      ▼
Jenkins pipeline triggered
      │
      ▼
Checkout repository
      │
      ▼
Run build.ps1
      │
      ▼
Solution Center compiles project
      │
      ▼
bin/FlashLogin.app generated
      │
      ▼
Artifact archived
      │
      ▼
Email sent with attachment
```

---

# 10. Expected Build Output

```
bin/
 └── FlashLogin.app
```

Example email attachment:

```
FlashLogin.app
```

---

# 11. Example Jenkins Console Output

```
[Pipeline] Checkout Source
Cloning repository...

[Pipeline] Build PLC Project
Starting Solution Center build...
Build Completed Successfully

[Pipeline] Verify Build Output
FlashLogin.app

[Pipeline] Archive Artifact
Archiving artifacts

[Pipeline] Send Build Email
Email sent successfully
```

---

# 12. Production CI/CD Best Practices

Recommended improvements:

✔ Add **Git webhook triggers**
✔ Add **version tagging**
✔ Upload artifacts to **Artifactory / Nexus**
✔ Add **unit tests for PLC logic**
✔ Add **multi-branch pipeline**

---
