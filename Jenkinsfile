pipeline {
    agent any
    tools{
        maven 'maven_3_8_7'
    }
    
    stages {
        stage('Build Maven'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/BiBamba/docker-image-creation-pipeline']])
                sh 'mvn clean install'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t bbamba/docker-image-creation .'
                }
            }
        }
        stage('Push image to DockerHub'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'jenkinstoDH', variable: 'dockerHubpswd')]) {
                    sh 'docker login -u bbamba -p ${dockerHubpswd}'
                    }
                    sh 'docker push bbamba/docker-image-creation'
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                script{
                    sshagent(['jenkins-k8s']) {
                        sh 'scp -o StrictHostKeyChecking=no deploymentservice.yaml maxime@192.168.254.174:/home/maxime/jenkins/'
                        script{
                            try{
                                sh 'ssh maxime@192.168.254.174 kubectl apply -f /home/maxime/jenkins/deploymentservice.yaml'
                            }catch(error){
                                sh 'ssh maxime@192.168.254.174 kubectl create -f /home/maxime/jenkins/deploymentservice.yaml'
                            }
                        }
                        
                    }
                }
            }
        }

    }
}