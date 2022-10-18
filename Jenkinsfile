@Library(['github.com/indigo-dc/jenkins-pipeline-library@2.1.1']) _

def projectConfig

pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
        stage('SQA : plain code checks') {
            steps {
                catchError {
                    script {
                        projectConfigPlain = pipelineConfig(
                            configFile: '.sqa/config.yml')
                        buildStages(projectConfigPlain)
                    }
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
