
String aws_creds = 'rd_ibm_aws'

stage("get_code") {
  node("config_node") {
    cleanWs()
    checkout scm
  }
}
stage("initialize") {
  node("config_node") {
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
  node("config_node") {
    withCredentials([[
      $class: 'AmazonWebServicesCredentialsBinding',
      credentialsId: aws_creds,
      accessKeyVariable: 'AWS_ACCESS_KEY_ID',
      secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]]) {
      sh 'terraform plan'
    }
  }
}
if (env.BRANCH_NAME == 'jenkins-pr1') {
  stage('apply') {
    node("config_node") {
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
    node("config_node") {
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
