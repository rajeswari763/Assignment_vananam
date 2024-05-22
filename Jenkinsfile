pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/rajeswari763/Assignment_vananam.git'
        GIT_BRANCH = 'main'
		DOCKER_USERNAME="your_username"
		DOCKER_PASSWORD="your_password" //users wll be added in credentials of jenkins
		DOCKER_REPOSITORY="rajeswariaddanki/assignment_vananam"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                git branch: "${env.GIT_BRANCH}", url: "${env.GIT_REPO}"
            }
        }

        stage('build docker') {
            steps {
                script {
                    // Make the script executable and run it
                    sh 'docker build -t my-app:latest .'
                    //sh 'docker run -d -p 80:8080 my-app:latest'
                }
            }
        }
        stage('Test Docker image') {
            steps {
                script {
                    sh '''
                    	CONTAINER=`docker ps | grep 80 | cut -d " " -f 1`
	                    if ! test -z $CONTAINER ; then for i in $CONTAINER ; do docker stop $i ; done ; else echo fail ; fi
	                    docker run -d -p 80:8080 my-app:latest
	                    sleep 5
	                    if curl -s localhost | grep "Hello" ; then echo Test is Success ; else exit 1 ; fi
	                    CONTAINER=`docker ps | grep 80 | cut -d " " -f 1`
	                    if ! test -z $CONTAINER ; then for i in $CONTAINER ; do docker stop $i ; done ; else echo fail ; fi
                    '''
                }
            }
        }
        stage('Publish Docker image') {
            steps {
                script {
					sh '#echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
					sh '#docker tag my-app:latest ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
					sh '#docker push ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
                }
            }
        }
        stage('Deploy Docker Image') {
            steps {
                script {
					sh '#docker pull ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
					sh 'OLD_DOCKER_CONTAINER=$(docker ps | grep 8080 | cut -d " " -f 1)'
					sh 'docker stop $OLD_DOCKER_CONTAINER'
					sh 'docker run -d -p 8080:8080 ${DOCKER_REPOSITORY}:${BUILD_NUMBER}'
					sh 'NEW_DOCKER_CONTAINER=$(docker ps | grep 8080 | cut -d " " -f 1)'
					sh 'sleep 5'
                    sh '''
						if curl -s localhost:8080 | grep Hello 
						then 
							echo Deployment is Successful 
							docker rm $OLD_DOCKER_CONTAINER
						else 
							echo Deployment is failed 
							echo Restoring old container
							docker stop $NEW_DOCKER_CONTAINER
							docker start $OLD_DOCKER_CONTAINER
						fi
					'''
                }
            }
        }
    }

    post {
        always {
            // Cleanup
            cleanWs()
        }
    }
}
