pipeline {
    agent any

    environment {
        JMETER_HOME = 'D:\\JMeter\\apache-jmeter-5.6.3' // Update your JMeter path
        TEST_DIR = 'jmeter-tests'
        REPORT_DIR = 'jmeter-report'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Run JMeter Tests in Parallel') {
            steps {
                bat 'ant -f build.xml run-all'
                // Wait for all tests to finish (optional: adjust based on test duration)
                bat 'timeout /t 10 > nul'
            }
        }

        stage('Generate Individual HTML Reports') {
            steps {
                bat """
                for %%f in (%REPORT_DIR%\\*.jtl) do (
                    if not exist %REPORT_DIR%\\html\\%%~nf mkdir %REPORT_DIR%\\html\\%%~nf
                    %JMETER_HOME%\\bin\\jmeter.bat -g %%f -o %REPORT_DIR%\\html\\%%~nf
                )
                """
            }
        }

        stage('Generate Combined HTML Report') {
            steps {
                bat """
                copy /b %REPORT_DIR%\\*.jtl %REPORT_DIR%\\combined.jtl
                if not exist %REPORT_DIR%\\html\\combined mkdir %REPORT_DIR%\\html\\combined
                %JMETER_HOME%\\bin\\jmeter.bat -g %REPORT_DIR%\\combined.jtl -o %REPORT_DIR%\\html\\combined
                """
            }
        }

        stage('Publish HTML Reports') {
            steps {
                // Publish combined report
                publishHTML(target: [
                    reportDir: '%REPORT_DIR%/html/combined',
                    reportFiles: 'index.html',
                    reportName: 'Combined JMeter Report'
                ])

                // Publish individual reports
                script {
                    def htmlFolders = findFiles(glob: "${env.REPORT_DIR}/html/*/index.html")
                    for (file in htmlFolders) {
                        def reportName = file.path.split("/").last().replace("index.html","").replace("\\","")
                        publishHTML(target: [
                            reportDir: file.path.replace("index.html",""),
                            reportFiles: 'index.html',
                            reportName: "JMeter Report - ${reportName}"
                        ])
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
