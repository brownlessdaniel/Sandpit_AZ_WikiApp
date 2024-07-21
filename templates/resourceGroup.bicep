targetScope = 'subscription'

param location string
param appRGName string
param tagsString string = '{}'


var tags = json(tagsString)

resource appRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: appRGName
  location: location
  tags: tags
}
