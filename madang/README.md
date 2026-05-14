# madang — slow + private (UI / 만남의 자리)

사람과 substrate가 만나는 자리. UI·entry surface 거주. substrate 자체가 *쓰는* 엔진은 [`bedrock/`](../bedrock/README.md).

문턱(munteok) 이름의 출처인 *마당을 나온 암탉* framing의 그 **마당** — 안채(hearth)와 바깥세계 사이의 경계 공간. 안채는 정주의 자리, 마당은 *나와서 만나는* 자리.

## 만남의 두 surface (2026-05-14 명시화)

사람과 substrate의 만남은 *두 surface* 중 하나에서 일어남 — 둘 다 madang의 *논리 자리*:

| surface | 위치 | 특징 |
|---------|-----|------|
| **에디터/IDE 안쪽** | AI 코딩 도구의 chat/extension UI (예: Claude Code VSCode extension) | 즉시 코드 적용·chat·diff·file tree. 호스트 도구의 세션 길이·UX 한계 상속. 외부 제품이라 zone 안 *물리 거주* X — 논리 자리만 |
| **에디터/IDE 바깥쪽** | own-harness UI·외부 launcher·web surface | 자유 layout·세션 길이 자유. 본 zone에 *물리 거주* (시연: `madang/vstabs` submodule) |

두 surface는 *같은 substrate*에 접근하지만 운영 결이 다름. release notes에서 *어느 surface에 영향*인지 명시 가치 있음.

## 기대 거주 (물리 mount)

- 에디터/IDE 바깥 surface의 UI 컴포넌트 submodule (예: own-harness wrapper, 모니터·소통 UI, web entry 등). 시연: [`madang/vstabs`](https://github.com/jun0-ds/vstabs)

## 원칙

- 새 파일 추가 시 — *사람과 substrate가 만나는 자리인가*가 기준
- substrate가 *사용*하는 인프라면 bedrock으로
- 본인의 정체성·자세 박제면 hearth로
- 현재 작업·의제면 desk로
- UI 컴포넌트는 보통 *외부 리포의 symlink* 형태 (마당은 substrate 외부 도구를 *맞이하는* 자리)

## pace 결

대부분 UI 컴포넌트는 *fashion/commerce* 결로 빠르게 변하는 layer지만, 본 zone에 들어오는 것은 **substrate와 안정적으로 결합된 만남의 자리**. 따라서 slow + private 결로 분류.
