# SportSphere Mobile — Auth & Security

## Session model (matches API)
- Login: `POST /api/auth` with `email` **or** `handle` + `password`
- Register: `POST /api/auth/register` (password min **8**)
- Response: `{ user, token, expiresAt }`
- Mobile sends `Authorization: Bearer <token>` on subsequent requests
- Token stored in **Flutter Secure Storage** (Keystore / Keychain)
- Logout: `POST /api/auth/logout` + local token wipe
- HTTP **401** → local token cleared

## Rules
- Never log JWT values
- Never store password
- Prefer Android/iOS for auth testing (web CORS blocks localhost → production API)

## Next hardening (optional)
- Certificate pinning for production builds
- Biometric unlock for stored session
- Refresh-token rotation if API adds it
