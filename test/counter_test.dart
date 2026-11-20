import 'package:secondflutter/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();
    int actual = counter.value;
    int expected = 2;
    expect(actual,expected);
  });

  test('Counter value should be decremented', () {
    final counter = Counter();

    counter.decrement();
    int actual = counter.value;
    int expected = 9;
    expect(actual,expected);
  });
}