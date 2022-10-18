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

        stage('Preparing Dataverse for integration tests') {
            agent any
            steps {
                echo "Preparing fully containerized environment - :)"
                dir ('./docker/dataverse-k8s/payara') {
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }
        }
}
