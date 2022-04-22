Import-Module .\PrometheusExporter

$dhcpStatisticsTotalTotalScopes               = New-MetricDescriptor -Name "dhcp_statistics_total_scopes_count"                 -Type gauge -Help "Count of scopes in the selected server."
$dhcpStatisticsTotalScopesWithDelayConfigured = New-MetricDescriptor -Name "dhcp_statistics_total_scopes_with_delay_count"      -Type gauge -Help "Count of delayed scopes in the selected server."
$dhcpStatisticsTotalTotalAddresses            = New-MetricDescriptor -Name "dhcp_statistics_total_addresses_count"              -Type gauge -Help "Count of addresses managed by the selected server."
$dhcpStatisticsTotalAddressesInUse            = New-MetricDescriptor -Name "dhcp_statistics_total_addresses_in_use_count"       -Type gauge -Help "Count of addresses with a lease on the selected server."
$dhcpStatisticsTotalAddressesAvailable        = New-MetricDescriptor -Name "dhcp_statistics_total_addresses_available_count"    -Type gauge -Help "Count of addresses available in the selected server."
$dhcpStatisticsTotalPercentageInUse           = New-MetricDescriptor -Name "dhcp_statistics_total_percentage_in_use"            -Type gauge -Help "Percent of addresses in use in the selected server."
$dhcpStatisticsTotalPercentagePendingOffers   = New-MetricDescriptor -Name "dhcp_statistics_total_percentage_pending_offers"    -Type gauge -Help "Percent of addresses pending offers in the selected server."
$dhcpStatisticsTotalPercentageAvailable       = New-MetricDescriptor -Name "dhcp_statistics_total_percentage_available"         -Type gauge -Help "Percent of addresses available in the current server."
$dhcpStatisticsTotalDiscovers                 = New-MetricDescriptor -Name "dhcp_statistics_total_discovers"                    -Type counter -Help "TBD"
$dhcpStatisticsTotalOffers                    = New-MetricDescriptor -Name "dhcp_statistics_total_offers"                       -Type counter -Help "TBD"
$dhcpStatisticsTotalPendingOffers             = New-MetricDescriptor -Name "dhcp_statistics_total_pending_offers"               -Type counter -Help "TBD"
$dhcpStatisticsTotalDelayedOffers             = New-MetricDescriptor -Name "dhcp_statistics_total_delayed_offers"               -Type counter -Help "TBD"
$dhcpStatisticsTotalRequests                  = New-MetricDescriptor -Name "dhcp_statistics_total_requests"                     -Type counter -Help "TBD"
$dhcpStatisticsTotalAcks                      = New-MetricDescriptor -Name "dhcp_statistics_total_acks"                         -Type counter -Help "TBD"
$dhcpStatisticsTotalNaks                      = New-MetricDescriptor -Name "dhcp_statistics_total_naks"                         -Type counter -Help "TBD"
$dhcpStatisticsTotalDeclines                  = New-MetricDescriptor -Name "dhcp_statistics_total_declines"                     -Type counter -Help "TBD"
$dhcpStatisticsTotalReleases                  = New-MetricDescriptor -Name "dhcp_statistics_total_releases"                     -Type counter -Help "TBD"

$dhcpStatisticsFree             = New-MetricDescriptor -Name "dhcp_statistics_scope_free_count"     -Type gauge -Help "Count of free IPs in the scope." -Labels "scope_id","subnet_mask","name","state","start_range","end_range"
$dhcpStatisticsInUse            = New-MetricDescriptor -Name "dhcp_statistics_scope_in_use_count"   -Type gauge -Help "Count of used IPs in the scope." -Labels "scope_id","subnet_mask","name","state","start_range","end_range"
$dhcpStatisticsPercentageInUse  = New-MetricDescriptor -Name "dhcp_statistics_scope_in_use_percent" -Type gauge -Help "Percentage of usage of the scope." -Labels "scope_id","subnet_mask","name","state","start_range","end_range"
$dhcpStatisticsReserved         = New-MetricDescriptor -Name "dhcp_statistics_scope_reserved_count" -Type gauge -Help "Count of IP reservations in the scope." -Labels "scope_id","subnet_mask","name","state","start_range","end_range"
$dhcpStatisticsPending          = New-MetricDescriptor -Name "dhcp_statistics_scope_pending"        -Type gauge -Help "Count of pending IPs in the scope. (??)" -Labels "scope_id","subnet_mask","name","state","start_range","end_range"

