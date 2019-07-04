pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }

  environment {
        OPENSHIFT_PROJECT = 'sandbox'
        APP_NAME = 'simpleflask'
        BC_NAME = '${APP_NAME}-build-${GIT_COMMIT}'
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
                    oc get bc/${BC_NAME} \
                        || oc new-build \
                            --binary=true  \
                            --name="${BC_NAME}" \
                            --to="docker-registry.default.svc:5000/${OPENSHIFT_PROJECT}/${APP_NAME}:${GIT_COMMIT}" \
                            --strategy="docker"
                    '''

        sh '''
              oc start-build ${BC_NAME} -n sandbox \
              --from-repo=. \
              --follow=true \
              --wait=true \
              --commit=${GIT_COMMIT}
              '''
        }


        }
  }

}
