$timesToRun = 0
$topSellerList = @()
$topSaleValue = 1500000

do {
    Clear-Host
    Get-Date | Write-Host -f yellow
    $webData = Invoke-WebRequest -URI 'http://edtools.ddns.net/trd.php?f=json&cid=276'
    $x = ($webData | ConvertFrom-Json) | Select-Object -First 10
    $x | Format-Table `
        system,`
        station,`
        @{ Label = "prices"
            Expression =
            {
                switch ($_.price | foreach-object { $_/1 } )
                {
                    {($_ -ge 1200000)} { $color = "32"; break }
                    {($_ -lt 1200000)} { $color = "91"; break }
                    default { $color = "0" }
                }
                $e = [char]27
                "$e[${color}m$($_.price)${e}[0m"
            }
        },`
        @{ Label = "demand"
            Expression =
            {
                switch ($_.demand | foreach-object { $_/1 } )
                {
                    {($_ -ge 1000)} { $color = "32"; break }
                    {($_ -lt 1000)} { $color = "91"; break }
                    default { $color = "0" }
                }
                $e = [char]27
                "$e[${color}m$($_.demand)${e}[0m"
            }
        },`
        pad,`
        @{ Label = "distance"
            Expression =
            {
                $borranX = "123.03125"
                $borranY = "-0.25"
                $borranZ = "2.84375"

                $distance = 0

                switch ($_.coords | foreach-object { 
                    [Math]::Sqrt([Math]::Pow($_.x - $borranX, 2) +`
                                 [Math]::Pow($_.y - $borranY, 2) +`
                                 [Math]::Pow($_.z - $borranZ, 2))
                                })
                {
                    {($_ -lt 100)} { $color = "32"; $distance = $_; break }
                    {($_ -lt 200)} { $color = "93"; $distance = $_; break }
                    {($_ -ge 200)} { $color = "91"; $distance = $_; break }
                    default { $color = "0" }
                }
                $e = [char]27
                $distance = $distance.ToString("#.##")
                "$e[${color}m$($distance)${e}[0m"
            }
        }


        $x | ForEach-Object {
            if ((($_.price/1) -ge $topSaleValue) -and ($topSellerList.station -notcontains $_.station)) {
                #write-host $_
                $topSellerList += $_
            }
            elseif ((($_.price/1) -ge $topSaleValue) -and ($topSellerList.station -contains $_.station)) {
                $currentObject = $_

                $topSellerList | ForEach-Object { 
                    if ($_.station -match $currentObject.station) {
                        if (($_.price/1) -lt ($currentObject.price/1)) {
                            $topSellerList = $topSellerList -replace $_, $currentObject
                        }
                    } 
                }
            }
        }
    
    
    Write-Host "`nSellers over $topSaleValue while running:"
    $topSellerList | Format-Table `
        system,`
        station,`
        @{ Label = "prices"
            Expression =
            {
                switch ($_.price | foreach-object { $_/1 } )
                {
                    {($_ -ge 1200000)} { $color = "32"; break }
                    {($_ -lt 1200000)} { $color = "91"; break }
                    default { $color = "0" }
                }
                $e = [char]27
                "$e[${color}m$($_.price)${e}[0m"
            }
        },`
        @{ Label = "demand"
            Expression =
            {
                switch ($_.demand | foreach-object { $_/1 } )
                {
                    {($_ -ge 1000)} { $color = "32"; break }
                    {($_ -lt 1000)} { $color = "91"; break }
                    default { $color = "0" }
                }
                $e = [char]27
                "$e[${color}m$($_.demand)${e}[0m"
            }
        },`
        pad,`
        @{ Label = "distance"
            Expression =
            {
                $borranX = "123.03125"
                $borranY = "-0.25"
                $borranZ = "2.84375"

                $distance = 0

                switch ($_.coords | foreach-object { 
                    [Math]::Sqrt([Math]::Pow($_.x - $borranX, 2) +`
                                 [Math]::Pow($_.y - $borranY, 2) +`
                                 [Math]::Pow($_.z - $borranZ, 2))
                                })
                {
                    {($_ -lt 100)} { $color = "32"; $distance = $_; break }
                    {($_ -lt 200)} { $color = "93"; $distance = $_; break }
                    {($_ -ge 200)} { $color = "91"; $distance = $_; break }
                    default { $color = "0" }
                }
                $e = [char]27
                $distance = $distance.ToString("#.##")
                "$e[${color}m$($distance)${e}[0m"
            }
        }
    
    Start-Sleep -s 120
}
while ($timesToRun -eq 0)