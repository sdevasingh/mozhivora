# MOZHIVORA — Launch & Release Checklist (Phase 8)

## 1. Android Release Build
1. Create a release keystore (never use debug signing for release):
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Configure `android/key.properties` (excluded from Git).
3. Build signed App Bundle with R8 shrinking enabled:
   ```bash
   flutter build appbundle --release \
     --dart-define=SUPABASE_URL=https://<project>.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<anon-key>
   ```

## 2. Google Play Data Safety Summary (EN + HI)
- **Data collected**: Email / Phone (Account auth), User-generated documents/notes (encrypted in transit & at rest, never used for AI training).
- **Data deletion**: Users can export or permanently delete their account and all data in one click.
- **Third-party sub-processors**: Supabase (Auth/Postgres/Storage), Google Gemini API (zero-training API), Razorpay / Stripe / Google Play Billing.

## 3. Definition of Done Audit
- [x] No secrets in client bundles (`--dart-define` only).
- [x] RLS enabled on all 21 Postgres tables + `rls_isolation_test.sql`.
- [x] Transparent credit estimate shown before every AI action; atomic reserve/refund RPCs.
- [x] EN, HI (Devanagari), and UR (RTL) localizations verified in widget tests.
- [x] Separate Astro SEO marketing site (`web_marketing/`) with Open Graph, JSON-LD, `sitemap.xml`, `robots.txt`.
- [x] GitHub Actions CI (`flutter analyze --fatal-infos`, `flutter test`, `flutter build web`, Astro build).
