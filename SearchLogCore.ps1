param (
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    [Parameter(Mandatory=$true)]
    [string[]]$Patterns,
    [Parameter(Mandatory=$false)]
    [string]$StartDate,
    [Parameter(Mandatory=$false)]
    [string]$EndDate,
    [switch]$SortByDate,
    [switch]$CaseSensitive,
    [int]$ContextLines = 0,
    [string]$OutputFile
)

function Parse-DateSafely {
    param ([string]$DateString)
    if ([string]::IsNullOrWhiteSpace($DateString)) {
        return $null
    }
    if ([DateTime]::TryParse($DateString, [ref]$null)) {
        return [DateTime]::Parse($DateString)
    }
    Write-Warning "Could not parse date: $DateString. Ignoring this date filter."
    return $null
}

function Search-LogFile {
    param (
        [string]$FilePath,
        [string[]]$Patterns,
        [nullable[datetime]]$StartDate,
        [nullable[datetime]]$EndDate,
        [bool]$CaseSensitive,
        [int]$ContextLines
    )

    $regexOptions = [System.Text.RegularExpressions.RegexOptions]::Compiled
    if (-not $CaseSensitive) {
        $regexOptions = $regexOptions -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    }

    $dateRegex = [regex]::new('\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', $regexOptions)
    $patternRegexes = $Patterns | ForEach-Object { [regex]::new($_, $regexOptions) }

    $reader = [System.IO.File]::OpenText($FilePath)
    $results = @()
    $lineNumber = 0
    $buffer = New-Object System.Collections.Generic.List[string]

    while (-not $reader.EndOfStream) {
        $line = $reader.ReadLine()
        $lineNumber++

        $dateMatch = $dateRegex.Match($line)
        if ($dateMatch.Success) {
            $date = [datetime]::ParseExact($dateMatch.Value, "yyyy-MM-dd HH:mm:ss", $null)
            
            if ((!$StartDate -or $date -ge $StartDate) -and (!$EndDate -or $date -le $EndDate)) {
                foreach ($regex in $patternRegexes) {
                    if ($regex.IsMatch($line)) {
                        $contextBefore = @($buffer.ToArray())
                        $contextAfter = @()
                        for ($i = 0; $i -lt $ContextLines; $i++) {
                            if (-not $reader.EndOfStream) {
                                $contextAfter += $reader.ReadLine()
                                $lineNumber++
                            }
                        }

                        $results += [PSCustomObject]@{
                            Date = $date
                            LineNumber = $lineNumber - $contextBefore.Count
                            Line = $line
                            ContextBefore = $contextBefore
                            ContextAfter = $contextAfter
                        }
                        break
                    }
                }
            }
        }

        $buffer.Add($line)
        if ($buffer.Count -gt $ContextLines) {
            $buffer.RemoveAt(0)
        }

        if ($lineNumber % 1000 -eq 0) {
            Write-Progress -Activity "Searching log file" -Status "Processed $lineNumber lines" -PercentComplete (($lineNumber / $reader.BaseStream.Length) * 100)
        }
    }

    $reader.Close()
    return $results
}

try {
    if (-not (Test-Path $FilePath)) {
        throw "File not found: $FilePath"
    }

    $parsedStartDate = Parse-DateSafely $StartDate
    $parsedEndDate = Parse-DateSafely $EndDate

    $results = Search-LogFile -FilePath $FilePath -Patterns $Patterns -StartDate $parsedStartDate -EndDate $parsedEndDate -CaseSensitive $CaseSensitive -ContextLines $ContextLines

    if ($SortByDate) {
        $results = $results | Sort-Object Date
    }

    $output = $results | ForEach-Object {
        $contextBefore = $_.ContextBefore -join "`n"
        $contextAfter = $_.ContextAfter -join "`n"
        @"
Date: $($_.Date.ToString("yyyy-MM-dd HH:mm:ss"))
Line Number: $($_.LineNumber)
$contextBefore
>> $($_.Line)
$contextAfter
--------------------------------------------------

"@
    }

    $output += "Total matches found: $($results.Count)"

    if ($OutputFile) {
        $output | Out-File -FilePath $OutputFile -Encoding utf8
        "Results written to $OutputFile"
    }
    else {
        $output
    }
}
catch {
    "An error occurred: $_"
}
finally {
    Write-Progress -Activity "Searching log file" -Completed
}