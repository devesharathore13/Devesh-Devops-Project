pipelineJob('nodejs-app-pipeline') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/deverathore/nodejs-app.git')
                        credentials('github-token')
                    }
                    branch('*/main')
                }
            }
            scriptPath('Jenkinsfile')
        }
    }
    triggers {
        githubPush()
    }
}

folder('microservices') {
    displayName('Microservices Pipelines')
}

['auth', 'user', 'payment'].each { service ->
    pipelineJob("microservices/${service}-service") {
        definition {
            cpsScm {
                scm {
                    git("https://github.com/deverathore/${service}-service.git")
                }
                scriptPath('Jenkinsfile')
            }
        }
    }
}
