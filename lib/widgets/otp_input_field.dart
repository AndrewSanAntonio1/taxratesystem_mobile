import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.onChanged,
    this.focusBorderColor = AppColors.lightBlue,
  });

  final ValueChanged<String> onChanged;
  final Color focusBorderColor;

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
    _controllers = List.generate(AppDimens.otpLength, (_) => TextEditingController());
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

  bool get isComplete =>
      _controllers.every((c) => c.text.isNotEmpty);

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(AppDimens.otpLength, (index) {
        return SizedBox(
          width: AppDimens.otpBoxWidth,
          height: AppDimens.otpBoxHeight,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.inputSoft,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
                borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
                borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
                borderSide: BorderSide(color: widget.focusBorderColor, width: 2),
              ),
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        );
      }),
    );
  }
}
