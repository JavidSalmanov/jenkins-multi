pipeline {
    agent {
        label ''
    }
    environment {
        PGAPSSWORD=credentials('sc-pass')

    }
    parameters {
        string(name: 'version', defaultValue: null, description: 'App version to deploy')
        string(name: 'releaseVersion', defaultValue: "${currentBuild.number}", description: 'Docker version to deploy')
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
                timeout(time: 2, unit: "MINUTES") {
                    input message: 'Approve Deploy?', ok: 'Accept'
                }
                script{
                    version = sh(script: "echo release-${currentBuild.number}", returnStdout: true).trim()
                    releaseVersion = sh(script: "ls scorecard-service-*.jar |cut -d '-' -f 3 | cut -d '.' -f 1-3 ", returnStdout: true)
                    if ("${BRANCH_NAME}".startsWith('release/')) {
                        NEW_TAG = sh(script: "echo release-${releaseVersion}", returnStdout: true).trim()
                    } else {
                        NEW_TAG = sh(script: "echo build-${releaseVersion}", returnStdout: true).trim()
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
                        RELEASE_TAG = sh(script: "echo release-${releaseVersion}", returnStdout: true).trim()
                    } 
                    else {
                        RELEASE_TAG = sh(script: "echo build-${releaseVersion}", returnStdout: true).trim()
                    }
                    if ("${params.version}" != null ) {
                        version = sh(script: "echo ${params.version}", returnStdout: true).trim()
                        echo "version: $version"
                    }
                    else
                    {
                        version = sh(script: "echo ${currentBuild.number}", returnStdout: true).trim()
                        echo "version: $version"
                    }
                }
                echo 'deploy to QA'
                echo "BRANCH_NAME var: ${BRANCH_NAME}"
                echo "'scorecard:${RELEASE_TAG}-${version}' deployed to QA"
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
                script{
                    if ("${params.version}" != null ) {
                        version = sh(script: "echo ${params.version}", returnStdout: true).trim()
                        echo "version: $version"
                    }
                    else
                    {
                        version = sh(script: "echo ${currentBuild.number}", returnStdout: true).trim()
                        echo "version: $version"
                    }
                }

                echo 'Production!!!'
                echo 'Deploying to PROD'
                echo "Stop docker container"
                echo "Create DB dump"
                echo "Run run.sh script"
                echo "Docker image scorecard:release-${releaseVersion}-${params.version} deployed to PROD"
                slackSend channel: '#jenkins', color: '#BADA55', message: """BUILD_NUMBER: ${version} 
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