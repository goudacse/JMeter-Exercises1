pipeline {
    agent any

    tools {
        ant 'Ant 1.10'   // Install Ant in Jenkins Global Tools
        jdk 'Java 11'   // JMeter needs Java
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/goudacse/JMeter-Exercises1.git'
            }
        }

        stage('Run JMeter Parallel Tests') {
            steps {
                sh "ant -f build.xml report"
            }
        }

        stage('Publish HTML Report') {
            steps {
                publishHTML([
                    reportDir: 'build/jmeter-html-report',
                    reportFiles: 'index.html',
                    reportName: 'JMeter Parallel Test Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true,
                    allowMissing: false
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
