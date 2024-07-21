param location string
param appServicePlanName string
param appServiceSKU string            // F1
param appServiceName string
// param tags object
param myIPAddress string
param pythonVersion string
param healthCheckPath string
param vnetName string

targetScope = 'resourceGroup'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true // needs to be true for linux
  }
  sku: {
    name: appServiceSKU
  }
  kind: 'linux'
}

resource wikiApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  // tags: tags
  kind: 'app,linux'

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
