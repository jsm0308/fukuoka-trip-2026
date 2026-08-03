$ErrorActionPreference = 'Stop'

$siteRoot = $PSScriptRoot
$desktopRoot = Split-Path -Parent $siteRoot
$publicRoot = Join-Path $siteRoot 'public'
$sourcePlan = Join-Path $desktopRoot '후쿠오카 계획.html'
$sourceSummary = Join-Path $desktopRoot '후쿠오카_친구공유용_선택정리.html'
$sourceAssets = Join-Path $desktopRoot 'fukuoka_itinerary_2026-08-09_assets'
$targetAssets = Join-Path $publicRoot 'fukuoka_itinerary_2026-08-09_assets'

foreach ($requiredPath in @($sourcePlan, $sourceSummary, $sourceAssets)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "필요한 원본을 찾지 못했습니다: $requiredPath"
    }
}

New-Item -ItemType Directory -Force -Path $publicRoot, $targetAssets | Out-Null
Copy-Item -LiteralPath $sourcePlan -Destination (Join-Path $publicRoot 'index.html') -Force
Copy-Item -LiteralPath $sourceSummary -Destination (Join-Path $publicRoot 'summary.html') -Force
Copy-Item -Path (Join-Path $sourceAssets '*') -Destination $targetAssets -Recurse -Force

$htmlFiles = Get-ChildItem -LiteralPath $publicRoot -Filter '*.html' -File -Recurse
foreach ($file in $htmlFiles) {
    $html = Get-Content -Raw -Encoding utf8 -LiteralPath $file.FullName
    $html = $html.Replace('라쿠텐 STAY 하카타 기온 502', '라쿠텐 STAY 하카타 기온')
    $html = $html.Replace('502호·6명·3박', '해당 객실·6명·3박')
    $html = $html.Replace('502호로 결제', '해당 객실로 결제')
    if ($html -notmatch 'name="robots"') {
        $html = $html.Replace('<meta name="viewport"', '<meta name="robots" content="noindex,nofollow,noarchive">' + [Environment]::NewLine + '  <meta name="viewport"')
    }
    Set-Content -Encoding utf8 -LiteralPath $file.FullName -Value $html
}

$indexPath = Join-Path $publicRoot 'index.html'
$indexHtml = Get-Content -Raw -Encoding utf8 -LiteralPath $indexPath
if ($indexHtml -notmatch 'summary\.html') {
    $indexHtml = $indexHtml.Replace('<nav class="toc"><strong>바로가기</strong><br>', '<nav class="toc"><strong>바로가기</strong><br><a href="summary.html">친구 공유용 요약</a>')
    Set-Content -Encoding utf8 -LiteralPath $indexPath -Value $indexHtml
}

Write-Host '배포용 파일 동기화 완료:' $publicRoot



