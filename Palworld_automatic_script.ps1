# Palworld simple automatic script
# Note: This script loops indefinitely until it is manually stopped.
# Set program execution path and parameters
$exePath = "C:\Program Files\PalServer\steam\steamapps\common\PalServer\PalServer.exe"
$arguments = "-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"
# Set the auto-save path
$sourcePath = "C:\Program Files\PalServer\steam\steamapps\common\PalServer\Pal\Saved\SaveGames\0"
$destinationPath = "C:\Users\Administrator\Desktop\save"

# Restart the program every 4 hours
while ($true) {
	Start-Process $exePath -ArgumentList $arguments

	# Start-Sleep -Seconds ($hours * 60 * 60)
	$hours = 4
	for ($i = 0; $i -lt $hours; $i++) {
		Start-Sleep -Seconds (60 * 60)
		# Get the current time
		$currentTime = Get-Date
		Write-Host "Time now: $currentTime"
		$newDirectoryName = $currentTime.ToString("yyyyMMddHHmmss")
		$newDestinationPath = Join-Path -Path $destinationPath -ChildPath $newDirectoryName
		# Copy folder
		Copy-Item -Path $sourcePath -Destination $newDestinationPath -Recurse -Force
		Write-Host "The file has been copied to the target location: $newDestinationPath"
	}

	$processes = Get-Process | Where-Object { $_.Name -like "*Pal*" }
	Write-Host "$processes"
	foreach ($process in $processes) {
		Stop-Process -InputObject $process -Force
		Write-Host "Process $($process.Name) (ID: $($process.Id)) has been terminated"
	}
}
