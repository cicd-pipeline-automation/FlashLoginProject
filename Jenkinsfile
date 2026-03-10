pipeline {
    agent any

    environment {
        // ============================
        // Environment Setup
        // ----------------------------
        // Folder where compiled builds will be stored
        BUILD_OUTPUT = "bin"

        // Pattern to identify artifacts for archiving
        ARTIFACT_PATTERN = "bin/*.app"
    }

    stages {

        // ============================
        // Stage 1: Checkout Source Code
        // ----------------------------
        // Fetch the latest code from the 'main' branch of the Git repository
        stage('Checkout Source') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/cicd-pipeline-automation/FlashLoginProject.git'
            }
        }

        // ============================
        // Stage 2: Verify Jenkins Environment
        // ----------------------------
        // Ensure the agent has correct files and directory structure
        stage('Verify Environment') {
            steps {
                powershell 'Get-ChildItem'
            }
        }

        // ============================
        // Stage 3: Build PLC Project
        // ----------------------------
        // Execute the Solution Center CLI script to compile the PLC project
        stage('Build PLC Project') {
            steps {
                powershell './build/build.ps1'
            }
        }

        // ============================
        // Stage 4: Verify Build Output
        // ----------------------------
        // Check that the compiled artifacts are present in the /bin folder
        stage('Verify Build Output') {
            steps {
                powershell 'Get-ChildItem bin'
            }
        }

        // ============================
        // Stage 5: Archive Artifact
        // ----------------------------
        // Store the compiled artifact in Jenkins for future reference
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'bin/*.app', fingerprint: true
            }
        }

        // ============================
        // Stage 6: Send Build Email
        // ----------------------------
        // Notify developers with the build results and attach the artifact
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
                    to: "devopsuser8413@gmail.com",
                    attachmentsPattern: "bin/*.app"
                )
            }
        }

    }

    post {
        // ============================
        // Post-build Actions
        // ----------------------------
        
        // On Success: Display a success message
        success {
            echo "Build Completed Successfully"
        }

        // On Failure: Send failure notification
        failure {
            emailext(
                subject: "FlashLogin Build FAILED",
                body: "Build failed. Check Jenkins logs for details.",
                to: "devopsuser8413@gmail.com"
            )
        }
    }
}