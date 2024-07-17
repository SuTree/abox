pipeline {
  environment {
    registry_url = "harbor.example.com"
    project = "build"
    registry = "${registry_url}/${project}/${env.GIT_BRANCH}"
    registryCredential = 'harbor-user-passwd'
    dockerImage = ''
    version = "${new Date().format('yyyy-MM-dd')}"
  }


  agent {
    label {
      label 'jnlp-agent-docker'
      retries 3
    }
  }

  stages {
    stage('check out git repo') {
      steps {
        git(credentialsId: 'http-ip-gitlab-api-token', url: "${env.GIT_URL}", branch: "${env.GIT_BRANCH}", changelog: true, poll: true)
      }
    }

    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }

    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( "https://${registry_url}", registryCredential ) {
            dockerImage.push()
            dockerImage.push('latest')
            dockerImage.push("${version}")
          }
        }
      }
    }

    stage('Remove Unused docker image') {
      steps{
        sh """
        docker rmi $registry:latest
        docker rmi $registry:${version}
        """
      }
    }
  }
}
