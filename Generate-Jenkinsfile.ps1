$jenkinsfileContent = @"
pipeline {
    agent any

    environment {
        BUILD_FILE = "bin/FlashLogin.app"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/example/FlashLoginProject.git'
            }
        }

        stage('Build Project') {
            steps {
                bat 'SolutionCenterCLI build FlashLoginProject.project'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'bin/*.app', fingerprint: true
            }
        }

        stage('Email Artifact') {
            steps {
                emailext (
                    subject: "FlashLogin Build Artifact",
                    body: "Attached is the compiled file from bin folder.",
                    to: "devteam@example.com",
                    attachmentsPattern: "bin/*.app"
                )
            }
        }

    }
}
"@

$path = "Jenkinsfile"

Set-Content -Path $path -Value $jenkinsfileContent

Write-Host "Jenkinsfile generated successfully at $path"