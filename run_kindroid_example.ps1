ב Wooden.Ghost Kindroid Runner
# PowerShell script to run the correct kindroidadapter example
Write-Host "●○●○● Wooden.Ghost Kindroid Example Runner ●○●○●" -ForegroundColor Cyan
Write-Host ""
# Check if we're in the correct directory
if (-not (Test-Path "kindroidadapter/example.py")) {
Write-Host "✗ Error: kindroidadapter/example.py not found" -ForegroundColor Red
Write-Host "Make sure you're running this from the woodenghost root directory" -ForegroundColor Yellow
exit 1
}
Write-Host "♤♠︎ Running kindroidadapter example…" -ForegroundColor Green
Write-Host "Note: The correct filename is 'example.py', not 'example_usage.py'" -ForegroundColor Yellow
Write-Host ""
# Run the example
python kindroidadapter/example.py
Write-Host ""
Write-Host "◇◆◇ Example execution completed ◇◆◇" -ForegroundColor Magenta