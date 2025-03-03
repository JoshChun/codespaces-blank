@description('Name of VM')
param vmName string = 'myVM'

@description('Username for VM')
param adminUsername string

@description('Types of authentication allowed')
@allowed([
    'sshPublicKey'
    'password'
])
param authenticationType string
