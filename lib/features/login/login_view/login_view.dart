import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/messages.dart';
import '../../../l10n/app_localizations.dart';
import '../view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.onLogin});
  final void Function(BuildContext context) onLogin;

  Future<void> _submit(BuildContext context, LoginViewModel model) async {
    if (model.isLoading || !(model.formKey.currentState?.validate() ?? false)) {
      return;
    }
    final success = await model.login(
      username: model.usernameController.text,
      password: model.passwordController.text,
    );
    if (success && context.mounted) onLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final model = context.watch<LoginViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: model.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.welcome,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(t.demoCredentials, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: model.usernameController,
                      decoration: InputDecoration(
                        labelText: t.username,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? t.enterUsername
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: model.passwordController,
                      obscureText: model.obscurePassword,
                      decoration: InputDecoration(
                        labelText: t.password,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: model.obscurePassword
                              ? t.showPassword
                              : t.hidePassword,
                          onPressed: model.togglePasswordVisibility,
                          icon: Icon(
                            model.obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(context, model),
                      validator: (value) => value == null || value.isEmpty
                          ? t.enterPassword
                          : null,
                    ),
                    if (model.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorText(context, model.errorMessage!),
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: model.isLoading
                          ? null
                          : () => _submit(context, model),
                      child: model.isLoading
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              model.errorMessage == null
                                  ? t.continueToCatalog
                                  : t.retry,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
