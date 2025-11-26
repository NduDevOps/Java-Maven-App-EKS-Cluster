#!/usr/bin/env groovy

library identifier: 'Jenkins-Shared-Library-Master@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/OkomaNdu/Jenkins-Shared-Library-Master.git',
    credentialsID: 'GitHub-Credentials'
    ]
)
pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {

        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version....'
                    sh '''
                         mvn build-helper:parse-version \
                         versions:set -DnewVersion=\\${parsedVersion.majorVersion}.\\${parsedVersion.minorVersion}.\\${parsedVersion.nextIncrementalVersion} \
                         versions:commit
                       '''
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "ndubuisip/demo-app:${version}-${BUILD_NUMBER}"
                }
            }
        }
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

                    def shellCmd = "bash ./server-cmds.sh ${env.IMAGE_NAME}"
                    def ec2Instance = "ec2-user@16.52.82.16"
                    sshagent(['EC2-Server-Key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage('commit version update'){
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'GitHub-Credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh 'git remote set-url origin https://$USER:$PASS@github.com/OkomaNdu/Java-Maven-App-Multi-Branch.git'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
