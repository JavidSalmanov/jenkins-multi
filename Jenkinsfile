pipeline {
    agent {
        label ''
    }
    environment {
        PGAPSSWORD=credentials('sc-pass')

    }
    parameters {
        string(name: 'releaseVersion', defaultValue: "${currentBuild.number}", description: 'App version to deploy')
        string(name: 'version', defaultValue: "${currentBuild.number}", description: 'Docker version to deploy')
        choice(
            choices: ['yes', 'no'],
            description: 'Build app and docker image',
            name: 'build')
        choice(
            choices: ['yes', 'no'],
            description: 'Deploy to QA',
            name: 'deployQA')
        choice(
            choices: ['no', 'yes'],
            description: 'Deploy to PROD',
            name: 'deployPROD')
    }
    stages {
        
        stage('Build') {
            agent { 
                label ''
            }
            when {
                expression { params.build == 'yes' }
            }
            steps {
                echo 'build app'
                script{
                    releaseVersion = sh(script: "ls scorecard-service-*.jar |cut -d '-' -f 3 | cut -d '.' -f 1-3 ", returnStdout: true)
                    if ("${BRANCH_NAME}".startsWith('release/')) {
                        NEW_TAG = sh(script: "echo release-${releaseVersion}", returnStdout: true)
                    } else {
                        NEW_TAG = sh(script: "echo build-${releaseVersion}", returnStdout: true)
                    }
                }
                echo "releaseVersion: $releaseVersion"
                echo "NEW_TAG: $NEW_TAG" 
            }
        }
        
        stage('Image') {
            when {
                expression { params.build == 'yes' }
            }
            steps {
                echo 'Build image'
                echo "PGAPSSWORD: $PGAPSSWORD"
            }
        }
        stage('Deploy - QA') {
            when {
                anyOf {
                    expression { params.deployQA == 'yes' }
                }
            }
              
            steps {
                script{
                    if ("${BRANCH_NAME}".startsWith('release/')) {
                        RELEASE_TAG = sh(script: "echo release-${releaseVersion}", returnStdout: true)
                    } 
                    else {
                        RELEASE_TAG = sh(script: "echo build-${releaseVersion}\-${currentBuild.number}", returnStdout: true)
                    }
                }
                echo 'deploy to QA'
                echo "BRANCH_NAME var: ${BRANCH_NAME}"
                echo "'scorecard:${RELEASE_TAG}\-${params.version}' deployed to QA"
                echo "scorecard:${RELEASE_TAG}_${params.version} deployed to QA"
                echo "scorecard:${RELEASE_TAG}'-'${params.version} deployed to QA"
                echo "scorecard:${RELEASE_TAG}:${params.version} deployed to QA"
                echo "scorecard:${RELEASE_TAG}${params.version} "
                echo "releaseVersion: $releaseVersion" 

            }
        }
        stage('Deploy - PROD') {
  
            when {
                allOf {
                    expression { params.deployPROD == 'yes' };
                    expression { "${BRANCH_NAME}".startsWith('release/') }
                }
            }
            steps {
                timeout(time: 2, unit: "MINUTES") {
                    input message: 'Approve Deploy?', ok: 'Accept'
                }
                echo 'Production!!!'
                echo 'Deploying to PROD'
                echo "Stop docker container"
                echo "Create DB dump"
                echo "Run run.sh script"
                echo "Docker image scorecard:release-${releaseVersion}-${params.version} deployed to PROD"
                slackSend channel: '#jenkins', color: '#BADA55', message: """BUILD_NUMBER: ${params.version} 
                GIT_COMMIT: ${GIT_COMMIT}
                ENVIRONMENT: PROD
                DEPLOYMENT_STATUS: ${currentBuild.currentResult}
                """
            }
        }
    }
    post { 
        always { 
            cleanWs()
        }
    }
}