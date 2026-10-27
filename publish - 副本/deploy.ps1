# Publish the game to the public site (surge). No login needed.
# Usage: after editing jujutsu-fight\index.html -> run sync.ps1, then this script.
param([string]$Domain = 'jujutsu-fight-play.surge.sh')

$root  = $PSScriptRoot
$email = 'jj-fight-play@surge.sh'
$pass  = 'Sukuna2026!bf'

# Exchange the account for a publish token (avoids interactive prompts)
$b64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$email`:$pass"))
$r   = Invoke-RestMethod -Uri 'https://surge.surge.sh/token' -Method Post `
         -Headers @{ Authorization = "Basic $b64" } `
         -ContentType 'application/json' -Body '{}' -TimeoutSec 30
$env:SURGE_LOGIN = $email
$env:SURGE_TOKEN = $r.token

# Locate surge.cmd next to node.exe (node is usually not on PATH here)
$sg   = $null
$node = @()
try { $cmd = Get-Command node -ErrorAction SilentlyContinue; if ($cmd) { $node += $cmd.Source } } catch {}
$node += 'C:\Users\zhaol\.workbuddy\binaries\node\versions\20.18.0.installing.63668.__extract_temp__\node-v20.18.0-win-x64\node.exe'
foreach ($n in $node) {
  if (-not $n) { continue }
  $cand = Join-Path (Split-Path $n) 'surge.cmd'
  if (Test-Path $cand) { $sg = $cand; break }
}
if (-not $sg) { Write-Host "surge not found - run: npm i -g surge" -ForegroundColor Red; exit 1 }

& $sg --project $root --domain $Domain
Write-Host ""
Write-Host "Live at: https://$Domain" -ForegroundColor Cyan
