pipeline {
    agent any

    tools {
        maven 'Maven 3.9.11'
    }

    options {
        // Keep only last 5 builds (logs + artifacts + reports)
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/goudacse/JMeter-Exercises.git'
            }
        }

        stage('Run JMeter via Maven') {
            steps {
                bat "mvn clean verify"
            }
        }

        stage('Archive Results') {
            steps {
                // Archive all JMeter results + HTML dashboards
                archiveArtifacts artifacts: 'target/jmeter/results/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'target/jmeter/results/**/*', allowEmptyArchive: true
            }
        }

        stage('Publish JMeter HTML Report') {
            steps {
                script {
                    // Directly point to results folder (latest run only)
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'target/jmeter/results',
                        reportFiles: '*.html',
                        reportName: 'JMeter HTML Report'
                    ])
                }
            }
        }
    }

    //post {
        //always {
            //cleanWs()
        //}
    //}
}
