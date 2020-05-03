pipeline{
    agent any
    stages{
        stage("Build"){
            steps{
                sh 'echo "installing docker locally"'
                sh 'chmod 775 ./scripts/*'
                sh './scripts/before_installation.sh'
                sh 'echo "building images and pushing it to DockerHub"'
                sh './scripts/dockerauto.sh'
            }
        }
        stage("Test"){
            steps{
                sh 'echo "testing application locally"'
                sh 'chmod 775 ./scripts/*'
                sh './scripts/installation.sh'
                sh 'docker-compose up -d'
                sh 'sleep 10'
                sh 'docker-compose up -d'
                sh 'sleep 30'
                sh 'echo "checking URLs"'
                sh './scripts/run_before.sh'
                sh 'docker-compose down'
                sh 'sleep 20'
            }
        }
        stage("Deploy"){
            steps{
                sh 'echo "install kubectl"'
                sh 'chmod 775 ./scripts/*'
                sh './scripts/kubectl.sh'
            }
        }
    }
}