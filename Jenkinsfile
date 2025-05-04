pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning repository...'
                // Clone the repository using the scm (source code management)
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    bat 'docker build -t food-delivery-app:latest .'
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Run Docker container
                    bat 'docker run -d -p 3000:3000 food-delivery-app:latest'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        set DOCKER_TLS_VERIFY=0
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker tag food-delivery-app:latest %DOCKER_USER%/food-delivery-app:latest
                        docker push %DOCKER_USER%/food-delivery-app:latest
                    """
                }
            }
        }

        stage('Done') {
            steps {
                echo 'Build and Run complete!'
            }
        }
    }
}
