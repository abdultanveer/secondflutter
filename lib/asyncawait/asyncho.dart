
import 'dart:io';

void main() async{
  await hello();
  print('all done');
}
 Future<void> hello()async{
  print('hello');
  sleep(Duration(milliseconds: 5000));
  print('hello func complete');
 }