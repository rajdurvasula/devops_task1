
def aws_creds = 'rd_ibm_aws'
def ssh_key = 'rd_ssh_key'

pipeline {

  agent {
    label 'config_node'
  }

  parameters {
    string(name: playbook_name, defaultValue: 'install_apache', description: 'Which Playbook should I execute ?')
  }

  stages {
    stage("get_code") {
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage("initialize") {
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
      steps {
        withCredentials([[
          credentialsId: 'rd_ssh_key',
          keyFileVariable: 'SSH_KEY'
        ]]) {
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
      when {
        expression ${env.BRANCH_NAME} == 'jenkins-pr1' {
      }
      steps {
          stage('apply') {
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
        }
      }
    }
    stage('status') {
      when {
        expression ${env.BRANCH_NAME} == 'jenkins-pr1' {
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
