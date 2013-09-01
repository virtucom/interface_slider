import processing.serial.*;

Serial puerto;

Slider longitud, pausas, tiempoPausa;
Button programar, stop;
int desplazamiento, numero, tiempo, actual;
boolean finPrograma;
String entrada;

void setup(){
  size(600,220);
  
  puerto = new Serial(this, Serial.list()[0], 9600);
  
  longitud = new Slider("Longitud",1,0,1600,50,50,380,20,HORIZONTAL);
  pausas = new Slider("Paradas",1,0,100,50,100,380,20,HORIZONTAL);
  tiempoPausa = new Slider("Duración",1,0,120,50,150,380,20,HORIZONTAL); 
  
  programar = new Button("Programar",480,180,70,20);
  stop = new Button("Parar",300,180,70,20);
  desplazamiento = 1;
  numero = 1;
  tiempo = 1;
  
  finPrograma = true;
}

void draw()
{
  background(140);
  
  if (longitud.get()!=0) {
    desplazamiento = floor(longitud.get()/numero);
  }
  if (pausas.get()!=0) {
    numero = floor(pausas.get());
  }
  if (tiempoPausa.get()!=0) {
    tiempo = floor(1000*tiempoPausa.get());
  }
  
  longitud.display();
  pausas.display();
  tiempoPausa.display();  
  programar.display();
  stop.display();
  
  text(desplazamiento,495,65);
  text(numero,495,115);
  text(tiempo/1000,495,165);
}

void mousePressed()
{
  longitud.mousePressed();
  pausas.mousePressed();
  tiempoPausa.mousePressed();
  if(programar.mousePressed()){
    ejecutaPrograma(); 
  }
  if(stop.mousePressed()){
    puerto.write("s\n");
    puerto.write("d\n");
  }
}

void mouseDragged()
{
  longitud.mouseDragged();
  pausas.mouseDragged();
  tiempoPausa.mouseDragged();
}

void ejecutaPrograma(){
  for(int i=0; i< numero; i++){
    if(finPrograma == true){
      finPrograma = false;
      puerto.write("c\n");
      puerto.write("l 0 " + desplazamiento*100 + " 1000 500\n");
      puerto.write("g\n");
      finPrograma = true;
      puerto.write("d\n");
      actual = millis();
      while(millis()<(tiempo+actual)){
        println(tiempo+actual-millis());
      }
    }
  }
}
