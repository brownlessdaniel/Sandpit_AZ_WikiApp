targetScope = 'subscription'

param location string
param appRGName string

var tags_object = loadJsonContent('buildTags.json')

resource appRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: appRGName
  location: location
  tags: tags_object
}