function collector () {
    $serverStatistics = Get-DhcpServerv4Statistics
    $scopes = Get-DhcpServerv4Scope
    
    $free         = @()
    $inUse        = @()
    $percentInUse = @()
    $reserved     = @()
    $pending      = @()

    foreach ($scope in $scopes){
        $labels = ($scope.ScopeId, $scope.SubnetMask, $scope.Name, $scope.State, $scope.StartRange, $scope.EndRange)
        $scope_details = Get-DhcpServerv4ScopeStatistics -ScopeId $scope.ScopeId
        $free         += @{ value = $scope_details.Free            ; labels = $labels }
        $inUse        += @{ value = $scope_details.InUse           ; labels = $labels }
        $percentInUse += @{ value = $scope_details.PercentageInUse ; labels = $labels }
        $reserved     += @{ value = $scope_details.Reserved        ; labels = $labels }
        $pending      += @{ value = $scope_details.Pending         ; labels = $labels }
    }

    @(
        New-Metric -MetricDesc $dhcpStatisticsTotalTotalScopes                -Value $serverStatistics.TotalScopes               
        New-Metric -MetricDesc $dhcpStatisticsTotalScopesWithDelayConfigured  -Value $serverStatistics.ScopesWithDelayConfigured 
        New-Metric -MetricDesc $dhcpStatisticsTotalTotalAddresses             -Value $serverStatistics.TotalAddresses            
        New-Metric -MetricDesc $dhcpStatisticsTotalAddressesInUse             -Value $serverStatistics.AddressesInUse            
        New-Metric -MetricDesc $dhcpStatisticsTotalAddressesAvailable         -Value $serverStatistics.AddressesAvailable        
        New-Metric -MetricDesc $dhcpStatisticsTotalPercentageInUse            -Value $serverStatistics.PercentageInUse           
        New-Metric -MetricDesc $dhcpStatisticsTotalPercentagePendingOffers    -Value $serverStatistics.PercentagePendingOffers   
        New-Metric -MetricDesc $dhcpStatisticsTotalPercentageAvailable        -Value $serverStatistics.PercentageAvailable       
        New-Metric -MetricDesc $dhcpStatisticsTotalDiscovers                  -Value $serverStatistics.Discovers                 
        New-Metric -MetricDesc $dhcpStatisticsTotalOffers                     -Value $serverStatistics.Offers                    
        New-Metric -MetricDesc $dhcpStatisticsTotalPendingOffers              -Value $serverStatistics.PendingOffers             
        New-Metric -MetricDesc $dhcpStatisticsTotalDelayedOffers              -Value $serverStatistics.DelayedOffers             
        New-Metric -MetricDesc $dhcpStatisticsTotalRequests                   -Value $serverStatistics.Requests                  
        New-Metric -MetricDesc $dhcpStatisticsTotalAcks                       -Value $serverStatistics.Acks                      
        New-Metric -MetricDesc $dhcpStatisticsTotalNaks                       -Value $serverStatistics.Naks                      
        New-Metric -MetricDesc $dhcpStatisticsTotalDeclines                   -Value $serverStatistics.Declines                  
        New-Metric -MetricDesc $dhcpStatisticsTotalReleases                   -Value $serverStatistics.Releases                  

        foreach ($loop in $free         ){ New-Metric -MetricDesc $dhcpStatisticsFree               -Value $loop.value -Labels $loop.labels }
        foreach ($loop in $inUse        ){ New-Metric -MetricDesc $dhcpStatisticsInUse              -Value $loop.value -Labels $loop.labels }
        foreach ($loop in $percentInUse ){ New-Metric -MetricDesc $dhcpStatisticsPercentageInUse    -Value $loop.value -Labels $loop.labels }
        foreach ($loop in $reserved     ){ New-Metric -MetricDesc $dhcpStatisticsReserved           -Value $loop.value -Labels $loop.labels }
        foreach ($loop in $pending      ){ New-Metric -MetricDesc $dhcpStatisticsPending            -Value $loop.value -Labels $loop.labels }        
    )
}

$exp = New-PrometheusExporter -Port 9700
Register-Collector -Exporter $exp -Collector $Function:collector
$exp.Start()
