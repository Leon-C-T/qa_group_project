pipeline{
    agent any
    stages{
        stage("Build"){
            steps{
                sh 'echo "installing docker locally"'
                sh 'chmod 775 ./scripts/*'
                sh './scripts/before_installation.sh'
                sh 'echo "adding jenkins to Docker"'
                sh 'sudo usermod -aG docker $USER'
            }
        }
        stage("Test"){
            steps{
                sh 'echo "testing application locally"'
                sh 'chmod 775 ./scripts/*'
                sh './scripts/installation.sh'
                sh 'docker-compose up -d --force-recreate'
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
        stage("Update"){
            steps{
                sh 'echo "copying and pasting updated terraform files"'
                sh 'chmod 775 ./scripts/*'
                sh 'ansible-playbook -i ./ansible/configure.conf ./ansible/update-files.yml'
            }
        }
    }
}