pipeline {
  agent { label('docker') }
  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('setup') {
      steps {
        echo "Hello world!"
        echo "Webhook test"
        sh "ls"
        sh "docker images"
      }
    }
  }

}
