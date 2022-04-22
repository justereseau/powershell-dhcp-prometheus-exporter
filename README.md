# PowerShell Prometheus Client

This is a prometheus exporter wor Windows DHCP.

## Installing

```powershell
Install-Module -Name PrometheusExporter
```

## Example

If you now open http://localhost:9700 in your browser, you will see the metrics displayed.

```
# HELP dhcp_statistics_total_scopes_count Count of scopes in the selected server.
# TYPE dhcp_statistics_total_scopes_count gauge
dhcp_statistics_total_scopes_count 2
# HELP dhcp_statistics_total_scopes_with_delay_count Count of delayed scopes in the selected server.
# TYPE dhcp_statistics_total_scopes_with_delay_count gauge
dhcp_statistics_total_scopes_with_delay_count 0
# HELP dhcp_statistics_total_addresses_count Count of addresses managed by the selected server.
# TYPE dhcp_statistics_total_addresses_count gauge
dhcp_statistics_total_addresses_count 482
# HELP dhcp_statistics_total_addresses_in_use_count Count of addresses with a lease on the selected server.
# TYPE dhcp_statistics_total_addresses_in_use_count gauge
dhcp_statistics_total_addresses_in_use_count 0
# HELP dhcp_statistics_total_addresses_available_count Count of addresses available in the selected server.
# TYPE dhcp_statistics_total_addresses_available_count gauge
dhcp_statistics_total_addresses_available_count 482
# HELP dhcp_statistics_total_percentage_in_use Percent of addresses in use in the selected server.
# TYPE dhcp_statistics_total_percentage_in_use gauge
dhcp_statistics_total_percentage_in_use 0
# HELP dhcp_statistics_total_percentage_pending_offers Percent of addresses pending offers in the selected server.
# TYPE dhcp_statistics_total_percentage_pending_offers gauge
dhcp_statistics_total_percentage_pending_offers 0
# HELP dhcp_statistics_total_percentage_available Percent of addresses available in the current server.
# TYPE dhcp_statistics_total_percentage_available gauge
dhcp_statistics_total_percentage_available 100
# HELP dhcp_statistics_total_discovers TBD
# TYPE dhcp_statistics_total_discovers counter
dhcp_statistics_total_discovers 22
# HELP dhcp_statistics_total_offers TBD
# TYPE dhcp_statistics_total_offers counter
dhcp_statistics_total_offers 0
# HELP dhcp_statistics_total_pending_offers TBD
# TYPE dhcp_statistics_total_pending_offers counter
dhcp_statistics_total_pending_offers 0
# HELP dhcp_statistics_total_delayed_offers TBD
# TYPE dhcp_statistics_total_delayed_offers counter
dhcp_statistics_total_delayed_offers 0
# HELP dhcp_statistics_total_requests TBD
# TYPE dhcp_statistics_total_requests counter
dhcp_statistics_total_requests 0
# HELP dhcp_statistics_total_acks TBD
# TYPE dhcp_statistics_total_acks counter
dhcp_statistics_total_acks 0
# HELP dhcp_statistics_total_naks TBD
# TYPE dhcp_statistics_total_naks counter
dhcp_statistics_total_naks 0
# HELP dhcp_statistics_total_declines TBD
# TYPE dhcp_statistics_total_declines counter
dhcp_statistics_total_declines 0
# HELP dhcp_statistics_total_releases TBD
# TYPE dhcp_statistics_total_releases counter
dhcp_statistics_total_releases 0
# HELP dhcp_statistics_scope_free_count Count of free IPs in the scope.
# TYPE dhcp_statistics_scope_free_count gauge
dhcp_statistics_scope_free_count{scope_id="10.0.1.0",subnet_mask="255.255.255.0",name="Test1",state="Active",start_range="10.0.1.10",end_range="10.0.1.250"} 241
dhcp_statistics_scope_free_count{scope_id="10.0.2.0",subnet_mask="255.255.255.0",name="Tets2",state="Active",start_range="10.0.2.10",end_range="10.0.2.250"} 241
# HELP dhcp_statistics_scope_in_use_count Count of used IPs in the scope.
# TYPE dhcp_statistics_scope_in_use_count gauge
dhcp_statistics_scope_in_use_count{scope_id="10.0.1.0",subnet_mask="255.255.255.0",name="Test1",state="Active",start_range="10.0.1.10",end_range="10.0.1.250"} 0
dhcp_statistics_scope_in_use_count{scope_id="10.0.2.0",subnet_mask="255.255.255.0",name="Tets2",state="Active",start_range="10.0.2.10",end_range="10.0.2.250"} 0
# HELP dhcp_statistics_scope_in_use_percent Percentage of usage of the scope.
# TYPE dhcp_statistics_scope_in_use_percent gauge
dhcp_statistics_scope_in_use_percent{scope_id="10.0.1.0",subnet_mask="255.255.255.0",name="Test1",state="Active",start_range="10.0.1.10",end_range="10.0.1.250"} 0
dhcp_statistics_scope_in_use_percent{scope_id="10.0.2.0",subnet_mask="255.255.255.0",name="Tets2",state="Active",start_range="10.0.2.10",end_range="10.0.2.250"} 0
# HELP dhcp_statistics_scope_reserved_count Count of IP reservations in the scope.
# TYPE dhcp_statistics_scope_reserved_count gauge
dhcp_statistics_scope_reserved_count{scope_id="10.0.1.0",subnet_mask="255.255.255.0",name="Test1",state="Active",start_range="10.0.1.10",end_range="10.0.1.250"} 0
dhcp_statistics_scope_reserved_count{scope_id="10.0.2.0",subnet_mask="255.255.255.0",name="Tets2",state="Active",start_range="10.0.2.10",end_range="10.0.2.250"} 0
# HELP dhcp_statistics_scope_pending Count of pending IPs in the scope. (??)
# TYPE dhcp_statistics_scope_pending gauge
dhcp_statistics_scope_pending{scope_id="10.0.1.0",subnet_mask="255.255.255.0",name="Test1",state="Active",start_range="10.0.1.10",end_range="10.0.1.250"} 0
dhcp_statistics_scope_pending{scope_id="10.0.2.0",subnet_mask="255.255.255.0",name="Tets2",state="Active",start_range="10.0.2.10",end_range="10.0.2.250"} 0
```

## Running as a service

Running a powershell script as a windows service is possible by using [NSSM](https://nssm.cc/download).

```
choco install nssm
```

Use the snippet below to install it as a service:

```powershell
$serviceName = 'DHCP Exporter'
$nssm = (Get-Command nssm).Source
$powershell = (Get-Command powershell).Source
$scriptPath = 'c:\Program Files\PrometheusExporters\powershell-dhcp-prometheus-exporter\dhcp_exporter.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File """{0}"""' -f $scriptPath

& $nssm install $serviceName $powershell $arguments
Start-Service $serviceName

# Substitute the port below with the one you picked for your exporter
New-NetFirewallRule -DisplayName $serviceName -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9700
```
