##########################################################
#
# Installed Software Query
# Greg Bomkamp - The Ohio State University - 2017
#
##########################################################

# Software to query
$softwareName = Read-Host -Prompt 'Input the software name: '
# Hostnames TXT Location
$hostnamestxt = Read-Host -Prompt 'Input the name of the file containing hosts seperated by newlines (absolute file path if not contained in same folder as script): '
# Destination file for results
$outputtxt = ‘.\softwareCheckResults.txt‘


##########################################################
# Begin Executing Script
##########################################################

#Get list of all computers from provided file
$computers = get-content “$hostnamestxt”

write-host “———————————————-”
write-host “Scanning hostnames for $softwareName from $hostnamestxt…”
write-host “———————————————-”

#date output file
get-date | Out-File "$outputtxt"

#Count through machines when queried
$num = 0
$totlines = gc $hostnamestxt | Measure-Object
$totlines = $totlines.Count

#loop through each computer and query software given
foreach($computer in $computers)
{
	$num++
	write-host "Computer $num of $totlines"

	#psinfo will check if the software is install on $computer and store the result
	$res = psinfo -s \\$computer | select-string -pattern "$softwareName"

	#online and can communicate
	if($lastexitcode -eq 0)
	{
		#print whether the software was found or not
		if($res -eq $null)
		{
			echo “$computer		software not found” | Out-File -Append "$outputtxt"
		}
		else
		{
			echo “$computer		$softwareName FOUND” | Out-File -Append "$outputtxt"
		}
	}
	#cannot communicate with machine, print this to file
	else
	{
		echo "$computer is OFFLINE/DID NOT RESPOND" | Out-File -Append "$outputtxt"
		write-host "$computer is OFFLINE/DID NOT RESPOND"
	}
}
write-host “———————————————-”
write-host “Script has completed please check output.”
write-host "Hosts with file output location – "$outputtxt""
write-host "———————————————-"
