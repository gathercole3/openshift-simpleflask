pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }

  environment {
        OPENSHIFT_PROJECT = 'sandbox' // name of the Openshift project where this 'app' will be deployed to.

  stages {
    stage('setup') {
      steps {
        echo "Set Openshift project"
        sh "oc project ${OPENSHIFT_PROJECT}"
      }
    }
  }

}
