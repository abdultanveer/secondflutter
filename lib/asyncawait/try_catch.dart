void main(){

  try {
    throw new Exception("couln't connect to the internet");
  }
  catch(Exception ){
    print('internet not available');
  }
  finally{
    print('bring groceries');
  }
  print('rest of the code');

}