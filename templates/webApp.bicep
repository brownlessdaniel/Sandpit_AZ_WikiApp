param location string
param appServicePlanName string
param appServiceSKU string            // F1
param appServiceName string

param myIPAddress string
param pythonVersion string
param healthCheckPath string
param vnetName string
param tagsString string = '{}'

targetScope = 'resourceGroup'


var tags = json(tagsString)

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  tags: tags
  properties: {
    reserved: true // needs to be true for linux
  }
  sku: {
    name: appServiceSKU
  }
}

resource wikiApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  kind: 'app,linux'
  tags: tags
  // identity: {s
  //   type: ''
  // }

  properties: {
    enabled: true
    // dailyMemoryTimeQuota: int
    serverFarmId: appServicePlan.id
    httpsOnly: false
    siteConfig: {
      pythonVersion: pythonVersion
      detailedErrorLoggingEnabled: true
      healthCheckPath: healthCheckPath
      http20Enabled: true
      minTlsVersion: '1.2'
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 2000
      vnetName: vnetName
      vnetRouteAllEnabled: true
      publicNetworkAccess: 'Enabled'
      ipSecurityRestrictionsDefaultAction: 'Deny'
      ipSecurityRestrictions: [
        {
          name: 'allow my IP'
          action: 'Allow'
          description: 'Allow my IP'
          priority: 1
          ipAddress: myIPAddress
        }
      ]
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      // scmType: 'GitHub'
      limits: {
        maxDiskSizeInMb: 1000
        maxMemoryInMb: 1000
        // maxPercentageCpu: 70
      }
      // managedServiceIdentityId: ''
    }
  }
}
