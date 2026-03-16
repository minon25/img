@echo off
chcp 64901 > nul
setlocal enabledelayedexpansion

:: 모든 하위 폴더 순회
for /d %%D in (*) do (
    echo 현재 폴더: %%D 작업 중...
    pushd "%%D"
    
    :: 1단계: 이름 충돌을 피하기 위해 임시 이름으로 전부 변경
    set tmp_count=1
    for /f "delims=" %%F in ('dir /b /on *.jpg') do (
        ren "%%F" "temp_!tmp_count!.tmp"
        set /a tmp_count+=1
    )

    :: 2단계: 임시 파일을 정해진 순서대로 상품코드명으로 변경
    set final_count=0
    for /f "delims=" %%T in ('dir /b /on *.tmp') do (
        if !final_count! == 0 (
            :: 첫 번째 파일 (1.jpg였던 것) -> [상품코드.jpg]
            ren "%%T" "%%D.jpg"
        ) else (
            :: 두 번째 파일부터 -> [상품코드_순번.jpg]
            ren "%%T" "%%D_!final_count!.jpg"
        )
        set /a final_count+=1
    )
    popd
)

echo 모든 작업이 완료되었습니다! 이제 이름이 꼬이지 않습니다.
pause