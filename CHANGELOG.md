# Changelog — munteok (문턱)

All notable changes to the **munteok framework** itself (zone definitions, scaffold structure, component selection) are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

**Versioning policy**: SemVer 태그는 *기록·마일스톤* 목적으로 단다 — 외부 사용자/트리거를 기다리지 않는다 (2026-05-26 stance 정정: sonmat도 사용자가 아닌 메커니즘·기록으로 태깅을 시작했다). 0.x는 API 안정 전 baseline 스냅샷. SHA 단위는 `git log`, 사람이 읽는 요약은 이 파일.

**Scope**: framework-side changes only (zone READMEs, top-level README, scaffold, component selection, .gitignore). Component internals are tracked in their own CHANGELOG (e.g. `jun0-ds/sonmat`·`jun0-ds/bobusang`·`jun0-ds/deodeumi`·`jun0-ds/sarangchae`).

---

## [Unreleased]

### Changed (2026-08-29)
- `bedrock/sonmat` submodule pointer: `54cc889` (v0.17.0) → `212f32c` (v0.17.1). 자동 내부 검증인 guard를 사용자 호출 표면에서 제거한 메타데이터 정렬.
- `madang/sarangchae` submodule pointer: `0e67e25` → `99a79f4`. maintainer instance가 Paseo를 활성 remote-agent 표면으로 채택하면서 사랑채 개발을 중단했다. framework는 사랑채를 역사적 UI 컴포넌트 예시로 보존한다.

### Added (2026-05-26)
- **`setup.sh` 신설** — 안채 scaffold 도구 (v0 부트스트랩, agenda v0.x 트랙). fork 후 실행 → ① private zone placeholder(`hearth/identity/{voice,position,relations}`·`desk/agenda/current`·`desk/diary`) 스캐폴드 ② 4-zone 정의를 `~/.claude/CLAUDE.md`에 `munteok:zones` marker block으로 install (bobusang `install_or_update_marker_block` 패턴 차용). **idempotent**. 메모리/싱크(→bobusang)·thinking(→sonmat)·device 표·desk↔~/.claude symlink는 명시적 위임(경계 겹침 회피). `templates/` 6종 동반. sandbox 3종 검증(fresh / idempotent skip+marker갱신 / marker-update + 바깥 콘텐츠 보존). `MUNTEOK_CLAUDE_DIR` env override(테스트용)

### Changed (2026-05-26)
- `madang/sarangchae` submodule pointer: `f6df178` (v0.1.0) → `7edc9e0` — (`a522c24`) `vstabs`→`sarangchae` rename + README reframe, (`9d13f2f`) web UI pivot ADR, (`7edc9e0`) web UI pivot ADR **Accepted 2026-05-27** + stack(React/Vite↔WS↔TS SDK 하네스). **anchae와 pointer 동시 정합** (`trap_one_sided_submodule_pointer` 준수)

## [0.1.0] - 2026-05-26

첫 SemVer baseline — 기록·마일스톤 도장. **4-zone scaffold + 컴포넌트 4개 submodule mount + distribution(scaffold + marker block) 모델**이 표면. 같은 날 컴포넌트들도 각자 v0.1.0 baseline (sonmat은 v0.14.0).

### Added (2026-05-14)
- `bedrock/deodeumi` component mounted (4th component, public extraction) — substrate retrieval + path orchestration 함수의 자리 ([`jun0-ds/deodeumi`](https://github.com/jun0-ds/deodeumi))
- `madang/README.md` § "만남의 두 surface" — 에디터/IDE 안쪽·바깥쪽 surface 카테고리 명시화
- Top-level README "관계된 OSS 도구" 절에 deodeumi 추가
- `bedrock/README.md` sonmat·bobusang·deodeumi 모두 submodule 표현으로 일관화 (이전 "symlink mount" stale 표기 정정)

### Changed (2026-05-14)
- `bedrock/deodeumi` submodule pointer: `8b11f8b` (initial) → `6cfccf9` (skills/requery/SKILL.md 반영)

### Component pointers (v0.1.0 기준, 2026-05-26)
- `bedrock/sonmat` → `161955d` (v0.14.0)
- `bedrock/bobusang` → `dd97714` (v0.1.0)
- `bedrock/deodeumi` → `c723e76` (v0.1.0)
- `madang/sarangchae` → `f6df178` (v0.1.0)  _(이전 stale 표기: `madang/vstabs` → `231a0e1d`/`41207096`/`6cfccf9`/`2299ce92` — 5/19 rename + 컴포넌트 v0.1.0 cut 반영)_

---

## [2026-05-13 — 초기 부트스트랩]

### Added
- Framework repository initial commit (`345caee`) — README + LICENSE + .gitignore
- Zone READMEs 6개 trim 복제 (`5332805`) — bedrock·hearth·desk·madang·devlog·bedrock/deodeumi
- 컴포넌트 submodule mount (ADR-0007 시연 구성): bedrock/sonmat·bedrock/bobusang·madang/vstabs
- Top-level README "관계된 OSS 도구" 절 — fork 사용자가 다른 컴포넌트로 자유 교체 가능 명시

### Notes
- Framework distribution model: scaffold + marker block (bobusang setup.sh가 §6 동기화 절을 marker block으로 install/update). 사용자는 fork or scaffold 권장
- Component pinning policy: framework는 *시연 구성*. fork 후 자유 교체 가능 (`.gitmodules` 갱신)

---

## Conventions

- **Component pointer 갱신**은 *Changed* 절에 SHA before→after로 박는다 (이유: SHA가 SoT이므로 누락 시 drift 위험)
- **Component 추가/제거**는 *Added*/*Removed* 절
- **Zone 정의 변화** (README 본문 의미 변화)는 *Changed* 절
- **scaffold 도구 도입**은 *Added* 절 (예: setup.sh, init script)
- 작은 typo·문구 조정은 기록 안 함 (`git log`만)

## Related repos

- 안채 측 운영 사연 (instance-specific): `jun0-ds/munteok-anchae` (private)
- 컴포넌트별 CHANGELOG: 각 컴포넌트 리포 루트 `CHANGELOG.md`
