pipeline {
  agent { label('maven') }
  options {
    disableConcurrentBuilds()
  }
  

  environment {
        OPENSHIFT_PROJECT = 'sandbox'
        APP_NAME = 'simpleflask'
        BC_NAME = "${APP_NAME}-build-${GIT_COMMIT}"
        CM_NAME = "${APP_NAME}-${GIT_COMMIT}"
        IMAGE_NAME= "docker-registry.default.svc:5000/${OPENSHIFT_PROJECT}/${APP_NAME}:${GIT_COMMIT}"
        POD_NAME= "${APP_NAME}-${GIT_COMMIT}"

        DEPLOYED_POD_NAME= ""
  }

  stages {
    stage('setup') {
      steps {
        echo "Set Openshift project"
        sh "oc project ${OPENSHIFT_PROJECT}"
        echo "${GIT_COMMIT}"
      }
    }


    stage('build config map') {
      steps {
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
        sh '''
                    oc get bc/${BC_NAME} \
                        || oc new-build \
                            --binary=true  \
                            --name="${BC_NAME}" \
                            --to="${IMAGE_NAME}" \
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

      post {
        always { 
            echo 'cleanup build config'
            sh 'oc delete bc/${BC_NAME}'
        }
      }


    }

    stage('deploy docker image to openshift') {
            when {
                expression { BRANCH_NAME.startsWith('PR-')}
            }
            steps {
                 sh '''
                    oc new-app -f ./cicd/template.yaml \
                      -p CONFIG_MAP=${CM_NAME} \
                      -p DOCKER_IMAGE=${IMAGE_NAME} \
                      -p POD_NAME=${POD_NAME}
                    '''

                 echo 'waiting for pod to be healthy'

                 sh '''
                    a=0
                    while [ $a -lt 5 ]
                    do
                        if [ oc get pods --field-selector=status.phase=Running | grep "${POD_NAME}" == "" ]; then
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
            sh "oc delete configmaps ${CM_NAME}"
            sh "oc delete pod ${POD_NAME}"
          }
        }
    }
  }

}


