param location string
param appServicePlanName string
param appServiceSKU string            // F1
param appServiceName string
param tags object
param myIPAddress string
param pythonVersion string

targetScope = 'resourceGroup'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: appServiceSKU
  }
  kind: 'linux'
}

resource wikiApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  tags: tags
  kind: 'app,linux'

  // identity: {
  //   type: ''
  // }

  properties: {
    enabled: true
    // dailyMemoryTimeQuota: int
    serverFarmId: appServicePlan.id
    httpsOnly: false
    siteConfig: {
      pythonVersion: pythonVersion
      alwaysOn: true
      detailedErrorLoggingEnabled: true
      healthCheckPath: '/'
      http20Enabled: true
      minTlsVersion: '1.2'
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 2000
      numberOfWorkers: 2

      vnetName: 'string'
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
          subnetMask: '255.255.255.255'
        }
      ]
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      // scmType: 'GitHub'
      limits: {
        maxDiskSizeInMb: 4000
        maxMemoryInMb: 2000
        maxPercentageCpu: 70
      }
      // managedServiceIdentityId: ''
    }
  }
}
