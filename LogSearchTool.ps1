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
$form.Size = New-Object System.Drawing.Size(720, 580)
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

$labelFilePath = New-Object System.Windows.Forms.Label
$labelFilePath.Location = New-Object System.Drawing.Point(20, 20)
$labelFilePath.Size = New-Object System.Drawing.Size(280, 20)
$labelFilePath.Text = 'Log File Path:'
$form.Controls.Add($labelFilePath)

$textBoxFilePath = New-Object System.Windows.Forms.TextBox
$textBoxFilePath.Location = New-Object System.Drawing.Point(20, 45)
$textBoxFilePath.Size = New-Object System.Drawing.Size(550, 25)
Set-ControlTheme $textBoxFilePath $darkControl
$form.Controls.Add($textBoxFilePath)

$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Location = New-Object System.Drawing.Point(580, 44)
$buttonBrowse.Size = New-Object System.Drawing.Size(100, 27)
$buttonBrowse.Text = 'Browse'
Set-ControlTheme $buttonBrowse $darkButton
$buttonBrowse.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $textBoxFilePath.Text = $openFileDialog.FileName
    }
})
$form.Controls.Add($buttonBrowse)

$labelPatterns = New-Object System.Windows.Forms.Label
$labelPatterns.Location = New-Object System.Drawing.Point(20, 80)
$labelPatterns.Size = New-Object System.Drawing.Size(280, 20)
$labelPatterns.Text = 'Search Patterns (comma-separated):'
$form.Controls.Add($labelPatterns)

$textBoxPatterns = New-Object System.Windows.Forms.TextBox
$textBoxPatterns.Location = New-Object System.Drawing.Point(20, 105)
$textBoxPatterns.Size = New-Object System.Drawing.Size(660, 25)
$textBoxPatterns.Text = 'DEBUG:root:Raw video data:,Relevance scores'
Set-ControlTheme $textBoxPatterns $darkControl
$form.Controls.Add($textBoxPatterns)

$buttonSearch = New-Object System.Windows.Forms.Button
$buttonSearch.Location = New-Object System.Drawing.Point(20, 140)
$buttonSearch.Size = New-Object System.Drawing.Size(100, 30)
$buttonSearch.Text = 'Search'
Set-ControlTheme $buttonSearch $darkButton
$buttonSearch.Add_Click({
    $outputBox.Clear()
    $filePath = $textBoxFilePath.Text
    $patterns = $textBoxPatterns.Text -split ','
    $result = & "$PSScriptRoot\SearchLogCore.ps1" -FilePath $filePath -Patterns $patterns
    $outputBox.Text = $result
})
$form.Controls.Add($buttonSearch)

$buttonCopyToClipboard = New-Object System.Windows.Forms.Button
$buttonCopyToClipboard.Location = New-Object System.Drawing.Point(130, 140)
$buttonCopyToClipboard.Size = New-Object System.Drawing.Size(130, 30)
$buttonCopyToClipboard.Text = 'Copy to Clipboard'
Set-ControlTheme $buttonCopyToClipboard $darkButton
$buttonCopyToClipboard.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($outputBox.Text)
})
$form.Controls.Add($buttonCopyToClipboard)

$buttonSaveToFile = New-Object System.Windows.Forms.Button
$buttonSaveToFile.Location = New-Object System.Drawing.Point(270, 140)
$buttonSaveToFile.Size = New-Object System.Drawing.Size(100, 30)
$buttonSaveToFile.Text = 'Save to File'
Set-ControlTheme $buttonSaveToFile $darkButton
$buttonSaveToFile.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
    if ($saveFileDialog.ShowDialog() -eq 'OK') {
        $outputBox.Text | Out-File -FilePath $saveFileDialog.FileName
    }
})
$form.Controls.Add($buttonSaveToFile)

$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(20, 180)
$outputBox.Size = New-Object System.Drawing.Size(660, 350)
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$outputBox.MultiLine = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.ReadOnly = $true
Set-ControlTheme $outputBox $darkControl
$form.Controls.Add($outputBox)

$form.ShowDialog()
