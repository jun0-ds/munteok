# deodeumi (더듬이) — 경로찾기 함수의 자리

substrate에서 *무엇을 할지 · 어떤 순서로 · 언제 에스컬레이트할지* — 세션을 가로지르는 **경로찾기/orchestration 함수**가 사는 자리.

3-layer로 보면: kernel(`bedrock/sonmat/` — 어떻게 생각) / data(`hearth/` + `desk/` — 정체성·메모리·작업) / **management(deodeumi — 어디로 갈지 더듬기)**. 이름 = 곤충의 더듬이 — 중앙 설계자 없이 환경을 *더듬어* 길을 찾는 기관.

## v0 — 이 함수의 실체 (= 코드 아님, *practice*)

deodeumi v0는 별도 시스템이 아니라 **이미 돌고 있는 protocol들**:

- **hierarchy** = `desk/agenda/current.md` (계층 큐) + `desk/memory/domain/{project}.md` + 각 repo의 `docs/plans/`
- **trail** (어디서 작업이 있었나·뭐가 stale) = bridge-note Carry Forward + `desk/agenda/initiative-log.md` — *수동* 페로몬
- **bound** (안 하는 것·누구인지) = `hearth/identity/*` + `hearth/policy/*` + instance의 글로벌 instructions. *자동집행·외부발신 없음* 류의 원칙이 핵심 제약 — deodeumi는 경로를 *제안·surface*하지 *자율 집행*하지 않음
- **loop** = 인지 규율 플러그인 (예: [sonmat](https://github.com/jun0-ds/sonmat))의 autoloop 결 — deodeumi 고유가 아니라 빌려 씀
- **protocol** = "agenda 연속성": 세션 시작 → instance가 agenda 먼저 surface → 이어갈지 물음 → 작업 → agenda·journal 갱신 → 다음 세션 이어감

## v0.x — 의도적으로 TBD

지금은 어떤 시스템화에도 commit하지 않음. 통증이 먼저 말하기 전엔 안 짓는다.

후보(commit 아님): management 에이전트(`bedrock/deodeumi/agents/`) · 흔적에서 salience 계산(자동 페로몬) · queryable knowledge graph. 이것들은 *규모*가 정당화하는 인프라(다수 에이전트·거대 task graph). 작은 규모(1인 + 1에이전트 + 유한한 agenda)에선 markdown + 규율로 충분할 수 있음.

## 부록 — 5-layer 스케치 (vetted 설계 아님)

L1 hierarchy / L2 KG / L3 pheromone(stigmergy) / L4 policy+identity / L5 agency loop — 초기에 ant-colony optimization 결로 적어둔 taxonomy. 위 v0 항목들이 L1·L3(proto)·L4·L5에 대응하고 L2는 미구현. 매력적인 frame이지만 실제 필요와 대조된 적 없으므로 *참고용 스케치*로만 둠. v0.x를 이 5-layer로 자동 채우지 말 것 — 실험 결과가 우선.
