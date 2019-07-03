pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('setup') {
      steps {
        echo "Hello world!"
      }
    }
  }

}
