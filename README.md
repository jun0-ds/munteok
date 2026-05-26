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

## 관계된 OSS 도구 (시연 구성 — submodule mount)

본 framework는 다음 컴포넌트를 *예시 구성*으로 submodule mount한다. fork 시 자유롭게 다른 컴포넌트로 교체 가능 — `.gitmodules` 갱신 + `git submodule deinit` / `git submodule add` 패턴.

- [`bedrock/sonmat`](https://github.com/jun0-ds/sonmat) — 인지 규율 플러그인 (substrate kernel 자리)
- [`bedrock/bobusang`](https://github.com/jun0-ds/bobusang) — 디바이스 싱크 인프라
- [`bedrock/deodeumi`](https://github.com/jun0-ds/deodeumi) — substrate retrieval + path orchestration 함수의 자리 (management 자리, 2026-05-14 추출)
- [`madang/sarangchae`](https://github.com/jun0-ds/sarangchae) — AI-사람 소통·업무 web UI (외부 진입 + 인증). 2026-05-19 vstabs 리포 → sarangchae rename + 마당 안 mount 이름 변경(`madang/vstabs` → `madang/sarangchae`). 코드 web pivot은 별도 ADR (ADR-0009)

## 사용법

```bash
git clone --recurse-submodules https://github.com/jun0-ds/munteok.git
# 또는 clone 후
git submodule update --init --recursive
```

### 안채 scaffold — `setup.sh`

fork 후 한 번 실행하면 안채 private zone placeholder(hearth/identity·desk/agenda·diary)를 스캐폴드하고, 4-zone 정의를 `~/.claude/CLAUDE.md`에 marker block(`munteok:zones`)으로 install한다. **idempotent** — 재실행 안전(기존 파일 skip, marker 갱신).

```bash
bash setup.sh
```

setup.sh는 *framework 자리*만 깐다. 나머지는 컴포넌트에 위임:

- 메모리·노트·디바이스 싱크 → [bobusang](https://github.com/jun0-ds/bobusang) `setup.sh`
- thinking 규율 → [sonmat](https://github.com/jun0-ds/sonmat) 설치

fork 시 hearth/identity·desk 등 *안채 전용* zone 본문은 자기 instance 콘텐츠로 채운다. 컴포넌트(bedrock/{sonmat,bobusang,deodeumi}·madang/sarangchae)는 *시연*이라 그대로 두거나 자기 fork·다른 컴포넌트로 자유 교체.

## v0 scope

- 4-zone 분리 정착
- hearth identity·policy의 @include atomic 패턴 분해
- pace layering commit cadence
- devlog narrative thread

## v0.x 이후 (deferred)

deodeumi management 에이전트, L2 KG index, L3 pheromone log, L5 agency loop reconciler.

## License

BSD 3-Clause — see [LICENSE](LICENSE).
