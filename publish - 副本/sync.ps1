# PowerShell：把最新的游戏同步到发布目录（然后去 GitHub 网页覆盖上传 index.html 即可更新）
$src = Join-Path $PSScriptRoot '..\index.html'
$dst = Join-Path $PSScriptRoot 'index.html'
if (-not (Test-Path $src)) { Write-Host "找不到 $src" -ForegroundColor Red; exit 1 }
Copy-Item $src $dst -Force
Write-Host "已同步 → $dst" -ForegroundColor Green
Write-Host "下一步：在 GitHub 仓库里 Upload files 覆盖同名 index.html，Pages 会自动重新上线。" -ForegroundColor Cyan
