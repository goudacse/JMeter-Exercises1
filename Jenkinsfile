pipeline {
    agent any

    tools {
        ant 'Ant 1.10'   // Install Ant in Jenkins Global Tools
    }

    stages {
        stage('Checkout') {
            steps {
                // Explicitly use main branch
                git branch: 'main', 
                    url: 'https://github.com/goudacse/JMeter-Exercises1.git'
            }
        }

        stage('Run JMeter Parallel Tests') {
            steps {
                // Run Ant build.xml target to execute all JMX files in parallel
                bat 'ant -f build.xml combine-results'
            }
        }

        stage('Publish HTML Report') {
            steps {
                // Correct parameters for publishHTML plugin
                publishHTML([
                    reportDir: 'build/jmeter-html-report',
                    reportFiles: 'index.html',
                    reportName: 'JMeter Parallel Test Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true,
                    allowMissing: true
                ])
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
