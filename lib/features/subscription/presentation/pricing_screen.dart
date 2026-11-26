import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/features/auth/data/supabase_auth_repository.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  bool _indiaRegion = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final referralCode =
        'MOZHI-${(auth.account?.id ?? 'GUEST01').substring(0, 6).toUpperCase()}';

    final plans = [
      (
        'Free',
        _indiaRegion ? '₹0' : '\$0',
        '15 AI requests/day · Writer, Email, Notes, Translator · 20 saved items · 5 MB files',
        false,
      ),
      (
        'Student',
        _indiaRegion ? '₹99/mo' : '\$1.99/mo',
        'Verified student status · Study tools · 200 credits/mo (GST/VAT shown at checkout)',
        false,
      ),
      (
        'Pro',
        _indiaRegion ? '₹199/mo' : '\$3.99/mo',
        '500 credits/mo · Document Chat, Voice, OCR, Brand Voice · Unlimited saves · 50 MB files',
        true,
      ),
      (
        'Pro Annual',
        _indiaRegion ? '₹1,499/yr' : '\$29.99/yr',
        'All Pro features · ~37% savings · Priority speed · 7-day Pro trial available',
        false,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: MozhiTokens.space12,
          children: [
            Text(
              l10n.navPricing,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('India (₹ / UPI)')),
                ButtonSegment(value: false, label: Text('Global (\$ / Card)')),
              ],
              selected: {_indiaRegion},
              onSelectionChanged: (s) => setState(() => _indiaRegion = s.first),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space8),
        Text(
          _indiaRegion
              ? 'UPI first via Razorpay on Web, Google Play Billing on Android. 18% GST shown before payment.'
              : 'Cards via Stripe/Paddle on Web, Google Play Billing on Android. Regional VAT shown before payment.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: MozhiTokens.space16),
        ...plans.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MozhiTokens.radiusCard),
                side: BorderSide(
                  color: p.$4 ? MozhiTokens.saffron : theme.colorScheme.outline,
                  width: p.$4 ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(MozhiTokens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p.$1, style: theme.textTheme.titleLarge),
                        Text(
                          p.$2,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MozhiTokens.space8),
                    Text(p.$3, style: theme.textTheme.bodyMedium),
                    if (p.$1 != 'Free') ...[
                      const SizedBox(height: MozhiTokens.space12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: p.$4
                              ? MozhiTokens.saffron
                              : theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _indiaRegion
                                    ? 'Checkout requires live Razorpay / Play Billing credentials.'
                                    : 'Checkout requires live Stripe / Play Billing credentials.',
                              ),
                            ),
                          );
                        },
                        child: Text(l10n.pricingSelectPlan(p.$1)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: MozhiTokens.space16),
        Card(
          child: ListTile(
            leading:
                Icon(Icons.card_giftcard, color: theme.colorScheme.primary),
            title: Text(l10n.referralTitle),
            subtitle: Text('${l10n.referralSubtitle} Code: $referralCode'),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: referralCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Copied referral code: $referralCode')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
