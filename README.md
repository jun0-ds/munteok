# 문턱 (munteok)

AI 에이전트가 *거주*할 수 있는 substrate를 짓기 위한 framework. 4-zone (pace layering + 경계) 구조와 deodeumi(경로찾기) 엔진을 제공.

> **문턱** = 안과 바깥을 가르는 경계 자리. 동시에 *건너오는 자리*. 이 framework는 자기 *안채(instance)*가 어디인지 안다.
>
> 안채(instance, private) ↔ 문턱(framework, public)의 분리가 v0의 기본 자세.

## 4-zone (pace layering + 경계)

| zone | 변화 속도 | 공유 | 정체 |
|------|---------|------|-----|
| `bedrock/` | 느림 | 공개 가능 | 엔진·도구·재사용 패턴 (substrate 인프라) |
| `hearth/` | 느림 | 비공개 | 정체성·자세·길든 판단 (안채 — 정주의 자리) |
| `desk/` | 빠름 | 비공개 | 현재 작업·메모리·의제 |
| `madang/` | 느림 | 비공개 | UI · 사람과 substrate의 만남 자리 (마당 — 나와서 만나는 자리) |

배경: Stewart Brand pace layering / Aristotle techne / Bourdieu habitus / dotfiles 표준 3-way → *마당을 나온 암탉* (황선미) framing 정합으로 4-zone 확장 (madang 추가).

문턱(munteok)이라는 이름이 약속한 *경계의 자리*가 internal zone에도 박힘 — 안채(hearth)가 안쪽 정체성, 마당(madang)이 바깥과의 만남.

## 직교 view

- **3-layer 시스템 아키텍처**: kernel(인지 substrate, 예: [sonmat](https://github.com/jun0-ds/sonmat)) / data(`hearth/`+`desk/`) / management(`bedrock/deodeumi/`)
- **5-layer pathfinding**: L1 hierarchy / L2 KG (TBD) / L3 pheromone (TBD) / L4 policy+identity (`hearth/`) / L5 agency loop

## 관계된 OSS 도구

- [sonmat](https://github.com/jun0-ds/sonmat) — 인지 규율 플러그인 (substrate kernel 자리)
- [bobusang](https://github.com/jun0-ds/bobusang) — 디바이스 싱크 인프라

이 도구들은 안채(instance) 측에서 `bedrock/` 하위 symlink로 mount하는 게 권장 패턴.

## 사용법

v0 부트스트랩 도구는 진행 중 — `setup.sh` 형태로 안채 scaffold 예정.

현재는 reference 구조로만 — 자기 안채를 만들 때 본 리포의 zone 구조 + README를 base로 fork하거나 scaffold.

## v0 scope

- 4-zone 분리 정착
- hearth identity·policy의 @include atomic 패턴 분해
- pace layering commit cadence
- devlog narrative thread

## v0.x 이후 (deferred)

deodeumi management 에이전트, L2 KG index, L3 pheromone log, L5 agency loop reconciler, scaffold 도구.

## License

BSD 3-Clause — see [LICENSE](LICENSE).
