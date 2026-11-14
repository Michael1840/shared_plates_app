import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/domain/step_timer.dart';

void main() {
  group('StepTimer.parse', () {
    test('reads simple durations', () {
      expect(StepTimer.parse('Simmer for 20 minutes.'), 1200);
      expect(StepTimer.parse('Bake 45 min until golden'), 2700);
      expect(StepTimer.parse('Rest for 30 seconds'), 30);
      expect(StepTimer.parse('Roast for 2 hours'), 7200);
    });

    test('uses the low end of a range', () {
      expect(StepTimer.parse('Cook 8-10 minutes'), 480);
      expect(StepTimer.parse('Cook 8 to 10 minutes'), 480);
    });

    test('adds joined parts', () {
      expect(StepTimer.parse('Braise 1 hour 30 minutes'), 5400);
      expect(StepTimer.parse('Bake 1 hour and 15 minutes'), 4500);
    });

    test('understands words', () {
      expect(StepTimer.parse('Simmer for five minutes'), 300);
      expect(StepTimer.parse('Leave for half an hour'), 1800);
      expect(StepTimer.parse('Give it a minute'), 60);
    });

    test('only takes the first duration', () {
      expect(StepTimer.parse('Fry 2 min, then simmer 20 min'), 120);
    });

    test('ignores lines without a duration', () {
      expect(StepTimer.parse('Season with salt and serve.'), isNull);
      expect(StepTimer.parse('Add 2 tomatoes'), isNull);
      expect(StepTimer.parse('Preheat oven to 180 C'), isNull);
      expect(StepTimer.parse('I am stirring'), isNull);
    });

    test('prefers the explicit timer', () {
      expect(StepTimer.secondsFor(explicit: 90, body: 'Cook 20 min'), 90);
      expect(StepTimer.secondsFor(explicit: null, body: 'Cook 20 min'), 1200);
    });
  });

  test('clock formats remaining time', () {
    expect(StepTimer.clock(65), '1:05');
    expect(StepTimer.clock(599), '9:59');
    expect(StepTimer.clock(3725), '1:02:05');
    expect(StepTimer.clock(-3), '0:00');
  });
}
