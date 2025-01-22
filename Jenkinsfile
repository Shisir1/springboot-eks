pipeline {
    agent any

    environment {
        AWS_REGION =    'us-east-1'
        ECR_REPO = '<account_id>.dkr.ecr.${AWS_REGION}.amazonaws.com/springboot-eks-app'
        DOCKER_IMAGE = "${ECR_REPO}:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Shisir1/springboot-eks.git'
                }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/springboot-eks-app springboot-eks-app=${DOCKER_IMAGE} \
                    --record --kubeconfig /<path/to/kubeconfig>
                    """
                }

            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}