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
                        projectConfig = pipelineConfig(
                            configFile: '.sqa/config.yml',
                            scmConfigs: [ localBranch: true ],
                            validatorDockerImage: 'eoscsynergy/jpl-validator:2.4.0')
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
    }
}
