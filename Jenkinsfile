pipeline {
    agent any

    tools {
        maven 'Maven 3.9.11'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/goudacse/JMeter-Exercises.git'
            }
        }

        stage('Run JMeter Tests Separately') {
            steps {
                script {
                    def tests = [
                        "PetStore-End-to-End-Flow.jmx",
                        "PetStore-Test-Plan-Add-All-Products.jmx",
                        "PetStore_AddNewPET.jmx",
                        "PetStore_AddNewUser.jmx"
                    ]

                    tests.each { testFile ->
                        def testName = testFile.replaceAll("\\.jmx", "").replaceAll(" ", "_")
                        def resultsDir = "target/jmeter/report/${testName}"

                        echo "▶ Running test: ${testFile}"
                        
                        // Run Maven for each test file
                        bat """
                          mvn verify -Djmeter.testFiles="Test Plans/${testFile}" -Djmeter.resultsDirectory=${resultsDir}
                        """

                        // Archive results (CSV, JTL, HTML, etc.)
                        archiveArtifacts artifacts: "${resultsDir}/**/*", allowEmptyArchive: true

                        // Publish HTML report for this test
                        publishHTML([
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: resultsDir,
                            reportFiles: 'index.html',
                            reportName: "JMeter Report - ${testName}"
                        ])
                    }
                }
            }
        }
    }
}
