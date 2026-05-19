# madang — slow + private (UI / 만남의 자리)

사람과 substrate가 만나는 자리. UI·entry surface 거주. substrate 자체가 *쓰는* 엔진은 [`bedrock/`](../bedrock/README.md).

문턱(munteok) 이름의 출처인 *마당을 나온 암탉* framing의 그 **마당** — 안채(hearth)와 바깥세계 사이의 경계 공간. 안채는 정주의 자리, 마당은 *나와서 만나는* 자리.

## 만남의 surface (5/19 정리)

사람과 substrate의 만남이 일어나는 *논리 자리*. 2026-05-14에 박힌 *두 surface* framing 중 *에디터 바깥쪽 web 진입*은 5/19 사랑채(sarangchae)로 이동(ADR-0009). 마당 정체성은 그대로 유지.

| surface | 위치 | 특징 |
|---------|-----|------|
| **에디터/IDE 안쪽** | AI 코딩 도구의 chat/extension UI (예: Claude Code VSCode extension) | 즉시 코드 적용·chat·diff·file tree. 호스트 도구의 세션 길이·UX 한계 상속. 외부 제품이라 zone 안 *물리 거주* X — 논리 자리만 |
| ~~에디터/IDE 바깥쪽~~ | ~~own-harness UI·web surface~~ → **사랑채(sarangchae)로 이동** | AI-사람 소통·외부 진입·인증이 결의 핵심으로 드러나 사랑채 zone으로 분리 (5/19, ADR-0009) |

마당의 결: *사람이 substrate를 쓰는* 자리. AI와 *소통·업무*하는 결은 사랑채.

## 기대 거주 (물리 mount)

현재 거주자 0. 미래 *사람-substrate 만남* 결의 새 도구가 거주 가능. 5/19 vstabs는 사랑채로 이동.

## 원칙

- 새 파일 추가 시 — *사람과 substrate가 만나는 자리인가*가 기준
- substrate가 *사용*하는 인프라면 bedrock으로
- 본인의 정체성·자세 박제면 hearth로
- 현재 작업·의제면 desk로
- UI 컴포넌트는 보통 *외부 리포의 symlink* 형태 (마당은 substrate 외부 도구를 *맞이하는* 자리)

## pace 결

대부분 UI 컴포넌트는 *fashion/commerce* 결로 빠르게 변하는 layer지만, 본 zone에 들어오는 것은 **substrate와 안정적으로 결합된 만남의 자리**. 따라서 slow + private 결로 분류.
