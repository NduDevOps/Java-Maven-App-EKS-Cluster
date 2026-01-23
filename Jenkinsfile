#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('build app') {
            steps {
               script {
                   echo "building the application..."
               }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                   echo 'deploying docker image...'
                   withKubeConfig([credentialsId: 'lke-credentials', serverUrl: 'https://df1c75c9-7e26-4147-b60c-73a32c24cd6f.ca-central-1-gw.linodelke.net']) {
                        sh 'kubectl create deployment nginx-deployment --image=nginx'
                   }
                }
            }
        }
    }
}