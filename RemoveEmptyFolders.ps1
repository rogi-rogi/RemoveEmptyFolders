# 현재 디렉터리에서 시작하여 모든 하위 디렉터리를 검색하고, 디렉터리 정보만 가져옴
$folders = Get-ChildItem -Path . -Recurse -Directory

# 삭제된 폴더 수를 기록하는 변수, 초기값은 0
$removedCount = 0

# 이전 출력의 문자열 길이를 저장하는 변수, 초기값은 0
$lastLength = 0

# 모든 폴더를 반복하여 처리
foreach ($folder in $folders) {
    $output = "`rScanning folder : $($folder.FullName)"
    
    # 현재 출력 문자열의 길이를 구함
    $currentLength = $output.Length

    # 현재 출력 문자열의 길이가 이전 길이보다 짧을 경우, 남은 텍스트를 지우기 위해 공백 추가
    if ($currentLength -lt $lastLength) {
        $output += (" " * ($lastLength - $currentLength))  # 부족한 길이만큼 공백 추가
    }

    # 커서를 줄의 시작으로 이동하고 출력하되, 개행 없이 실행
    Write-Host -NoNewline "`r$output"

    # 현재 출력 문자열의 길이를 저장해 다음 루프에서 비교할 수 있도록 설정
    $lastLength = $currentLength

    # 현재 폴더가 빈 폴더인지 확인 (하위 항목 개수 측정)
    if ((Get-ChildItem -Path $folder.FullName -Recurse | Measure-Object).Count -eq 0) {
        # 빈 폴더일 경우 폴더 삭제 (강제 삭제)
        Remove-Item -Path $folder.FullName -Force -Recurse
        
        # 삭제된 폴더의 경로를 출력
        Write-Host "`rDeleted folder: $($folder.FullName)"
        $removedCount++
    }
}

# 총 삭제된 빈 폴더의 개수를 출력
Write-Host "`nTotal removed empty folders count: $removedCount"
Pause