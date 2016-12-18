import rita.*;


RiMarkov rm;

void setup() 
{
  size(300, 300);    
  fill(255);
  textFont(createFont("Georgia", 36));
  
  rm = new RiMarkov(3);
  rm.loadFrom("mid+xmas.txt", this);
  String[] results = rm.generateSentences(2);
  
  for (String res : results ){
    print(res);
  } 
}