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

        stage('Preparing Dataverse for basic integration tests and FAIR assessment') {
            agent any
            steps {
                echo "Preparing fully containerized environment - :)"
                dir ('./') {
                    sh 'rm -rf FAIR_eva;git clone https://github.com/EOSC-synergy/FAIR_eva'
                    sh 'cd FAIR_eva;docker build -t fair_eva .'
                    sh 'docker run --name=fair_eva -d -p 9090:9090 -p 5000:5000 --network default fair_eva;cd ..'
                    sh 'export FAIR_EVA=`docker exec fair_eva cat  /etc/hosts|tail -1| awk \'{print $1;}\'`;echo $FAIR_EVA > /tmp/faireva.host'
                    sh 'docker-compose -f docker-compose.yaml up -d'
                    sh 'cat /tmp/faireva.host'
                    sh 'sleep 300s'
                    sh 'export DATAVERSE_HOST=`docker exec dataverse cat /etc/hosts|tail -1| awk \'{print $1;}\'`;echo $DATAVERSE_HOST > /tmp/dataverse.host'
                    sh 'docker logs dataverse'
                    sh 'docker exec dataverse bash /secrets/db_sample.sh'
                    sh 'curl http://0.0.0.0:9090/v1.0/rda/rda_all'
                    sh 'sh ./test/test_upload.sh'
                    sh 'docker exec dataverse curl http://localhost:8080/api/admin/metadata/exportAll'
                    sh 'docker exec dataverse curl http://localhost:8080/api/admin/metadata/reExportAll'
                    sh 'curl "http://0.0.0.0:8080/api/datasets/export?exporter=dataverse_json&persistentId=doi:10.34622/datarepositorium/SGXCQO"'
                    sh 'curl "http://0.0.0.0:8080/api/datasets/export?exporter=dcterms&persistentId=doi:10.34622/datarepositorium/SGXCQO"'
                    sh 'curl "http://0.0.0.0:8080/oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=doi:10.34622/datarepositorium/SGXCQO"'
                    sh "export DATAVERSE_HOST=`cat /tmp/dataverse.host`;curl --location --request POST 'http://0.0.0.0:9090/v1.0/rda/rda_all' --header 'Content-Type: application/json' --header 'Cookie: Cookie_1=foobar' --data-raw '{ \"id\": \"https://doi.org/10.34622/datarepositorium/SGXCQO\", \"repo\": \"oai-pmh\", \"oai_base\": \"http://$DATAVERSE_HOST:8080/oai\", \"lang\": \"en\" }'"
                    sh 'docker stop dataverse'
                    sh 'docker stop fair_eva'
                    sh 'docker rm fair_eva'
                }
            }
        }

        }
}
