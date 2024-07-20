param location string
param appRGName string

targetScope = 'subscription'

resource appRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: appRGName
  location: location
}
