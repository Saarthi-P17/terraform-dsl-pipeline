pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform Action')
    }

    environment {
        GIT_REPO = "https://github.com/hardbro786/terraform.git"
    }

    stages {

        stage('Verify Setup') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        aws sts get-caller-identity
                        terraform -v
                    '''
                }
            }
        }

        // ================= APPLY FLOW =================

        stage('Mukesh-SSH') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("Mukesh-SSH") } }
        }

        stage('VPC') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("AbhinavS-VPC") } }
        }

        stage('Subnet') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("AbhinavT-SUBNET") } }
        }

        stage('IGW') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("Ajitesh-IGW") } }
        }

        stage('NAT') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("Aditya-NAT") } }
        }

        stage('RouteTable') {
            when { expression { params.ACTION == "apply" } }
            steps { script { runTerraform("Anirudh-routetable") } }
        }

        // ================= DESTROY FLOW =================

        stage('Destroy-RouteTable') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("Anirudh-routetable") } }
        }

        stage('Destroy-NAT') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("Aditya-NAT") } }
        }

        stage('Destroy-IGW') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("Ajitesh-IGW") } }
        }

        stage('Destroy-Subnet') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("AbhinavT-SUBNET") } }
        }

        stage('Destroy-VPC') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("AbhinavS-VPC") } }
        }

        stage('Destroy-SSH') {
            when { expression { params.ACTION == "destroy" } }
            steps { script { runTerraform("Mukesh-SSH") } }
        }
    }

    post {
        success {
            echo "SUCCESS: Terraform ${params.ACTION} completed"
        }
        failure {
            echo "FAILED: Pipeline failed"
        }
    }
}

// ================= FUNCTION =================

def runTerraform(branch) {
    dir("terraform-${branch}") {
        deleteDir()

        git branch: branch, url: GIT_REPO

        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-creds'
        ]]) {

            sh """
            set -e

            for i in 1 2 3
            do
              terraform init -reconfigure && break
              echo "Retrying terraform init..."
              sleep 10
            done

            if [ "${params.ACTION}" = "apply" ]; then
                terraform apply -auto-approve
            else
                terraform destroy -auto-approve
            fi
            """
        }
    }
}