podTemplate(label: 'dockerslave', containers: [
    containerTemplate(name: 'docker', image: 'docker:dind', ttyEnabled: true, alwaysPullImage: true, privileged: true,
      command: 'dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --storage-driver=overlay')
  ],
  volumes: [emptyDirVolume(memory: false, mountPath: '/var/lib/docker')]) {

  node('dockerslave') {
      checkout scm
      stage('Run a docker thing') {
      container('docker') {
         sh 'ls /home/jenkins/workspace'
         sh 'ls ${WORKSPACE}'
         sh 'docker images'
      }
    }

  }

}
