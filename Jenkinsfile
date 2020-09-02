pipeline {
  agent any
  environment {
    TF_VAR_aws_access_key="$(access-key)"
    TF_VAR_aws_secret_key="$(secret-key)"
    TF_VAR_region="ap-southeast-1"
  }
  stages {
    stage("get_code") {
      node {
        cleanWs()
        checkout scm
      }
    }
    stage("initialize") {
      node {
        sh 'terraform init'
      }
    }
    stage("prepare") {
      node {
        sh 'terraform plan'
      }
    }
    if (env.BRANCH_NAME == 'master') {
      stage('apply') {
        node {
          sh 'terraform apply -auto-approve'
        }
      }
      stage('status') {
        node {
          sh 'terraform show'
        }
      }
    }
  }
}
