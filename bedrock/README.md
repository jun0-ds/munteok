# bedrock — slow + public

엔진 zone — substrate가 *사용*하는 인프라가 거주. 변화가 느리고, 외부에 공개 가능한 자리. 사람과 substrate가 만나는 *인터페이스* 자리는 [`madang/`](../madang/README.md).

## 기대 거주

- `sonmat/` — universal cognitive substrate ([github.com/jun0-ds/sonmat](https://github.com/jun0-ds/sonmat)). ADR-0007 submodule mount
- `bobusang/` — 디바이스 싱크 인프라 ([github.com/jun0-ds/bobusang](https://github.com/jun0-ds/bobusang)). ADR-0007 submodule mount
- `deodeumi/` — substrate retrieval + path orchestration 함수의 자리 ([github.com/jun0-ds/deodeumi](https://github.com/jun0-ds/deodeumi)). 2026-05-14 public 추출, ADR-0007 submodule mount
- `patterns/` — 재사용 가능 패턴 (`@include-atomic`, `3-tier-ingest`, `pace-layering` 등)
- `sonmat-memory/` — sonmat 범용 ops 메모리 (guard 검증된 `trap_*`·`insight_*`). sonmat 플러그인 SKILL.md의 default 경로와 호환되는 자리

## 원칙

- 새 파일 추가 시 — *다른 사람도 쓸 수 있는가*가 기준
- 본인 instance에만 유용하면 hearth로
- 현재 작업에만 유용하면 desk로
