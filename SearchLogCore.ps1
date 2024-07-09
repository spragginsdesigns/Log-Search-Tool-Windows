    param (
    [string]$FilePath,
    [string[]]$Patterns,
    [datetime]$StartDate,
    [datetime]$EndDate,
    [switch]$SortByDate
)

try {
    if (-not (Test-Path $FilePath)) {
        throw "File not found: $FilePath"
    }

    $content = Get-Content -Path $FilePath
    $results = @()
    $totalLines = $content.Count

    for ($i = 0; $i -lt $totalLines; $i++) {
        $line = $content[$i]
        $percentComplete = ($i / $totalLines) * 100
        Write-Progress -Activity "Searching log file" -Status "Progress:" -PercentComplete $percentComplete

        foreach ($pattern in $Patterns) {
            if ($line -match $pattern) {
                $dateMatch = [regex]::Match($line, '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')
                if ($dateMatch.Success) {
                    $date = [datetime]::ParseExact($dateMatch.Value, "yyyy-MM-dd HH:mm:ss", $null)
                    if ((!$StartDate -or $date -ge $StartDate) -and (!$EndDate -or $date -le $EndDate)) {
                        $results += [PSCustomObject]@{
                            Date = $date
                            Line = $line
                        }
                    }
                }
            }
        }
    }

    if ($SortByDate) {
        $results = $results | Sort-Object Date
    }

    $outputString = $results | ForEach-Object { "- " + $_.Date.ToString("yyyy-MM-dd HH:mm:ss") + " " + $_.Line + "`r`n`r`n" }
    $outputString += "Total matches found: $($results.Count)"

    return $outputString
}
catch {
    return "An error occurred: $_"
}
finally {
    Write-Progress -Activity "Searching log file" -Completed
}