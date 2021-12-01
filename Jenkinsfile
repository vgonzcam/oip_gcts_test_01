@Library('piper-lib-os') _

node()
{
/**
stage('Prepare')	
	checkout scm
	stage('Clone'){
	println "prepare - gctsCloneRepository"
	gctsCloneRepository(
		  client: '210',
		  host:'https://lab-s4bfor.everislab.com:44340',
		  abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		  repository: 'santiagogm1995-gctstest',
		  script: this,
		  verbose: true
	)
	println "end - gctsCloneRepository"
	}
	**/
stage('RunUnitTest')
	gctsExecuteABAPUnitTests(
		script: this,
		host: 'https://lab-s4bfor.everislab.com:44340',
		client: '210',
		abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		repository: 'santiagogm1995-gctstest'
	)

stage('Deploy')
	gctsDeploy(
		script: this,
		host:'https://lab-s4bfor.everislab.com:44340',
		client: '210',
		abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		repository: 'santiagogm1995-gctstest',
		remoteRepositoryURL: 'https://github.com/santiagogm1995/gctstest',
		vSID: 'GIT',
		rollback: true,
		configuration: [VCS_AUTOMATIC_PULL: 'FALSE',VCS_AUTOMATIC_PUSH: 'FALSE',CLIENT_VCS_LOGLVL: 'debug']
	)

}
