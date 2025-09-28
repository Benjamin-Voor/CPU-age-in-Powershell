$CPU_data = Import-Csv -Path .\cpu_manufacture_date.csv -Delimiter ';'
# build a lookup table
$CPU_ReleaseDateLookup = [hashtable]::new()
foreach ($CD_Item in $CPU_Data)
{
	$CPU_ReleaseDateLookup.Add($CD_Item.Model, $CD_Item.ReleaseDate)
}
# the CIM cmdlets are a tad faster than the WMI cmdlets - and are not deprecated
$CPU_Name = (Get-CimInstance -ClassName CIM_Processor).Name
if($CPU_ReleaseDateLookup[$CPU_Name])
{
	$cpu_release_date = $CPU_ReleaseDateLookup[$CPU_Name]
	'The release date for [ {0} ] is [ {1} ].' -f $CPU_Name, $cpu_release_date
	$cpu_year = (-split $cpu_release_date)[1]
	if(!$cpu_year) {
		$cpu_year = $cpu_release_date
	}
	$current_year = (Get-Date).year
	$how_old = $current_year - $cpu_year
	'Your CPU is {0} years old' -f $how_old
} else {
	"CPU not found in .csv. Please add your CPU and its Launch Date, found on CPUBenchmark.net. Intel processors can also be found on Intel's own website, such as  https://www.intel.com/content/www/us/en/products/details/processors.html"
	$new_release_date = Read-Host "Please input your CPU's release date in the form `"Q`# 20`#`#, such as `"Q3 2017`". `nTo quit without making a new entry, close this window or press `"ctrl+c`" on your keyboard.`n"
	("{0};{1}" -f $CPU_name, $new_release_date) | add-content -Path .\manufacture_date.csv
}
Read-Host -Prompt "Press Enter to exit"