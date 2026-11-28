import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/features/auth/data/supabase_auth_repository.dart';
import 'package:mozhivora/features/auth/domain/auth_state.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';
import 'package:mozhivora/shared/widgets/mozhi_status_banner.dart';

enum _AuthTab { signIn, signUp, phoneOtp, magicLink }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  _AuthTab _tab = _AuthTab.signIn;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty || !s.contains('@') || !s.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if ((v ?? '').length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    final s = v?.trim() ?? '';
    if (!s.startsWith('+') || s.length < 10) {
      return 'Include country code (e.g. +91 9876543210)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        AtelierPageHeader(
          indexTag: 'Account',
          title: l10n.authTitle,
          subtitle: l10n.authGuestCarryOver(auth.guestDemosRemaining),
        ),
        const SizedBox(height: MozhiTokens.space16),
        if (auth.status == AuthStatus.unconfigured) ...[
          MozhiStatusBanner(
            message: l10n.authUnconfiguredNotice,
            kind: MozhiBannerKind.warning,
          ),
          const SizedBox(height: MozhiTokens.space16),
        ],
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
        if (auth.errorMessage != null) ...[
          MozhiStatusBanner(
            message: auth.errorMessage!,
            kind: MozhiBannerKind.error,
          ),
          const SizedBox(height: MozhiTokens.space12),
        ],
        if (auth.infoMessage != null) ...[
          MozhiStatusBanner(
            message: auth.infoMessage!,
            kind: MozhiBannerKind.success,
          ),
          const SizedBox(height: MozhiTokens.space12),
        ],
        AtelierBox(
          padding: const EdgeInsets.all(MozhiTokens.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_tab == _AuthTab.signUp) ...[
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter your name'
                        : null,
                    decoration: InputDecoration(labelText: l10n.authFullName),
                  ),
                  const SizedBox(height: MozhiTokens.space12),
                ],
                if (_tab != _AuthTab.phoneOtp) ...[
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    decoration: InputDecoration(labelText: l10n.authEmail),
                  ),
                  const SizedBox(height: MozhiTokens.space12),
                ],
                if (_tab == _AuthTab.signIn || _tab == _AuthTab.signUp) ...[
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      labelText: l10n.authPassword,
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: MozhiTokens.space16),
                ],
                if (_tab == _AuthTab.phoneOtp) ...[
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                    decoration: InputDecoration(
                      labelText: l10n.authPhoneHint,
                      hintText: '+91 9876543210',
                    ),
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: MozhiTokens.space12),
                    TextFormField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().length < 6)
                          ? 'Enter 6-digit OTP'
                          : null,
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
                          if (!(_formKey.currentState?.validate() ?? false)) {
                            return;
                          }
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
