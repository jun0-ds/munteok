# Changelog — munteok (문턱)

All notable changes to the **munteok framework** itself (zone definitions, scaffold structure, component selection) are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

**Versioning policy**: SemVer tag is held back until external fork·breaking change·sustained API surface triggers it. Until then, changes accumulate under *Unreleased* — read `git log` for SHA-level granularity, this file for human-readable summary.

**Scope**: framework-side changes only (zone READMEs, top-level README, scaffold, component selection, .gitignore). Component internals are tracked in their own CHANGELOG (e.g. `jun0-ds/sonmat`·`jun0-ds/bobusang`·`jun0-ds/deodeumi`·`jun0-ds/vstabs`).

---

## [Unreleased]

### Added (2026-05-14)
- `bedrock/deodeumi` component mounted (4th component, public extraction) — substrate retrieval + path orchestration 함수의 자리 ([`jun0-ds/deodeumi`](https://github.com/jun0-ds/deodeumi))
- `madang/README.md` § "만남의 두 surface" — 에디터/IDE 안쪽·바깥쪽 surface 카테고리 명시화
- Top-level README "관계된 OSS 도구" 절에 deodeumi 추가
- `bedrock/README.md` sonmat·bobusang·deodeumi 모두 submodule 표현으로 일관화 (이전 "symlink mount" stale 표기 정정)

### Changed (2026-05-14)
- `bedrock/deodeumi` submodule pointer: `8b11f8b` (initial) → `6cfccf9` (skills/requery/SKILL.md 반영)

### Component pointers (current)
- `bedrock/sonmat` → `231a0e1d` (v0.13.1)
- `bedrock/bobusang` → `41207096`
- `bedrock/deodeumi` → `6cfccf9` 🆕
- `madang/vstabs` → `2299ce92`

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
