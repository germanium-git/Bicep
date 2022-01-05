@description('Name of the Virtual machine')
param vmName string
param location string = resourceGroup().location

@description('Name of the Storage Account in which Diagnostic Logs should be saved.')
param diagnosticsStorageAccountName string

param diagnosticsStorageAccountEndPoint string


@description('Storage Account Key.')
@secure()
param storageAccountConnectionString string


var diagnosticsExtensionName = 'Microsoft.Insights.VMDiagnosticsSettings'
var metricsresourceid = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/virtualMachines/${vmName}'

resource vmName_diagnosticsExtensionName 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: '${vmName}/${diagnosticsExtensionName}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Diagnostics'
    type: 'IaaSDiagnostics'
    typeHandlerVersion: '1.5'
    autoUpgradeMinorVersion: true
    settings: {
      StorageAccount: diagnosticsStorageAccountName
      WadCfg: {
        DiagnosticMonitorConfiguration: {
          overallQuotaInMB: 5120
          Metrics: {
            resourceId: metricsresourceid
            MetricAggregation: [
              {
                scheduledTransferPeriod: 'PT1H'
              }
              {
                scheduledTransferPeriod: 'PT1M'
              }
            ]
          }
          DiagnosticInfrastructureLogs: {
            scheduledTransferLogLevelFilter: 'Error'
            scheduledTransferPeriod: 'PT1M'
          }
          PerformanceCounters: {
            scheduledTransferPeriod: 'PT1M'
            PerformanceCounterConfiguration: [
              {
                counterSpecifier: '\\Processor Information(_Total)\\% Processor Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Processor Information(_Total)\\% Privileged Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Processor Information(_Total)\\% User Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Processor Information(_Total)\\Processor Frequency'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\System\\Processes'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Process(_Total)\\Thread Count'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Process(_Total)\\Handle Count'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\System\\System Up Time'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\System\\Context Switches/sec'
                unit: 'CountPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\System\\Processor Queue Length'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\% Committed Bytes In Use'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Available Bytes'
                unit: 'Bytes'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Committed Bytes'
                unit: 'Bytes'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Cache Bytes'
                unit: 'Bytes'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Pool Paged Bytes'
                unit: 'Bytes'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Pool Nonpaged Bytes'
                unit: 'Bytes'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Pages/sec'
                unit: 'CountPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Memory\\Page Faults/sec'
                unit: 'CountPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Process(_Total)\\Working Set'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Process(_Total)\\Working Set - Private'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\% Disk Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\% Disk Read Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\% Disk Write Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\% Idle Time'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Bytes/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Transfers/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Reads/sec'
                unit: 'CountPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Disk Writes/sec'
                unit: 'CountPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\% Free Space'
                unit: 'Percent'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(_Total)\\Free Megabytes'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Bytes Total/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Bytes Sent/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Bytes Received/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Packets/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Packets Sent/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Packets Received/sec'
                unit: 'BytesPerSecond'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Packets Outbound Errors'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\Network Interface(*)\\Packets Received Errors'
                unit: 'Count'
                sampleRate: 'PT60S'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Disk Writes/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Disk Reads/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Disk Writes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Disk Reads/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(*)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Disk Writes/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Disk Reads/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Disk Writes/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Disk Reads/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Disk Writes/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Disk Reads/sec'
                sampleRate: 'PT60S'
                unit: 'CountPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\% Free Space'
                sampleRate: 'PT60S'
                unit: 'Percent'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Disk Write Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Disk Write Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Disk Write Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Disk Write Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Disk Write Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Disk Read Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Disk Read Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Disk Read Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Disk Read Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Disk Read Bytes/sec'
                sampleRate: 'PT60S'
                unit: 'BytesPerSecond'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Avg. Disk sec/Read'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Avg. Disk sec/Read'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Avg. Disk sec/Read'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Avg. Disk sec/Read'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Avg. Disk sec/Read'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\Avg. Disk sec/Write'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\Avg. Disk sec/Write'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\Avg. Disk sec/Write'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\Avg. Disk sec/Write'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\Avg. Disk sec/Write'
                sampleRate: 'PT1M'
                unit: 'Count'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\% Disk Read Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\% Disk Read Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\% Disk Read Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\% Disk Read Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\% Disk Read Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(C:)\\% Disk Write Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(D:)\\% Disk Write Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(O:)\\% Disk Write Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(P:)\\% Disk Write Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
              {
                counterSpecifier: '\\LogicalDisk(R:)\\% Disk Write Time'
                sampleRate: 'PT1M'
                unit: 'Percentage'
              }
            ]
          }
          WindowsEventLog: {
            scheduledTransferPeriod: 'PT1M'
            DataSource: []
          }
          Directories: {
            scheduledTransferPeriod: 'PT1M'
          }
        }
      }
    }
    protectedSettings: {
      storageAccountName: diagnosticsStorageAccountName
      storageAccountKey: storageAccountConnectionString
      storageAccountEndPoint: diagnosticsStorageAccountEndPoint
    }
  }
}
