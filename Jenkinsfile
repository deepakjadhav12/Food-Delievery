pipeline {
    agent any

    environment {
        IMAGE_NAME = 'food-delivery-app'
        CONTAINER_NAME = 'food-delivery-container'
        DOCKER_PORT = '3000'
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo '📥 Cloning repository...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo '🐳 Building Docker image...'
                    bat "docker build -t %IMAGE_NAME%:latest ."
                }
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                script {
                    echo '🛑 Stopping and removing old container if exists...'
                    bat """
                        docker ps -q --filter "name=%CONTAINER_NAME%" | findstr . && docker stop %CONTAINER_NAME% || echo No running container
                        docker ps -aq --filter "name=%CONTAINER_NAME%" | findstr . && docker rm %CONTAINER_NAME% || echo No container to remove
                    """
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    echo '🚀 Running new container...'
                    bat '''
                        docker run -d --name food-delivery-container -p 3000:3000 food-delivery-app:latest || exit /b 1
                    '''

                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        echo '📤 Pushing image to Docker Hub...'
                        bat """
                            docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                            docker tag %IMAGE_NAME%:latest %DOCKER_USER%/%IMAGE_NAME%:latest
                            docker push %DOCKER_USER%/%IMAGE_NAME%:latest
                        """
                    }
                }
            }
        }

        stage('Done') {
            steps {
                echo '✅ CI/CD Pipeline completed successfully!'
            }
        }
    }

    post {
        failure {
            echo '❌ Build Failed! Please check the errors.'
        }
    }
}
