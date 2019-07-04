pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }

  environment {
        OPENSHIFT_PROJECT = 'sandbox'
  }

  stages {
    stage('setup') {
      steps {
        echo "Set Openshift project"
        sh "oc project ${OPENSHIFT_PROJECT}"
        echo "${GIT_COMMIT}"
      }
    }
  }

}
