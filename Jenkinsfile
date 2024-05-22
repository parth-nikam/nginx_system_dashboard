pipeline {
    agent any
    
    environment {
        INVENTORY_FILE = 'inventory.yml'
        PLAYBOOK_FILE = 'playbook.yml'
        VM1_MAIN_FILE = 'roles/vm1/tasks/main.yml'
        VM2_MAIN_FILE = 'roles/vm2/tasks/main.yml'
        VM3_MAIN_FILE = 'roles/vm3/tasks/main.yml'
        ANSIBLE = "/opt/homebrew/bin/ansible-playbook"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    def changedFiles = []
                    if (env.GIT_PREVIOUS_SUCCESSFUL_COMMIT) {
                        changedFiles = sh(script: "git diff --name-only ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT} ${env.GIT_COMMIT}", returnStdout: true).trim().split('\n')
                    } else {
                        changedFiles = sh(script: "git ls-files", returnStdout: true).trim().split('\n')
                    }
                    
                    def runPlaybook = false
                    def runVm1 = false
                    def runVm2 = false
                    def runVm3 = false

                    for (file in changedFiles) {
                        if (file == env.PLAYBOOK_FILE || file == env.INVENTORY_FILE) {
                            runPlaybook = true
                        }
                        if (file == env.VM1_MAIN_FILE) {
                            runVm1 = true
                        }
                        if (file == env.VM2_MAIN_FILE) {
                            runVm2 = true
                        }
                        if (file == env.VM3_MAIN_FILE) {
                            runVm3 = true
                        }
                    }

                    if (runPlaybook) {
                        echo "Running the entire playbook"
                        sh "${ANSIBLE} -i ${env.INVENTORY_FILE} ${env.PLAYBOOK_FILE}"
                    } else {
                        def hosts = []
                        if (runVm1) {
                            echo "Running playbook for vm1"
                            hosts.add('vm1')
                        }
                        if (runVm2) {
                            echo "Running playbook for vm2"
                            hosts.add('vm2')
                        }
                        if (runVm3) {
                            echo "Running playbook for vm3"
                            hosts.add('vm3')
                        }
                        if (hosts) {
                            def hostLimit = hosts.join(',')
                            sh "${ANSIBLE} -i ${env.INVENTORY_FILE} ${env.PLAYBOOK_FILE} --limit ${hostLimit}"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Ansible playbook run successfully!'
        }
        failure {
            echo 'Ansible playbook run failed.'
        }
    }
}
