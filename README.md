# 후쿠오카 2026 일정 사이트

카카오톡에는 GitHub Pages 주소 하나만 공유합니다. 이후 일정이 바뀌어도 같은 주소에서 최신 내용이 보입니다.

## 업데이트

1. 바탕화면의 `후쿠오카 계획.html`과 지도 파일을 수정합니다.
2. PowerShell에서 아래 명령을 실행합니다.

```powershell
.\sync-site.ps1
git add public
git commit -m "일정 업데이트"
git push
```

`sync-site.ps1`은 공개본에서 객실 번호를 지우고 검색엔진 색인 차단 태그를 넣습니다.

## 배포

`main` 브랜치에 푸시하면 GitHub Actions가 `public` 폴더를 GitHub Pages에 자동 배포합니다.

