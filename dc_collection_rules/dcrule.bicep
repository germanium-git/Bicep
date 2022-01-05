@description('Name of the data collection rule')
param dcRuleName string = 'windows_sql'

@description('The virtual machine to be assigned to the rule')
param vmName string = 'mysqlvm001'

@description('Data collection rule')
resource dataCollectionRule_windows_sql 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: dcRuleName
  location: resourceGroup().location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          samplingFrequencyInSeconds: 10
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Processes'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Handle Count'
            '\\System\\System Up Time'
            '\\System\\Context Switches/sec'
            '\\System\\Processor Queue Length'
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pages/sec'
            '\\Memory\\Page Faults/sec'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Packets/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
            '\\LogicalDisk(C:)\\% Disk Read Time'
            '\\LogicalDisk(C:)\\% Disk Write Time'
            '\\LogicalDisk(D:)\\% Disk Read Time'
            '\\LogicalDisk(D:)\\% Disk Write Time'
            '\\LogicalDisk(O:)\\% Disk Read Time'
            '\\LogicalDisk(O:)\\% Disk Write Time'
            '\\LogicalDisk(P:)\\% Disk Read Time'
            '\\LogicalDisk(P:)\\% Disk Write Time'
            '\\LogicalDisk(R)\\% Disk Read Time'
            '\\LogicalDisk(R)\\% Disk Write Time'
          ]
          name: 'perfCounterDataSource10'
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'azureMonitorMetrics-default'
        ]
      }
    ]
  }
}

resource mysqlvm 'Microsoft.Compute/virtualMachines@2021-07-01' existing = {
  name: vmName
}

resource mysqlvm_association 'Microsoft.Insights/dataCollectionRuleAssociations@2021-04-01' = {
  name: 'mysqlvm_association'
  scope: mysqlvm
  properties: {
    dataCollectionRuleId: dataCollectionRule_windows_sql.id
  }
}
