@Library('piper-lib-os') _
node()
{
stage('Prepare')	
	checkout scm
	stage('Clone'){
	println "prepare - gctsCloneRepository"
	gctsCloneRepository(
		  client: '210',
		  host:'https://lab-s4bfor.everislab.com:44340',
		  abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		  repository: 'vgonzcam-oip_gcts_test_01',
		  script: this,
		  verbose: true
	)
	println "end - gctsCloneRepository"
	}
stage('RunUnitTest')
	gctsExecuteABAPUnitTests(
		script: this,
		host: 'https://lab-s4bfor.everislab.com:44340',
		client: '210',
		abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		repository: 'vgonzcam-oip_gcts_test_01'
	)
stage('Deploy')
	gctsDeploy(
		script: this,
		host:'https://lab-s4bfor.everislab.com:44340',
		client: '210',
		abapCredentialsId: 'ABAPUserPasswordCredentialsId',
		repository: 'vgonzcam-oip_gcts_test_01',
		remoteRepositoryURL: 'https://github.com/vgonzcam/oip_gcts_test_01',
		vSID: 'GIT',
		rollback: true,
		configuration: [VCS_AUTOMATIC_PULL: 'FALSE',VCS_AUTOMATIC_PUSH: 'FALSE',CLIENT_VCS_LOGLVL: 'debug']
	)

}
