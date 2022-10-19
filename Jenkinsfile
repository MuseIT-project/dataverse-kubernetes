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
                    sh 'cd FAIR_eva;docker build -t fair_eva .'
                    sh 'docker run --name=fair_eva -d -p 9090:9090 -p 5000:5000 fair_eva;cd ..'
                    sh 'docker stop dataverse'
                    sh 'docker-compose -f docker-compose.yaml up -d'
                    sh 'sleep 300s'
                    sh 'docker logs dataverse'
                    sh 'docker exec dataverse bash /secrets/db_sample.sh'
                    sh 'export PGPASSWORD=`cat ./personas/docker-compose/secrets/db/password`'
                    sh 'echo $PGPASSWORD'
                    sh 'curl http://0.0.0.0:9090/v1.0/rda/rda_all'
                    sh 'curl http://0.0.0.0:8080'
                    sh 'sh ./test/test_upload.sh'
                    sh 'docker exec dataverse curl http://localhost:8080/api/admin/metadata/exportAll'
                    sh 'docker exec dataverse curl http://localhost:8080/api/admin/metadata/reExportAll'
                    sh 'sleep 10s'
                    sh 'curl "http://0.0.0.0:8080/api/datasets/export?exporter=dataverse_json&persistentId=doi:10.34622/datarepositorium/SGXCQO"'
                    sh 'curl "http://0.0.0.0:8080/api/datasets/export?exporter=dcterms&persistentId=doi:10.34622/datarepositorium/SGXCQO"'
                    sh 'curl "http://0.0.0.0:8080/oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=doi:10.34622/datarepositorium/SGXCQO"'
                    sh "curl --location --request POST 'http://0.0.0.0:9090/v1.0/rda/rda_all' --header 'Content-Type: application/json' --header 'Cookie: Cookie_1=foobar' --data-raw '{ 'id': 'https://doi.org/10.34622/datarepositorium/SGXCQO', 'repo': 'oai-pmh', 'oai_base': 'http://0.0.0.0:8080/oai', 'lang': 'en' }"
                }
            }
        }

        }
}
