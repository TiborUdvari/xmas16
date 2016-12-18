import rita.*;

String syns="", word = "";
RiLexicon lexicon;

RiMarkov rm;

void setup() 
{
  size(300, 300);    
  fill(255);
  textFont(createFont("Georgia", 36));
  
  rm = new RiMarkov(4);
  rm.loadText("The girl went to a game after dinner. The teacher went to dinner with a girl.");
  String[] results = rm.generateSentences(2);
  
  for (String res : results ){
    print(res);
  } 
}