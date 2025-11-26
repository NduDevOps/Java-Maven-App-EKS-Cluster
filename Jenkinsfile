#!/usr/bin/env groovy

library identifier: 'Jenkins-Shared-Library-Master@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/OkomaNdu/Jenkins-Shared-Library-Master.git',
    credentialsID: 'gitlab-credentials'
    ]
)
pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = 'ndubuisip/demo-app:java-maven-1.0'
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['EC2-Server-Key']) {
                        sh "scp docker-compose.yaml ec2-user@16.52.82.16:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@16.52.82.16 ${dockerComposeCmd}"
                    }
                }
            }
        }
    }
}
