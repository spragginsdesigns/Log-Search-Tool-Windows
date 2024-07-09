## Log Search Tool

**Description:**  
The Log Search Tool is a user-friendly GUI application designed to leverage PowerShell's `Get-Content` and pattern matching capabilities for easy extraction of specific data from log files. This tool simplifies the process of searching through log files for specific patterns, enhancing productivity and efficiency.

### Features:
- **Intuitive GUI:** Simplifies log file searches with a straightforward graphical user interface.
- **Pattern Matching:** Search for multiple patterns within log files using comma-separated values.
- **Date Range Filtering:** Filter log entries by start and end dates.
- **Sorting:** Option to sort results by date.
- **Easy File Operations:** Browse for log files, copy search results to the clipboard, and save results to a file with just a few clicks.
- **Modern Dark Mode:** Enhanced dark mode with a sleek, Windows 11-style aesthetic.

### Installation:
1. Download the script file `LogSearchTool.ps1`.
2. Ensure you have PowerShell installed (version 5.1 or later recommended).
3. Open a PowerShell prompt and navigate to the directory containing `LogSearchTool.ps1`.
4. Run the script by executing `.\LogSearchTool.ps1`.

### Usage:
1. **Log File Path:** Click 'Browse' to select the log file you want to search.
2. **Search Patterns:** Enter the patterns you want to search for, separated by commas.
3. **Date Range:** Select the start and end dates to filter log entries.
4. **Sort by Date:** Check the box to sort the results by date.
5. Click 'Search' to display the results.
6. Use 'Copy to Clipboard' to copy the results or 'Save to File' to save them.

### Icon:
To get an icon for your tool, you can use a free icon from websites such as:
- [Flaticon](https://www.flaticon.com/)
- [Icons8](https://icons8.com/icons)
- [Iconfinder](https://www.iconfinder.com/)

Search for terms like "log", "file search", "search", or "magnifying glass" to find a suitable icon. Once you have downloaded the icon in `.ico` format, you can include it in your PowerShell script using the following method:

1. Save the icon file in the same directory as your script.
2. Modify your script to include the icon:

```powershell
$iconPath = "$PSScriptRoot\icon.ico"
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
```

### Example:
Here's an example of the script incorporating the icon setup:

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Define improved dark mode colors
$darkBackground = [System.Drawing.ColorTranslator]::FromHtml("#121212")
$darkControl = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$darkButton = [System.Drawing.ColorTranslator]::FromHtml("#2A2A2A")
$lightText = [System.Drawing.ColorTranslator]::FromHtml("#E0E0E0")
$accentColor = [System.Drawing.ColorTranslator]::FromHtml("#3700B3")

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Log Search Tool'
$form.Size = New-Object System.Drawing.Size(720, 620)
$form.BackColor = $darkBackground
$form.ForeColor = $lightText
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.TopMost = $true

# Set the icon
$iconPath = "$PSScriptRoot\icon.ico"
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)

function Set-ControlTheme($control, [System.Drawing.Color]$backColor) {
    $control.BackColor = $backColor
    $control.ForeColor = $lightText
    if ($control -is [System.Windows.Forms.Button]) {
        $control.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $control.FlatAppearance.BorderColor = $accentColor
        $control.FlatAppearance.BorderSize = 1
        $control.FlatAppearance.MouseOverBackColor = $accentColor
        $control.Cursor = [System.Windows.Forms.Cursors]::Hand
    }
    elseif ($control -is [System.Windows.Forms.TextBox]) {
        $control.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    }
}

# Rest of your script follows...

$form.ShowDialog()
```
