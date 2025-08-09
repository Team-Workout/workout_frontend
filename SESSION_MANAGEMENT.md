# 세션 관리 가이드

## 개요
이 앱은 백엔드 서버와의 세션 관리를 위해 다음 방법들을 지원합니다:
1. **쿠키 기반 세션** - 자동으로 관리됨
2. **헤더 기반 세션** - Authorization 헤더나 커스텀 헤더
3. **응답 본문의 세션 토큰** - JSON 응답에 포함된 토큰

## 구현된 기능

### 1. 자동 쿠키 관리
- `PersistCookieJar`를 사용하여 쿠키를 자동으로 저장하고 관리
- 앱을 재시작해도 쿠키가 유지됨
- 서버에서 Set-Cookie 헤더로 보낸 세션 쿠키가 자동으로 저장되고 이후 요청에 포함됨

### 2. 세션 헤더 관리
서버가 다음 헤더 중 하나로 세션을 전달하면 자동으로 저장:
- `X-Session-Id`
- `Session-Id`
- `X-Auth-Token`
- `Authorization`

### 3. JSON 응답 본문의 세션
응답 본문에 다음 필드가 있으면 자동으로 저장:
- `sessionId`
- `token`

## API 엔드포인트

### 로그인
```
POST /api/auth/signin
Body: {
  "email": "user@example.com",
  "password": "password123"
}

Response: {
  "id": 1,
  "email": "user@example.com",
  "name": "사용자",
  "role": "USER",
  "sessionId": "session-123", // 선택적
  "token": "jwt-token-here"   // 선택적
}

Headers (서버 응답):
- Set-Cookie: JSESSIONID=xxx; Path=/; HttpOnly
- X-Session-Id: session-123
```

### 회원가입
```
POST /api/auth/signup
Body: {
  "gymId": 1,
  "email": "user@example.com",
  "password": "password123",
  "name": "김헬스",
  "gender": "MALE",
  "goal": "체력 증진 및 근력 향상",
  "role": "USER"
}

Response: 로그인과 동일
```

### 로그아웃
```
POST /api/auth/logout

Headers (클라이언트가 보냄):
- Cookie: JSESSIONID=xxx
- X-Session-Id: session-123
- Authorization: Bearer jwt-token-here

Response: {
  "message": "로그아웃 성공"
}
```

## 세션 처리 흐름

1. **로그인/회원가입 시**:
   - 서버 응답에서 세션 정보 추출
   - 쿠키, 헤더, JSON 본문 모두 확인
   - `SharedPreferences`와 `CookieJar`에 저장

2. **일반 API 요청 시**:
   - 저장된 세션 정보를 자동으로 헤더에 추가
   - 쿠키는 `CookieManager`가 자동 관리

3. **로그아웃 시**:
   - 서버에 로그아웃 API 호출 (세션 포함)
   - 로컬 저장소의 모든 세션 정보 삭제
   - 쿠키 삭제

4. **세션 만료 시** (401 에러):
   - 자동으로 세션 정보 삭제
   - 로그인 화면으로 리다이렉트 (선택적)

## 디버깅

앱 실행 시 콘솔에서 다음 로그를 확인할 수 있습니다:
- 🚀 REQUEST: 요청 정보와 헤더
- ✅ RESPONSE: 응답 상태 코드
- ❌ ERROR: 에러 정보

## 주의사항

1. 서버가 쿠키를 사용하는 경우, `HttpOnly` 쿠키는 JavaScript에서 접근할 수 없지만 Flutter의 `CookieManager`는 자동으로 처리합니다.

2. 서버가 CORS를 사용하는 경우, credentials 설정이 필요할 수 있습니다.

3. 세션 저장 위치:
   - 쿠키: `앱 문서 디렉토리/.cookies/`
   - 토큰: `SharedPreferences`

## 테스트 방법

1. 백엔드 서버 실행 (http://localhost:8080)
2. 앱에서 회원가입 또는 로그인
3. 콘솔에서 세션 정보 확인
4. 다른 API 호출 시 세션이 자동으로 포함되는지 확인
5. 로그아웃 후 세션이 삭제되는지 확인