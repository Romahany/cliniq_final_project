import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF0381C4);
const Color kBorder = Color(0xFFD5DFEA);
const Color kHint = Color(0xFF9AA5B4);
const Color kTitle = Color(0xFF111827);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  bool _hidePass = true;
  bool _hideConfirm = true;
  String _gender = 'Female';

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _phone.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: kTitle),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        hintStyle: const TextStyle(fontSize: 14, color: kHint),
        suffixIcon: suffix,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        enabledBorder: _border(kBorder),
        focusedBorder: _border(kPrimary),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
        errorStyle: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _eye(bool hidden, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: const Color(0xFF6B7280),
      ),
      onPressed: onTap,
    );
  }

  Widget _genderOption(String value) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? kPrimary : const Color(0xFF9AA5B4),
            size: 22,
          ),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 14, color: kTitle)),
        ],
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // TODO: اربط بالـ API لما الـ backend يجهز
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان + زرار الرجوع
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 24, color: kTitle),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: kTitle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // الاسم
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        label: 'First name',
                        hint: 'First name',
                        controller: _firstName,
                        validator: (v) =>
                        v!.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        label: 'Last name',
                        hint: 'Last name',
                        controller: _lastName,
                        validator: (v) =>
                        v!.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // الايميل
                _field(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                  !v!.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),

                // الباسورد
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        label: 'Password',
                        hint: 'Password',
                        controller: _password,
                        obscure: _hidePass,
                        suffix: _eye(_hidePass,
                                () => setState(() => _hidePass = !_hidePass)),
                        validator: (v) =>
                        v!.length < 6 ? 'Min 6 chars' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        label: 'Confirm password',
                        hint: 'Confirm',
                        controller: _confirm,
                        obscure: _hideConfirm,
                        suffix: _eye(
                            _hideConfirm,
                                () =>
                                setState(() => _hideConfirm = !_hideConfirm)),
                        validator: (v) =>
                        v != _password.text ? 'Not matching' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // الموبايل
                _field(
                  label: 'Phone number',
                  hint: 'Enter your phone number',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                  v!.trim().length < 10 ? 'Enter a valid phone' : null,
                ),
                const SizedBox(height: 24),

                // Gender
                const Text('Gender',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _genderOption('Female'),
                    const SizedBox(width: 24),
                    _genderOption('Male'),
                  ],
                ),
                const SizedBox(height: 16),

                // Terms
                const Text.rich(
                  TextSpan(
                    text: 'Creating an account, you agree to our ',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    children: [
                      TextSpan(
                        text: 'Terms&Conditions',
                        style: TextStyle(
                          color: kPrimary,
                          decoration: TextDecoration.underline,
                          decorationColor: kPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // الزرار
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style:
                        TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: kPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}