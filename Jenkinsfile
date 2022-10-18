pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
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
