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

    stage('build and publish docker image to external registry') {
      steps {
        echo 'Building and publishing docker image to nexus.'
            sh '''
              oc start-build simpleflask-build-latest -n sandbox \
              --from-repo=. \
              --follow=true \
              --wait=true \
              --commit=${GIT_COMMIT}
              '''
            }


        }
  }

}
