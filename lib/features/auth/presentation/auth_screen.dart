import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/features/auth/data/supabase_auth_repository.dart';
import 'package:mozhivora/features/auth/domain/auth_state.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

enum _AuthTab { signIn, signUp, phoneOtp, magicLink }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthTab _tab = _AuthTab.signIn;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isSignedIn && !(prev?.isSignedIn ?? false)) {
        context.go('/');
      }
    });

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Text(
          l10n.authTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: MozhiTokens.space4),
        Text(
          l10n.authGuestCarryOver(auth.guestDemosRemaining),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: MozhiTokens.space16),
        if (auth.status == AuthStatus.unconfigured)
          Card(
            color: theme.colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(MozhiTokens.space16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.tertiary),
                  const SizedBox(width: MozhiTokens.space12),
                  Expanded(
                    child: Text(
                      l10n.authUnconfiguredNotice,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: MozhiTokens.space16),
        SegmentedButton<_AuthTab>(
          segments: [
            ButtonSegment(value: _AuthTab.signIn, label: Text(l10n.authSignIn)),
            ButtonSegment(value: _AuthTab.signUp, label: Text(l10n.authSignUp)),
            ButtonSegment(
                value: _AuthTab.phoneOtp, label: Text(l10n.authPhoneOtp)),
            ButtonSegment(
                value: _AuthTab.magicLink, label: Text(l10n.authMagicLink)),
          ],
          selected: {_tab},
          onSelectionChanged: (s) => setState(() => _tab = s.first),
        ),
        const SizedBox(height: MozhiTokens.space24),
        if (auth.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Text(
              auth.errorMessage!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (auth.infoMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Text(
              auth.infoMessage!,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_tab == _AuthTab.signUp) ...[
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: l10n.authFullName),
                  ),
                  const SizedBox(height: MozhiTokens.space12),
                ],
                if (_tab != _AuthTab.phoneOtp) ...[
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.authEmail),
                  ),
                  const SizedBox(height: MozhiTokens.space12),
                ],
                if (_tab == _AuthTab.signIn || _tab == _AuthTab.signUp) ...[
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.authPassword),
                  ),
                  const SizedBox(height: MozhiTokens.space16),
                ],
                if (_tab == _AuthTab.phoneOtp) ...[
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.authPhoneHint,
                      hintText: '+91 98765 43210',
                    ),
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: MozhiTokens.space12),
                    TextField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.authOtpCode),
                    ),
                  ],
                  const SizedBox(height: MozhiTokens.space16),
                ],
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: MozhiTokens.saffron,
                  ),
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          switch (_tab) {
                            case _AuthTab.signIn:
                              await notifier.signInWithEmail(
                                _emailCtrl.text.trim(),
                                _passCtrl.text,
                              );
                            case _AuthTab.signUp:
                              await notifier.signUpWithEmail(
                                _emailCtrl.text.trim(),
                                _passCtrl.text,
                                _nameCtrl.text.trim(),
                              );
                            case _AuthTab.magicLink:
                              await notifier.sendMagicLink(
                                _emailCtrl.text.trim(),
                              );
                            case _AuthTab.phoneOtp:
                              if (!_otpSent) {
                                await notifier.sendPhoneOtp(
                                  _phoneCtrl.text.trim(),
                                );
                                setState(() => _otpSent = true);
                              } else {
                                await notifier.verifyPhoneOtp(
                                  _phoneCtrl.text.trim(),
                                  _otpCtrl.text.trim(),
                                );
                              }
                          }
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(switch (_tab) {
                          _AuthTab.signIn => l10n.authSignIn,
                          _AuthTab.signUp => l10n.authSignUp,
                          _AuthTab.magicLink => l10n.authSendMagicLink,
                          _AuthTab.phoneOtp =>
                            _otpSent ? l10n.authVerifyOtp : l10n.authSendOtp,
                        }),
                ),
                if (_tab == _AuthTab.signIn)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : () => notifier.sendPasswordReset(
                                _emailCtrl.text.trim(),
                              ),
                      child: Text(l10n.authForgotPassword),
                    ),
                  ),
                const SizedBox(height: MozhiTokens.space12),
                OutlinedButton.icon(
                  onPressed: auth.isLoading ? null : notifier.signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: Text(l10n.authContinueGoogle),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
