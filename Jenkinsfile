pipeline {
  agent { label('docker') }
  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('setup') {
      steps {
        echo "Hello world!"
        echo "Hello world!"
        sh "ls"
        sh "docker images"
      }
    }
  }

}
