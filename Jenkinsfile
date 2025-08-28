pipeline {
    agent any

    tools {
        maven 'Maven 3.9.11'
        jdk 'jdk-17'
        ant 'Ant-1.10'
    }

    environment {
        PATH = "$PATH:${tool 'Maven 3.9.11'}/bin:${tool 'Ant-1.10'}/bin"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/goudacse/JMeter-Exercises1.git'
            }
        }

        stage('Maven Run (Sequential)') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('Ant Run (Parallel)') {
            steps {
                sh 'ant run'
            }
        }

        stage('Merge Results') {
            steps {
                sh '''
                mkdir -p results/merged
                cat results/*.jtl > results/merged/merged.jtl
                ant report
                '''
            }
        }

        stage('Publish Report') {
            steps {
                publishHTML([
                    reportDir: 'results/combined-report',
                    reportFiles: 'index.html',
                    reportName: 'JMeter Combined Report'
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**/*.jtl', allowEmptyArchive: true
            cleanWs()
        }
    }
}
