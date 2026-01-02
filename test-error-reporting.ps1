# Test Error Reporting Vercel API

Write-Host "Testing Vercel Error Reporting System..." -ForegroundColor Cyan
Write-Host ""

$apiUrl = "https://light-rewards-bot.vercel.app/api/report-error"
$timestamp = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$payload = @{
    error = "Test error from PowerShell script"
    stack = "at testFunction (test.ts:42:10)`n    at main (index.ts:100:5)"
    context = @{
        version = "3.5.6"
        platform = "win32"
        arch = "x64"
        nodeVersion = "v22.0.0"
        timestamp = $timestamp
        botMode = "TEST"
    }
} | ConvertTo-Json -Depth 10

Write-Host "Sending test error report..." -ForegroundColor Yellow
Write-Host "Endpoint: $apiUrl" -ForegroundColor Gray
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $payload -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response:" -ForegroundColor Cyan
    $response | ConvertTo-Json -Depth 5 | Write-Host -ForegroundColor White
    Write-Host ""
    Write-Host "Error report sent successfully!" -ForegroundColor Green
    Write-Host "Check your Discord channel for the error report" -ForegroundColor Green
    
} catch {
    Write-Host "FAILED!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error Details:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $statusCode = [int]$_.Exception.Response.StatusCode
        Write-Host "HTTP Status: $statusCode" -ForegroundColor Yellow
        
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            $reader.Close()
            Write-Host "Response Body: $responseBody" -ForegroundColor Gray
        } catch {
            Write-Host "Could not read response body" -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  1. DISCORD_ERROR_WEBHOOK_URL not set in Vercel" -ForegroundColor Gray
    Write-Host "  2. Webhook URL invalid or deleted" -ForegroundColor Gray
    Write-Host "  3. Vercel deployment not finished" -ForegroundColor Gray
}

Write-Host ""
