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
                dir ('./') {
                    sh 'docker-compose -f ./docker-compose.yaml up -d'
                    sh 'docker ps'
                    sh 'sleep 80s;curl http://dataverse:8080'
                }
            }
        }

        stage('Checking Dataverse availability') {
            agent any
            steps {
                echo "Checking Dataverse environment - :)"
                dir ('./') {
                    sh 'docker ps'
                    sh 'sleep 80s;curl dataverse:8080'
                }
            }
        }
        }
}
