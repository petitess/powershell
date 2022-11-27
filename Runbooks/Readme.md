Use these scripts with ``Microsoft.Resources/deploymentScripts``

```bicep
resource script03 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'StopStartVM'
  location: location
  kind: 'AzurePowerShell'
  tags: {
    Application: 'Automation Account - Runbook'
    Service: aaname
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${idId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '5.0'
    retentionInterval: 'PT1H'
    timeout: 'PT10M'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'infrargname'
        value: aargname
      }
      {
        name: 'aaname'
        value: aaname
      }
      {
        name: 'runbookname01'
        value: param.runbooks.stopstartvm.runbookname01
      }
      {
        name: 'runbookname02'
        value: param.runbooks.stopstartvm.runbookname02
      }
      {
        name: 'runbookname03'
        value: param.runbooks.stopstartvm.runbookname03
      }
      {
        name: 'runbookname04'
        value: param.runbooks.stopstartvm.runbookname04
      }
      {
        name: 'schedulename01'
        value: replace(param.runbooks.stopstartvm.runbookname01, 'run', 'sch')
      }
      {
        name: 'schedulename02'
        value: replace(param.runbooks.stopstartvm.runbookname02, 'run', 'sch')
      }
      {
        name: 'schedulename03'
        value: replace(param.runbooks.stopstartvm.runbookname03, 'run', 'sch')
      }
      {
        name: 'schedulename04'
        value: replace(param.runbooks.stopstartvm.runbookname04, 'run', 'sch')
      }
      {
        name: 'stopvmtime'
        value: param.runbooks.stopstartvm.stopvmtime
      }
      {
        name: 'startvmtime'
        value: param.runbooks.stopstartvm.startvmtime
      }
    ]
    scriptContent: loadTextContent('../scripts/run-StopStartVM01.ps1')
  }
}
```
