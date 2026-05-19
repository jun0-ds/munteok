# 문턱 (munteok)

AI 에이전트가 *거주*할 수 있는 substrate를 짓기 위한 framework. 4-zone (pace layering + 경계) 구조와 deodeumi(경로찾기) 엔진을 제공.

> **문턱** = 안과 바깥을 가르는 경계 자리. 동시에 *건너오는 자리*. 이 framework는 자기 *안채(instance)*가 어디인지 안다.
>
> 안채(instance, private) ↔ 문턱(framework, public)의 분리가 v0의 기본 자세.

## 5-zone (pace layering + 경계)

| zone | 변화 속도 | 공유 | 정체 |
|------|---------|------|-----|
| `bedrock/` | 느림 | 공개 가능 | 엔진·도구·재사용 패턴 (substrate 인프라) |
| `hearth/` | 느림 | 비공개 | 정체성·자세·길든 판단 (안채 — 정주의 자리) |
| `desk/` | 빠름 | 비공개 | 현재 작업·메모리·의제 |
| `madang/` | 느림 | 비공개 | UI · 사람과 substrate의 만남 자리 (마당 — 나와서 만나는 자리) |
| `sarangchae/` | 느림 | 비공개 | AI와 사람이 소통·업무하는 공간 (사랑채 — 외부 응대 자리, 인증 필수) |

배경: Stewart Brand pace layering / Aristotle techne / Bourdieu habitus / dotfiles 표준 3-way → *마당을 나온 암탉* (황선미) framing 정합으로 4-zone 확장 (madang) → 한옥 *외부 응대* 결로 5-zone 진화 (sarangchae 추가, ADR-0009).

문턱(munteok)이라는 이름이 약속한 *경계의 자리*가 internal zone에도 박힘 — 안채(hearth)가 안쪽 정체성, 마당(madang)이 안쪽-바깥쪽 만남, 사랑채(sarangchae)가 *외부 진입 응대*.

## 직교 view

- **3-layer 시스템 아키텍처**: kernel(인지 substrate, 예: [sonmat](https://github.com/jun0-ds/sonmat)) / data(`hearth/`+`desk/`) / management(`bedrock/deodeumi/`)
- **5-layer pathfinding**: L1 hierarchy / L2 KG (TBD) / L3 pheromone (TBD) / L4 policy+identity (`hearth/`) / L5 agency loop

## 관계된 OSS 도구 (시연 구성 — submodule mount)

본 framework는 다음 컴포넌트를 *예시 구성*으로 submodule mount한다. fork 시 자유롭게 다른 컴포넌트로 교체 가능 — `.gitmodules` 갱신 + `git submodule deinit` / `git submodule add` 패턴.

- [`bedrock/sonmat`](https://github.com/jun0-ds/sonmat) — 인지 규율 플러그인 (substrate kernel 자리)
- [`bedrock/bobusang`](https://github.com/jun0-ds/bobusang) — 디바이스 싱크 인프라
- [`bedrock/deodeumi`](https://github.com/jun0-ds/deodeumi) — substrate retrieval + path orchestration 함수의 자리 (management 자리, 2026-05-14 추출)
- [`sarangchae/`](https://github.com/jun0-ds/sarangchae) — AI-사람 소통·업무 web UI (외부 진입 + 인증). 2026-05-19 vstabs 리포 → sarangchae rename + web pivot 진행 중 (ADR-0009). 코드 pivot은 후속 ADR

## 사용법

```bash
git clone --recurse-submodules https://github.com/jun0-ds/munteok.git
# 또는 clone 후
git submodule update --init --recursive
```

v0 부트스트랩 도구는 진행 중 — `setup.sh` 형태로 안채 scaffold 예정.

현재는 reference 구조로만 — 자기 안채를 만들 때 본 리포를 base로 fork하거나 scaffold. fork 시 hearth/identity·desk 등 *안채 전용* zone 본문은 자기 instance 콘텐츠로 교체. 컴포넌트(bedrock/{sonmat,bobusang}·madang/vstabs)는 *시연*이라 그대로 두거나 자기 fork·다른 컴포넌트로 자유 교체.

## v0 scope

- 4-zone 분리 정착
- hearth identity·policy의 @include atomic 패턴 분해
- pace layering commit cadence
- devlog narrative thread

## v0.x 이후 (deferred)

deodeumi management 에이전트, L2 KG index, L3 pheromone log, L5 agency loop reconciler, scaffold 도구.

## License

BSD 3-Clause — see [LICENSE](LICENSE).
