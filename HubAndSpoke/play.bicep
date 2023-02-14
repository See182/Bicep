targetScope = 'resourceGroup'

/*** PARAMETERS ***/

@description('The location of this regional hub. All resources, including spoke resources, will be deployed to this region. This region must support availability zones.')
@minLength(6)
/* Ideally we'd include this limitation, but since we want to default to the resource group's location, we cannot.
@allowed([
  'brazilsouth'
  'canadacentral'
  'centralus'
  'eastus'
  'eastus2'
  'southcentralus'
  'westus2'
  'westus3'
  'francecentral'
  'germanywestcentral'
  'northeurope'
  'norwayeast'
  'uksouth'
  'westeurope'
  'sweedencentral'
  'switzerlandnorth'
  'uaenorth'
  'southafricanorth'
  'australiaeast'
  'centralindia'
  'japaneast'
  'koreacentral'
  'southeastasia'
  'eastasia'
])*/
param location string = resourceGroup().location


// Module Deploy
module HUB_vnet 'br/public:network/virtual-network:1.1.1' = {
  name: 'HUB-${location}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '172.16.0.128/26'
        }
      }
      {
        name: 'FW-WAN-snet'
        properties: {
          addressPrefix: '172.16.0.208/28'
        }
      }
      {
        name: 'FW-LAN-snet'
        properties: {
          addressPrefix: '172.16.0.192/28'
        }
      }
    ]
  }
}
