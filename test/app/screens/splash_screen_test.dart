import 'package:everstride/app/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onboarding not completed routes to /onboarding', () {
    expect(resolveSplashDestination(onboardingCompleted: false), '/onboarding');
  });

  test('onboarding completed routes to /home', () {
    expect(resolveSplashDestination(onboardingCompleted: true), '/home');
  });
}
