pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('setup') {
      steps {
        echo "Hello world!"
        echo "Webhook test"
        sh "ls"
        sh "oc --version"
      }
    }
  }

}
