pipeline {
    agent {
        label ''
    }
    environment {
        PGAPSSWORD=credentials('sc-pass')

    }
    parameters {
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
                echo 'deploy to QA'
                echo "BRANCH_NAME var: ${BRANCH_NAME}"
                echo "Docker image scorecard:${params.version} deployed to QA"
            }
        }
        stage('Deploy - PROD') {
  
            when {
                anyOf {
                    expression { params.deployPROD == 'yes' };
                    // expression { "${BRANCH_NAME}".startsWith('release/') }
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
                echo "Docker image scorecard:${params.version} deployed to PROD"
                slackSend channel: '#jenkins', message: """
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