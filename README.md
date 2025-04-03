# flutter_shippingmall

# Git 및 GitHub 브랜치 관리 가이드

## 1. 깃허브 브랜치 생성 (브랜치 파는 법)
### 로컬에서 생성 및 푸시
```bash
# 새 브랜치 생성 및 전환
git checkout -b 브랜치이름

# 작업 후 커밋
git add .
git commit -m "작업 내용"

# 깃허브에 푸시
git push origin 브랜치이름
```

### 깃허브 웹에서 생성
1. 저장소 페이지에서 "main" 드롭다운 클릭
2. 새 브랜치 이름 입력 (예: `feature/new-page`)
3. "Create branch" 선택

---

## 2. 변경된 `main` 브랜치를 로컬 브랜치로 내려받기
남들이 `main` 브랜치를 업데이트했을 때, 로컬 브랜치에 반영하는 방법입니다.

```bash
# 현재 브랜치가 main인지 확인
git checkout main

# 원격 main 브랜치 가져오기
git pull origin main

# 작업 중인 브랜치로 전환
git checkout 내-브랜치

# main 브랜치 병합
git merge main
```

> 충돌 발생 시: 충돌 파일 수정 후 `git add`, `git commit`으로 해결.

---

## 3. 브랜치 생성 및 삭제
### 브랜치 생성
```bash
# 새 브랜치 생성
git branch 브랜치이름

# 생성 후 전환
git checkout 브랜치이름
```
> 또는 `git checkout -b 브랜치이름`으로 한 번에.

### 브랜치 삭제
```bash
# 로컬 브랜치 삭제
git branch -d 브랜치이름

# 원격 브랜치 삭제
git push origin --delete 브랜치이름
```

> `-d` 대신 `-D`로 강제 삭제 가능 (주의).

---

## 4. 깃 머지 (Merge) 하는 법
브랜치 작업을 `main`에 통합하거나 다른 브랜치와 병합합니다.

```bash
# 병합하려는 브랜치로 이동
git checkout main

# 다른 브랜치 병합
git merge 브랜치이름

# 충돌 해결 후 커밋
git add .
git commit -m "병합 완료"

# 깃허브에 푸시
git push origin main
```

> 충돌 시: 수정 후 커밋.

---

## 추가 팁
- **브랜치 이름**: `feature/기능`, `bugfix/버그` 등으로 명명 추천.
- **Pull Request**: 깃허브에서 PR 생성 후 팀원 리뷰 요청.
- **상태 확인**: `git status`, `git branch`로 현재 상태 점검.