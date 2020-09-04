
def aws_creds = 'rd_ibm_aws'
def ssh_key = 'rd_ssh_key'

pipeline {

  agent none

  parameters {
    choice choices: ['install_apache', 'test_apache'], description: 'Select a playbook to execute', name: 'playbook_name'
  }

  stages {
    stage("get_code") {
      agent {
        label 'config_node'
      }
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage("initialize") {
      agent {
        label 'config_node'
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: aws_creds,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          sh 'terraform init'
        }
      }
    }
    stage("prepare") {
      agent {
        label 'config_node'
      }
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'rd_ssh_key',
          keyFileVariable: 'SSH_KEY'
        )]) {
          sh 'cp "$SSH_KEY" $HOME/rd_ssh_key.pem'
        }
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: aws_creds,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          sh 'terraform plan -out test.plan'
        }
      }
    }
    stage("deploy") {
      agent {
        label 'config_node'
      }
      when {
        branch 'jenkins-pr1'
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: aws_creds,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          sh 'terraform apply -auto-approve'
        }
      }
    }
    stage('status') {
      agent {
        label 'config_node'
      }
      when {
        branch 'jenkins-pr1'
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: aws_creds,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          sh 'terraform show'
        }
      }
    }
  }
}