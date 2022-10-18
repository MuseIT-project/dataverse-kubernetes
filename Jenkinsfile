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
                    sh 'docker-compose -f docker-compose.yaml up -d'
                    sh 'sleep 60s'
                    sh 'docker exec dataverse bash /secrets/db_sample.sh'
                    sh 'export PGPASSWORD=`cat ./personas/docker-compose/secrets/db/password`'
                    sh 'echo $PGPASSWORD'
                    sh 'curl http://0.0.0.0:8080'
                    sh 'sh ./test/test_upload.sh'
                    sh 'docker exec dataversecurl http://localhost:8080/api/admin/metadata/exportAll'
                    sh 'docker exec dataverse curl http://localhost:8080/api/admin/metadata/reExportAll'
                    sh 'sleep 10s'
                    sh 'curl "http://0.0.0.0:8080/oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=doi:10.34622/datarepositorium/SGXCQO"'
                }
            }
        }

        stage('Checking Dataverse availability') {
            agent any
            steps {
                echo "Checking Dataverse environment - :)"
                dir ('./') {
                    sh 'docker ps'
                    sh 'sleep 60s;curl http://dataverse:8080'
                }
            }
        }
        }
}
