# devlog — narrative thread

substrate 개발 과정의 *사고 흐름*. 결정(ADR)도 핸드오프(bridge-note)도 메모리(frozen synthesis)도 아닌, **사용자와 instance가 어떻게 사고를 주고받으며 도달했는가** 그 자체.

## 청중

- 미래의 자기 (회고)
- 블로그·콘텐츠 재료
- 외부 reader (positioning — substrate가 무엇이 *아닌지* 박제)

## 장르 — 5섹션 (lean)

```markdown
# {date} — {arc 제목}

## 시작 상태
어디에 있었나, 무엇이 미정이었나

## 흐름
대화 핵심 비트 — 누가 무엇을 던졌고, 어디서 꺾였는지.
인용·dialogue snippet 권장 (블로그 직접 재료)

## 도달한 곳
새 framing · 결정 · 합의

## 버려진 길
거절된 후보 + 이유

## Takeaway
재사용 가능한 패턴 1-3줄
```

길이: 200-800 단어. 한 entry = 한 thinking arc.

## Cadence

- arc가 닫힐 때 (결정·redesign·새 framing 도달) 즉시
- 한 세션 = 여러 arc 가능
- 자동 trigger 후보 (v0.x+): scribe 훅에 *"이번 세션에 닫힌 arc 있나"* 판정 추가

## 블로그 promote

devlog → 블로그 시리즈 promote는 별도 단계 — devlog는 raw·내부, 블로그는 정제·외부.

## 백필 정책

부트스트랩 시점에 신선한 arc부터. 이전 arc는 memory에 압축본 있음 — narrative 재구성은 별도 프로젝트.
