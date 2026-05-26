## 문턱(munteok) — substrate 구조

이 substrate는 [문턱(munteok)](https://github.com/jun0-ds/munteok) framework의 4-zone 구조를 따른다. **안채(instance, private) ↔ 문턱(framework, public)** 분리가 기본 자세 — 이 substrate는 자기 *안채*가 어디인지 안다.

### 4-zone (pace layering + 경계)

| zone | 변화 속도 | 공유 | 정체 |
|------|---------|------|------|
| `bedrock/` | 느림 | 공개 가능 | 엔진·도구·재사용 패턴 (substrate 인프라) |
| `hearth/` | 느림 | 비공개 | 정체성·자세·길든 판단 (안채 — 정주의 자리) |
| `desk/` | 빠름 | 비공개 | 현재 작업·메모리·의제 |
| `madang/` | 느림 | 비공개 | UI·사람과 substrate의 만남 자리 (마당 — 나와서 만나는 자리) |

- 호칭·자세 SoT = `hearth/identity/` (voice·position·relations)
- 현재 작업 큐 = `desk/agenda/current.md` (세션 시작 시 먼저 surface)
- thinking 규율은 substrate kernel(예: sonmat)이 별도로 install. 디바이스 싱크·메모리는 bobusang이 별도로 install.

세부: substrate 루트 `README.md` + 각 zone `README.md`.
