def p = ~/release.*/
pipeline {
    agent {
        label ''
    }
    parameters {
        string(name: 'version', defaultValue: "${currentBuild.number}", description: 'Docker version to deploy')
        string(name: 'branchName', defaultValue: "${BRANCH_NAME}", description: 'Branch name')
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
            }
        }
        stage('Deploy - PROD') {
  
            when {
                anyOf {
                    expression { params.deployPROD == 'yes' };
                    expression { $p =~ params.branchName }
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