pipeline {
  agent { label('maven') }
  options {
    timestamps()
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
