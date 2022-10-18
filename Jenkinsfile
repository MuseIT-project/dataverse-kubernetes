@Library(['github.com/indigo-dc/jenkins-pipeline-library@2.1.1']) _

def projectConfig

pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
        stage('SQA baseline dynamic stages') {
            steps {
                script {
                    projectConfig = pipelineConfig()
                    buildStages(projectConfig)
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Preparing Dataverse for integration tests') {
            agent any
            steps {
                echo "Preparing fully containerized environment - :)"
                dir ('./docker/dataverse-k8s/payara') {
                    sh 'docker-compose -f ./docker/dataverse-k8s/payara/docker-compose.yml up -d'
                }
            }
        }
        }
}
