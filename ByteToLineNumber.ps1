# Check if the required arguments are provided
if ($args.Count -lt 2) {
    Write-Output "Usage: script.ps1 <FilePath> <HexOffset>"
    Write-Output "Example: script.ps1 C:\Scripts\test.ps1 0x1DCD2"
    exit
}

# Get the file path and hex offset from the command line arguments
$filePath = $args[0]
$hexOffset = $args[1]

# Validate the file path
if (-not (Test-Path -Path $filePath)) {
    Write-Output "Error: The file '$filePath' does not exist."
    exit
}

# Validate the hex offset
if (-not ($hexOffset -match "^0x[0-9A-Fa-f]+$")) {
    Write-Output "Error: The offset '$hexOffset' is not a valid hexadecimal value."
    exit
}

# Convert the hex offset to a decimal value
$offset = [Convert]::ToInt32($hexOffset, 16)

# Read the file as bytes
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)

# Read the file as text to count lines
$fileLines = Get-Content -Path $filePath

# Initialize the running byte counter
$currentByteCount = 0

# Iterate through each line to find the corresponding line number
for ($i = 0; $i -lt $fileLines.Count; $i++) {
    $lineBytes = [System.Text.Encoding]::UTF8.GetBytes($fileLines[$i] + "`n")
    $currentByteCount += $lineBytes.Length

    if ($currentByteCount -gt $offset) {
        Write-Output "The offset $hexOffset corresponds to line number $($i + 1)."
        exit
    }
}

# If the loop finishes without finding the offset
if ($currentByteCount -le $offset) {
    Write-Output "The offset $hexOffset exceeds the total file size."
}
