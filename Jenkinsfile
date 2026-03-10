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