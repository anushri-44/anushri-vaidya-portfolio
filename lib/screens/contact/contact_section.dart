import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/constants/portfolio_constants.dart';
import '../../core/utils/launcher_service.dart';
import '../../services/portfolio_api_service.dart';

class ContactSection extends StatefulWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _emailCopied = false;
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      key: ContactSection.sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Let's connect.",
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 34 : 42,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650,
            ),
            child: const Text(
              'I’m open to software development opportunities, '
              'internships, collaborations and meaningful projects. '
              'If you would like to connect, feel free to reach out.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.border,
              ),
            ),
            child: isMobile
                ? _buildMobileContact()
                : _buildDesktopContact(),
          ),

          const SizedBox(height: 32),

          _buildMessageForm(isMobile),
        ],
      ),
    );
  }

  Widget _buildDesktopContact() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildEmailInfo(),
        ),
        const SizedBox(width: 30),
        _buildEmailButton(),
        const SizedBox(width: 12),
        _buildCopyButton(),
        const SizedBox(width: 12),
        _buildLinkedInButton(),
        const SizedBox(width: 12),
        _buildGitHubButton(),
      ],
    );
  }

  Widget _buildMobileContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailInfo(),

        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildEmailButton(),
            _buildCopyButton(),
            _buildLinkedInButton(),
            _buildGitHubButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        SelectableText(
          PortfolioConstants.email,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailButton() {
    return ElevatedButton.icon(
      onPressed: LauncherService.openHireMeEmail,
      icon: const Icon(
        Icons.mail_outline_rounded,
        size: 18,
      ),
      label: const Text('Email Me ↗'),
    );
  }

  Widget _buildCopyButton() {
    return OutlinedButton.icon(
      onPressed: () async {
        await Clipboard.setData(
          const ClipboardData(
            text: PortfolioConstants.email,
          ),
        );

        if (!mounted) return;

        setState(() {
          _emailCopied = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          setState(() {
            _emailCopied = false;
          });
        });
      },
      icon: Icon(
        _emailCopied
            ? Icons.check_rounded
            : Icons.content_copy_rounded,
        size: 17,
      ),
      label: Text(
        _emailCopied ? 'Email Copied' : 'Copy Email',
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimary,
        side: const BorderSide(
          color: AppTheme.border,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLinkedInButton() {
    return OutlinedButton.icon(
      onPressed: LauncherService.openLinkedIn,
      icon: const Icon(
        Icons.person_outline_rounded,
        size: 17,
      ),
      label: const Text('LinkedIn ↗'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimary,
        side: const BorderSide(
          color: AppTheme.border,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildGitHubButton() {
    return OutlinedButton.icon(
      onPressed: LauncherService.openGitHub,
      icon: const Icon(
        Icons.code_rounded,
        size: 17,
      ),
      label: const Text('GitHub ↗'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimary,
        side: const BorderSide(
          color: AppTheme.border,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildMessageForm(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send me a message',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Have an opportunity, collaboration idea, or project to discuss?',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 28),

            if (isMobile)
              Column(
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: _buildNameField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildEmailField()),
                ],
              ),

            const SizedBox(height: 16),

            _buildMessageField(),

            const SizedBox(height: 22),

            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _submitMessage,
                icon: _isSending
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        size: 17,
                      ),
                label: Text(
                  _isSending ? 'Sending...' : 'Send Message',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: _fieldDecoration('Your name'),
      validator: (value) {
        if (value == null || value.trim().length < 2) {
          return 'Enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _fieldDecoration('Your email'),
      validator: (value) {
        final email = value?.trim() ?? '';

        if (email.isEmpty ||
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
          return 'Enter a valid email';
        }

        return null;
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      textInputAction: TextInputAction.newline,
      decoration: _fieldDecoration('Your message'),
      validator: (value) {
        if (value == null || value.trim().length < 10) {
          return 'Message must be at least 10 characters';
        }
        return null;
      },
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppTheme.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.primary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }

Future<void> _submitMessage() async {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fix the form fields first.'),
      ),
    );
    return;
  }

  setState(() {
    _isSending = true;
  });

  try {
    await PortfolioApiService().sendMessage(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully.'),
      ),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Send failed: $e'),
      ),
    );
  } finally {
  if (mounted) {
    setState(() {
      _isSending = false;
    });
  }
  }
}
}