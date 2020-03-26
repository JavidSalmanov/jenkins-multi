//comment
def branch = "${BRANCH_NAME}"
pipeline {
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

        // stage('Source') {
        //     when {
        //         expression { params.build == 'yes' }
        //     }
        //     steps {
        //         echo 'Get repo'
        //     }
        // }
        
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
                }
            }

        stage('Deploy - QA') {
            when {
                expression { params.deployQA == 'yes' }
            }
            steps {
                echo 'deploy to QA'
                echo "Branch name is: ${branch}"
                echo "{BUILD_NUMBER}: ${BUILD_NUMBER}"
                echo "BUILD_NUMBER: ${BUILD_NUMBER}"
                echo "BRANCH_NAME: ${BRANCH_NAME}"
            }
        }
        stage('Deploy - PROD') {

            when {
                anyOf {
                    expression { params.deployPROD == 'yes' };
                    expression { $BRANCH_NAME == "release1.2" }
                }
            }
            steps {
                input "Deploy to prod?"
                echo 'Production!!!'
                echo 'deploy to PROD'
                echo "${params.version}"
            }
        }
    }
    post { 
        always { 
            cleanWs()
        }
    }
}