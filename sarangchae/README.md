# sarangchae — slow + private (AI-사람 소통·업무 자리 / 외부 응대)

AI 에이전트와 사람이 소통·업무하는 web UI 자리. **외부 진입 + 인증** 전제. 한옥 *사랑채*(외부 손님 응대) 결.

> 5-zone 진화 — 2026-05-19 신설. 자세: 안채 측 ADR-0009 + `~/.claude/CLAUDE.md` §9.

## madang vs sarangchae — 결의 분리

| zone | 결 | 만남의 결 |
|------|---|----------|
| `madang/` | 사람-substrate 만남 | 사람이 substrate를 *쓰는* 인터페이스. 내부 자리 |
| `sarangchae/` | AI-사람 소통·업무 | 외부 진입 + 인증. 외부 응대 자리 |

## 구성 단위 (예시)

- **ssh** — ssh 호스트 목록 거주처
- **project** — workspace 등록·전환
- **session** — agent 세션 surface (예: Anthropic Claude Agent SDK `SessionStore` 백엔드)
- **folder explorer** — project 내부 파일 browse

## 시연 컴포넌트 (예정)

[`sarangchae/`](https://github.com/jun0-ds/sarangchae) — AI-사람 소통·업무 web UI. 2026-05-19 vstabs 리포 → sarangchae rename + Tauri desktop → web pivot 트랙. submodule mount는 GitHub rename 후 진행.

## pace 결

UI 컴포넌트는 일반적으로 빠르게 변하지만, 본 zone에 들어오는 것은 **substrate와 결합된 운영 인프라**(인증·세션·project 등록). slow + private 결.
