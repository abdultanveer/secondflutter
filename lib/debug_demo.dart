void main(){
  print('10000 lines of code');
  add(10,20);
  throw new Exception('demmo');

  print('rest of the code');
}

void add(int i, int j) {
  i++;
  j++;
  print('object ${i+j}');

}