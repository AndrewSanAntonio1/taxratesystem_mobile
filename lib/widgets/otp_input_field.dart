import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

/// How an [OtpInputField] draws its slots.
enum OtpFieldStyle {
  /// Filled, outlined boxes — the original look, kept for the screens that have
  /// not been redesigned.
  boxed,

  /// Underline-only slots of the verification redesign (`verification.png`): no
  /// fill and no side borders, just a hairline rule under each digit, inked once
  /// the slot takes focus.
  underlined,
}

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.onChanged,
    this.focusBorderColor = AppColors.lightBlue,
    this.style = OtpFieldStyle.boxed,
    this.obscureDigits = false,
    this.autofocus = false,
  });

  final ValueChanged<String> onChanged;
  final Color focusBorderColor;
  final OtpFieldStyle style;

  /// Masks every typed digit as a bullet, which is the state the reference
  /// shows. Off by default, so the boxed screens keep revealing their digits.
  final bool obscureDigits;

  /// Focuses the first slot on mount, which is what puts the reference screen's
  /// keypad on screen and inks its first rule.
  final bool autofocus;

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;
  int _secondsRemaining = AppDimens.resendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppDimens.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(AppDimens.otpLength, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = AppDimens.resendCooldownSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _emitValue();
  }

  void _emitValue() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
  }

  bool get isComplete => _controllers.every((c) => c.text.isNotEmpty);

  String get code => _controllers.map((c) => c.text).join();

  int get secondsRemaining => _secondsRemaining;

  bool get canResend => _secondsRemaining == 0;

  void resend() {
    if (canResend) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.style) {
      OtpFieldStyle.boxed => _buildBoxedSlots(),
      OtpFieldStyle.underlined => _buildUnderlinedSlots(),
    };
  }

  /// Fixed-width boxes spread across the row — the original layout.
  Widget _buildBoxedSlots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        AppDimens.otpLength,
        (index) => _buildSlot(
          index,
          width: AppDimens.otpBoxWidth,
          decoration: _boxedDecoration(),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  /// Slots that flex to fill the row, separated by a fixed gap: the rule has to
  /// span each slot, so a fixed slot width would leave the row ragged on the
  /// narrowest phones.
  Widget _buildUnderlinedSlots() {
    final List<Widget> slots = <Widget>[];
    for (int index = 0; index < AppDimens.otpLength; index++) {
      if (index > 0) {
        slots.add(const SizedBox(width: AppDimens.otpSlotGap));
      }
      slots.add(
        Expanded(
          child: _buildSlot(
            index,
            decoration: _underlineDecoration(),
            // Lighter than the boxed digits: a masked bullet inherits this
            // weight, and the reference's dots stay small.
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ),
      );
    }
    return Row(children: slots);
  }

  Widget _buildSlot(
    int index, {
    required InputDecoration decoration,
    required TextStyle textStyle,
    double? width,
  }) {
    return SizedBox(
      width: width,
      height: AppDimens.otpBoxHeight,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        autofocus: widget.autofocus && index == 0,
        obscureText: widget.obscureDigits,
        obscuringCharacter: '•',
        cursorColor: widget.style == OtpFieldStyle.underlined
            ? AppColors.actionGreen
            : null,
        style: textStyle,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: decoration,
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }

  InputDecoration _boxedDecoration() {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
      borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
    );
    return InputDecoration(
      counterText: '',
      filled: true,
      fillColor: AppColors.inputSoft,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        borderSide: BorderSide(color: widget.focusBorderColor, width: 2),
      ),
    );
  }

  /// Hairline rule instead of a box: pale while the slot idles, ink once it has
  /// focus — the only state change the reference screen shows.
  InputDecoration _underlineDecoration() {
    return InputDecoration(
      counterText: '',
      isDense: true,
      contentPadding: const EdgeInsets.only(
        bottom: AppDimens.otpUnderlineContentBottom,
      ),
      border: _underline(AppColors.inputUnderline, AppDimens.otpUnderlineWidth),
      enabledBorder: _underline(
        AppColors.inputUnderline,
        AppDimens.otpUnderlineWidth,
      ),
      focusedBorder: _underline(
        AppColors.textDark,
        AppDimens.otpUnderlineFocusedWidth,
      ),
    );
  }

  UnderlineInputBorder _underline(Color color, double width) =>
      UnderlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
      );
}
