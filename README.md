# 문턱 (munteok)

에이전트와 함께 하는 업무·개인 작업을 한 작업공간에 모으고 필요한 문맥으로 찾아가는 기본 환경이에요.
Windows 네이티브 사용자를 위한 `setup.ps1`이 로컬 메모리·노트·문맥 안내·보관 폴더까지 준비해요.
보부상과 사랑채 설치, 저장소 fork, SSH 키는 기본 설치에 필요하지 않아요.

## Windows에서 시작

에이전트 하나를 설치하고 로그인한 뒤 [어시스턴트 셋업 가이드](https://github.com/jun0-ds/ai-assistant-setup)에서
설치와 첫 작업을 이어가세요. 문턱만 설치하려면 PowerShell에서 공개 소스를 받고 작업공간의 절대경로를 지정해요.

```powershell
git clone https://github.com/jun0-ds/munteok.git
Set-Location .\munteok
$WorkspaceRoot = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'AgentWorkspace'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -WorkspaceRoot $WorkspaceRoot
```

`AgentWorkspace`는 제안 이름이에요. 다른 위치를 골라도 되지만 공개 소스 폴더 안에는 만들 수 없어요.
문서 폴더가 OneDrive 등으로 동기화된다면 회사 자료·개인 자료를 저장하기 전에 허용된 위치인지 확인해요.
관리자 권한이나 시스템 실행 정책 변경 없이 해당 PowerShell 프로세스에서만 스크립트를 실행해요.

설치 뒤 에이전트를 작업공간 폴더에서 실행하고 다음을 전달해요.

```text
AGENTS.md와 CONTEXT.md를 읽고 내 첫 작업을 도와줘.
업무인지 개인인지에 맞춰 프로젝트 또는 이슈 폴더를 만들고,
필요한 자료와 원하는 결과를 함께 정하자.
```

Paseo에서도 같은 작업공간 또는 그 안의 프로젝트 폴더를 선택해 시작해요. 폴더 구분은 보안 sandbox가 아니에요.
폴더를 바꿔도 읽기·쓰기 권한 자체가 차단되는 것은 아니에요.

## 설치 결과

소스 저장소와 사용자의 작업공간은 서로 다른 위치에 있어요.

```text
munteok/                     공개 소스·설치기·원본 템플릿
AgentWorkspace/              사용자 자료, Git에 자동 등록하지 않음
├── AGENTS.md                공통 진입 지침, 문턱 marker 안만 갱신
├── CLAUDE.md                신규일 때 @AGENTS.md adapter
├── CONTEXT.md               업무·개인·공유 기억으로 안내
├── 업무/
│   ├── CONTEXT.md
│   └── 보관/                회사별로 나누면 회사 안에도 보관/
├── 개인/
│   ├── CONTEXT.md
│   └── 보관/
└── .munteok/
    ├── hearth/              공통 말투
    ├── desk/                memory·notes·agenda
    ├── workitem-template.md
    ├── completion.md
    ├── state/               설치 버전·일일 확인 날짜
    └── tools/               문턱이 관리하는 업데이트 확인기
```

최소 공통 정보 → 루트 `CONTEXT.md` → 업무·개인 영역 → 프로젝트·이슈 `CONTEXT.md` → 필요한 자료로 읽어요.
이것이 문턱의 ICM식 구성과 라우팅이에요. 업무·개인 자료를 한 전역 기억에 합치거나 모든 폴더를 한꺼번에 읽지 않아요.
새 작업은 템플릿을 바탕으로 목적·입력·완료 기준·결과 위치를 적고 자료·결과·임시 파일을 그 안에 모아요.

끝난 일은 임시 파일을 정리하고 같은 영역의 `보관/YYYYMMDD_이름/`으로 옮겨요.
진행 중인 서비스·프로젝트는 남겨두고 완료 이슈만 보관할 수 있어요. 이동 전 기록 경로를 남기고 활성 목록과
링크를 함께 갱신하는 절차는 설치되는 `.munteok/completion.md`에 있어요.

## 재설치와 업데이트

같은 명령을 다시 실행해도 사용자 문맥·메모리·노트를 덮지 않아요. 루트 `AGENTS.md`는 문턱 marker 안만
갱신하고 바깥 규칙을 보존해요. 기존 비관리 `CLAUDE.md`는 경고 후 그대로 두므로 에이전트와 충돌을 검토하고
필요한 경우 `@AGENTS.md` 연결을 추가하세요. 전역 harness 홈·계정·권한·모델 설정은 수정하지 않아요.

그날 첫 작업에서 설치된 도구가 GitHub의 최신 stable release를 확인해요. 장치의 로컬 날짜 기준 하루 한 번이며
새 버전을 알리기만 해요. 작업공간 파일과 계정 정보를 보내지 않고 자동 pull·설치·서비스 재시작도 하지 않아요.
네트워크 실패는 당일에 반복하지 않고 작업을 계속해요.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WorkspaceRoot/.munteok/tools/Check-Updates.ps1" -WorkspaceRoot $WorkspaceRoot
```

업데이트는 release 내용을 검토하고 공개 소스를 갱신한 뒤 같은 작업공간에 설치기를 다시 실행해 적용해요.
`VERSION`은 소스 버전, `.munteok/state/install.json`은 설치된 버전이에요. 소스의 버전 파일이 있다는 사실만으로
그 버전의 GitHub release가 게시된 것은 아니에요.

## 구성 요소와 기존 설치

4-zone은 원천 도구(`bedrock`)·공통 사용자 정보(`hearth`)·현재 작업(`desk`)·사람과 만나는 UI(`madang`)를
구분하는 배경 구조예요. 새 기본 설치에서는 사용자 정보와 작업 자료가 공개 소스 바깥의 작업공간에 있어요.

- [손맛](https://github.com/jun0-ds/sonmat)은 사고·실행 규율이에요. 셋업 가이드의 손맛 단계에서 설치해 기본 로드해요.
- [더듬이](https://github.com/jun0-ds/deodeumi)는 검색 방법론의 원천으로 연결해요. 추가 검색 도구는 필요할 때 선택하고 기본 문맥 라우팅은 Markdown만으로 동작해요.
- 보부상은 선택 동기화 도구예요. 로컬 기억·노트 생성에는 필요하지 않아요.
- 사랑채는 역사적 UI 구현으로 보존하며 새 기본 설치에서 받거나 실행하지 않아요.

`.gitmodules`에는 이전 설치와 기록을 위해 컴포넌트가 남아 있어요. 기본 clone에는 `--recurse-submodules`를
붙이지 마세요. 특정 구성 요소가 필요할 때 해당 공개 HTTPS 저장소의 설치 안내를 따르세요.

`setup.sh`는 기존 안채용 Bash 설치 경로로 보존해요. 새 Windows 설치와 기능이 같은 것으로 간주하지 않아요.
Windows에서 시작한 뒤 WSL로 옮길 때는 경로·실행파일·계정·Paseo 데몬을 각각 확인하고 기존 작업공간과 기록을
보존하는 이관 절차를 셋업 가이드에서 따라가세요. 네이티브와 WSL 설치를 중복 실행해 같은 자료를 덮지 마세요.

## 검증

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\Windows.Tests.ps1
```

테스트는 별도 임시 폴더에서 설치·재실행·사용자 문서 보존·한글과 공백 경로·비관리 Claude 지침 보존·버전 비교·
일일 중복 억제·오프라인 동작을 확인하고 정리해요. Windows PowerShell 5.1에서 실행하는 검증과
Paseo·모바일·실제 사용자 설치 검증은 별개예요.

BSD 3-Clause — [LICENSE](LICENSE).
