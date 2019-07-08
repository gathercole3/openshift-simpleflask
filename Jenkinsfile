def getImageTag = { String COMMIT, String BRANCH_NAME ->
    // branch names for develop and master will be named 'latest' and 'stable'
    switch (BRANCH_NAME) {
        case ~/^master$/:
            return 'latest'
        default:
            return COMMIT
    }
}


pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }
  

  environment {
        IMAGE_TAG = getImageTag(GIT_COMMIT, BRANCH_NAME)
        REGISTRY = "docker-registry.default.svc:5000/"
        IMAGE = "${OPENSHIFT_PROJECT}/${APP_NAME}"

        OPENSHIFT_PROJECT = 'sandbox'
        APP_NAME = 'simpleflask'
        BC_NAME = "${APP_NAME}-build-${IMAGE_TAG}"
        CM_NAME = "${APP_NAME}-${IMAGE_TAG}"
        IMAGE_NAME = "${REGISTRY}${IMAGE}:${IMAGE_TAG}"
        POD_NAME= "${APP_NAME}-${IMAGE_TAG}"

        DEPLOYED_POD_NAME= ""
  }

  stages {
    stage('setup') {
      steps {
        echo "Set Openshift project"
        sh "oc project ${OPENSHIFT_PROJECT}"
        echo "${IMAGE_TAG}"
        echo "${BRANCH_NAME}"
      }
    }


    stage('build config map') {
      steps {
        script {
          if( BRANCH_NAME == "master" ) {
            sh "oc delete configmaps ${CM_NAME}"
          }
        }

        sh '''
        oc create configmap ${CM_NAME} \
          --from-literal=APP_NAME=flask-frontend-skeleton \
          --from-literal=FLASK_LOG_LEVEL=DEBUG \
          --from-literal=PYTHONPATH=/opt
        '''
      }
    }

    stage('build and publish docker image to internal registry') {
      steps {
        script {
          if( BRANCH_NAME.startsWith('PR-') ) {
            echo "${IMAGE_NAME}"

            sh """
                      oc get bc/${BC_NAME} \
                          || oc new-build \
                              --binary=true  \
                              --name="${BC_NAME}" \
                              --to="${IMAGE}:${IMAGE_TAG}" \
                              --strategy="pipeline"
                      """

            sh """
                  oc start-build ${BC_NAME} -n sandbox \
                  --from-repo=. \
                  --follow=true \
                  --wait=true \
                  --commit=${GIT_COMMIT}
                  """
          } else if(BRANCH_NAME == "master") {
              sh 'oc tag ${IMAGE}:$(git rev-list --max-count=1 ${GIT_COMMIT}^2) ${IMAGE}:${IMAGE_TAG}'
          }
        }
      }

    }

    stage('deploy docker image to openshift') {
            when {
                expression { BRANCH_NAME.startsWith('PR-')}
            }
            steps {
                 echo "${IMAGE_NAME}"
                 sh '''
                    oc new-app -f ./cicd/template.yaml \
                      -p CONFIG_MAP=${CM_NAME} \
                      -p DOCKER_IMAGE=${IMAGE_NAME} \
                      -p POD_NAME=${POD_NAME}
                    '''

                 echo 'waiting for pod to be healthy'

                 sh '''
                    a=0
                    while [ $a -lt 10 ]
                    do
                        if [ "$(oc get pods --field-selector=status.phase=Running | grep "${POD_NAME}")" == "" ]; then
                            sleep 2
                            a=$((a + 1))
                         else
                            break
                        fi
                    done
                '''
              }
          }


    stage('run unit tests') {
            when {
                expression { BRANCH_NAME.startsWith('PR-')}
            }
            steps {
                 sh '''
                    oc exec ${POD_NAME} curl https://google.co.uk
                '''
              }
          }

  }

  post {
    always { 
        echo 'cleanup configmap'
        script {
          if( BRANCH_NAME.startsWith('PR-') ) {
            sh "oc delete pod ${POD_NAME}"
            sh 'oc delete bc/${BC_NAME}'
            sh "oc delete configmaps ${CM_NAME}"
          }
        }
    }
  }

}


