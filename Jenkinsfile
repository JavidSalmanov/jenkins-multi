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
                anyOf {
                    expression { params.deployQA == 'yes' }
                    expression {  "${env.GIT_TAG_NAME}".startsWith('v/') };
                }
            }
            steps {
                echo 'deploy to QA'
                echo "BRANCH_NAME var: ${BRANCH_NAME}"
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