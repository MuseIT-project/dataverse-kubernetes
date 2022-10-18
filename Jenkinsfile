pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
        stage('Trigger Dataverse CICD job') {
            when {
                anyOf {
                    branch '5.12'
                }
            }
            steps {
                sh "docker build -t dataverse:latest -f docker/dataverse-k8s/payara/Dockerfile ."
                }
            }
        }
}
