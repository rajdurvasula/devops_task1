pipeline {
  agent any
  environment {
    TF_VAR_aws_access_key="$(AWS_ACCESS_KEY_ID)"
    TF_VAR_aws_secret_key="$(AWS_SECRET_ACCESS_KEY)"
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
