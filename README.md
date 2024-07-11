# Log Search Tool

## Overview

The Log Search Tool is a powerful GUI application built with PowerShell that allows you to search through log files efficiently. It provides a user-friendly interface for specifying search patterns, viewing results, and exporting findings.

## Installation

1. Ensure you have PowerShell installed on your Windows machine.
2. Download both `LogSearchTool.ps1` and `SearchLogCore.ps1` files to the same directory.
3. Optionally, place an `icon.ico` file in the same directory for a custom application icon.

## How to Use

### Launching the Application

1. Right-click on `LogSearchTool.ps1` and select "Run with PowerShell".
2. The Log Search Tool GUI will appear.

### Main Interface

The GUI consists of several key elements:

- **Log File Path**: A text box to enter the path of the log file you want to search.
- **Browse Button**: Allows you to navigate and select a log file graphically.
- **Search Patterns**: A text box where you can enter one or more search patterns.
- **Search Button**: Initiates the search process.
- **Copy to Clipboard Button**: Copies the search results to your clipboard.
- **Save to File Button**: Allows you to save the search results to a text file.
- **Output Box**: Displays the search results.

### Performing a Search

1. **Select Log File**:
   - Type the full path to your log file in the "Log File Path" text box, or
   - Click the "Browse" button to navigate to and select your log file.

2. **Enter Search Patterns**:
   - In the "Search Patterns" text box, enter one or more patterns you want to search for.
   - Separate multiple patterns with commas.
   - Example: `ERROR,WARNING,CRITICAL`

3. **Execute Search**:
   - Click the "Search" button to start the search process.
   - The tool will scan the specified log file for the given patterns.
   - Results will be displayed in the output box below.

### Understanding Search Results

The search results will show:
- The date and time of each matched log entry.
- The line number in the log file where the match was found.
- The full text of the matched line.

### Working with Results

- **Viewing**: Scroll through the output box to review all matches.
- **Copying**: Click "Copy to Clipboard" to copy all results for pasting elsewhere.
- **Saving**: Click "Save to File" to export the results to a text file of your choice.

## Tips for Effective Searching

1. **Use Specific Patterns**: The more specific your search patterns, the more precise your results will be.

2. **Multiple Patterns**: Use multiple patterns separated by commas to search for different types of logs simultaneously.

3. **Regular Expressions**: The search supports regular expressions for advanced pattern matching. For example:
   - `Error.*Exception`: Finds lines containing "Error" followed by "Exception".
   - `\d{4}-\d{2}-\d{2}`: Matches date patterns like "2023-07-10".

4. **Case Sensitivity**: The search is case-sensitive by default. Be mindful of uppercase and lowercase in your patterns.

5. **Large Log Files**: For very large log files, the search might take some time. Be patient and avoid interacting with the GUI until the search completes.

## Troubleshooting

- If the search doesn't return expected results, double-check your file path and search patterns.
- Ensure that `SearchLogCore.ps1` is in the same directory as `LogSearchTool.ps1`.
- If you encounter any PowerShell execution policy issues, you may need to adjust your execution policy or run PowerShell as an administrator.

## Additional Notes

- The tool is designed with a dark mode interface for reduced eye strain during extended use.
- The minimum window size is set to 720x580 pixels to ensure all elements remain visible and functional.

By following this guide, you should be able to effectively use the Log Search Tool to analyze your log files quickly and efficiently. Happy searching!
