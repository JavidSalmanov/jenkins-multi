def dockerImageName = "${dockerRepo}/scorecard/service"
pipeline {
    environment {
        registry = "javidsa/sc"
        registryCredential = 'docker-hub'
        dockerImage = ''
    }
    agent {
        label ''
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
                echo "TAG_NAME: ${env.GIT_TAG_NAME}"
                dockerImage = docker build -t "${registry}:${params.version}" --build-arg "version=${params.version}" .
                docker.withRegistry( '', registryCredential ) {
                dockerImage.push()

                }
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
                sh '''
                    dokcer container rm -f web-qa
                    docker container run -d --name web-qa--publish 81:80 "${registry}:${params.version}"
                '''

            }
        }
        stage('Deploy - PROD') {
  
            when {
                anyOf {
                    expression { params.deployPROD == 'yes' };
                    expression { "${BRANCH_NAME}".startsWith('release/') }
                }
            }
            steps {
                timeout(time: 2, unit: "MINUTES") {
                    input message: 'Approve Deploy?', ok: 'Yes'
                }
                echo 'Production!!!'
                echo 'deploy to PROD'
                sh '''
                    dokcer container rm -f web-prod
                    docker container run -d --name web-prod --publish 82:80 "${registry}:${params.version}"
                '''
                echo "version: ${params.version}"
                slackSend channel: '#jenkins', message: "Deployment sc:${BUILD_NUMBER} docker image to PROD is ${currentBuild.currentResult}"
            }
        }
    }
    post { 
        always { 
            cleanWs()
        }
    }
}