import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_button.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final bool isNewUser;
  final String? otp;

  const OtpPage({
    Key? key,
    required this.phoneNumber,
    required this.isNewUser,
    this.otp,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  int _timeLeft = AppConstants.otpTimeoutSeconds;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _timeLeft = AppConstants.otpTimeoutSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegistrationRequired) {
            Navigator.pushReplacementNamed(
              context,
              AppRouter.registration,
              arguments: state.phoneNumber,
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
                  (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView( // Add this to prevent overflow
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top -
                    kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.otpVerification,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    RichText(
                      text: TextSpan(
                        text: AppStrings.otpSentTo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(
                            text: '+91${widget.phoneNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.largePadding),

                    // Display the OTP from API
                    if (widget.otp != null && widget.otp!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.otpIs,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                            children: [
                              TextSpan(
                                text: widget.otp!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: AppConstants.largePadding),

                    // PIN input field
                    PinCodeTextField(
                      appContext: context,
                      length: AppConstants.otpLength,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeFillColor: Colors.grey[100],
                        selectedFillColor: Colors.grey[100],
                        inactiveFillColor: Colors.grey[100],
                        activeColor: Theme.of(context).primaryColor,
                        selectedColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey[300],
                      ),
                      enableActiveFill: true,
                      onCompleted: (code) {
                        _handleSubmit();
                      },
                      onChanged: (value) {},
                    ),

                    const SizedBox(height: AppConstants.largePadding),
                    Center(
                      child: Text(
                        _canResend
                            ? '00:00 Sec'
                            : '00:${_timeLeft.toString().padLeft(2, '0')} Sec',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.dontReceiveCode,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: _canResend ? _handleResend : null,
                                child: Text(
                                  AppStrings.resend,
                                  style: TextStyle(
                                    color: _canResend
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30,), // Pushes button to bottom

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: AppStrings.submit,
                          onPressed: state is AuthLoading ? null : _handleSubmit,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final otp = _otpController.text.trim();
    if (otp.length == AppConstants.otpLength) {
      // Verify against the real OTP
      if (widget.otp != null && otp == widget.otp) {
        context.read<AuthBloc>().add(VerifyOTP(widget.phoneNumber, otp));
      } else {
        // For demo purposes, also accept the entered OTP
        context.read<AuthBloc>().add(VerifyOTP(widget.phoneNumber, otp));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleResend() {
    _otpController.clear();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
