int showsize = 2;
float maxwell[] = new float[100];
float sum=0;
Orbiter [] planet;
ArrayList<Photon> photon =new ArrayList<Photon>();
float dt=0.01;
float t=0.0005;  //  t/dt = probability
float E=30;    // photon's energy
int num=1000;   // orbiter number
float cross_section=150;  //  (collision radius)^2
float phot_age=2;  //  the age(frame) that photon starts to collide
float c=100; //  light's speed
float phsize=1;
float planetsize=1;
float G=30;
float R=350;
float T=100; // originally 200
import gifAnimation.*;
GifMaker gifExport;
PImage gif;
PrintWriter output;
int photoncnt;
void setup(){
    gifExport = new GifMaker(this,"hierachical_fragmentation.gif");
    gifExport.setRepeat(0);
    size(700,700);
    planet = new Orbiter[num];
    for(int i=0; i<100; i++){
        float V;
        V=i/T;
        maxwell[i]=V*V*exp(-V*V/T);
        sum+=maxwell[i];
    }
    for(int i=0; i<100; i++) maxwell[i]/=sum;
    for(int i=1; i<100; i++) maxwell[i]+=maxwell[i-1];
    for(int i = 0; i < planet.length; i++){
        float r,ran_theta_position;
        float ran_v,ran_theta_velocity;
        r=random(0,122500);
        r=sqrt(r);
        ran_v=random(0,1);
        int j;
        for(j=0; j<100; j++) if(ran_v<maxwell[j]) break;
        ran_v=j/10.0;
        ran_theta_position=random(0,6.2832);
        ran_theta_velocity=random(0,6.2832);
        planet[i] = new Orbiter(350+r*cos(ran_theta_position), 350+r*sin(ran_theta_position), planetsize, ran_v*cos(ran_theta_velocity), ran_v*sin(ran_theta_velocity));
    }                                                    //positioning particles&velocity
    noStroke();
    smooth();
    output = createWriter("photoncnt.txt");
}//setup simulation screen
void draw(){
    photoncnt = 0;
    background(0);
    fill(255,255,255);
    for(int i = 0; i < planet.length; i++){
        planet[i].grav(planet);                                                                              //gravity of each particle and give them accelation
        planet[i].draw();                                                                                             //show particles in screen
        //planet[i].keepOnScreen();                                                                                     //to keep particles on screen
    }
    fill(255,255,0);
    for(int i = 0; i < photon.size(); i++){
        photon.get(i).move();
        ellipse((float)photon.get(i).x,(float)photon.get(i).y,showsize*phsize,showsize*phsize);
    }
    for(int i = 0; i < photon.size(); i++){
    if(photon.get(i).x<0||photon.get(i).x>width||photon.get(i).y<0||photon.get(i).y>height)     photon.remove(i);
    }
    
    for(int i=0; i<num; i++){
        for(int j=0; j<photon.size(); j++){
            if(photon.get(j).age>phot_age){
                if((planet[i].x-photon.get(j).x)*(planet[i].x-photon.get(j).x)+(planet[i].y-photon.get(j).y)*(planet[i].y-photon.get(j).y)<cross_section){
                    photon.remove(j);
                    planet[i].kEchange(E);
                }
            }
        }/*
  for(int j=0;j<i-1;j++)
  {
    float temp = sq(planet[i].x-planet[j].x) + sq(planet[i].y-planet[j].y);
    if(temp != 0 && sqrt(temp) < (sqrt(planet[i].mass) + sqrt(planet[j].mass)) / 4.0) // important!! This determines whether or not the adjacent planets to merge.
    {
      planet[i].xVel = (planet[i].mass * planet[i].xVel + planet[j].mass * planet[j].xVel) / (planet[i].mass + planet[j].mass);
      planet[i].yVel = (planet[i].mass * planet[i].yVel + planet[j].mass * planet[j].yVel) / (planet[i].mass + planet[j].mass);
      planet[i].mass = planet[i].mass + planet[j].mass;
      planet[j].mass = 0;
    }
  }*/
    }
    gifExport.setDelay(1);
    gifExport.addFrame();
    output.println(photoncnt);
}
void keyPressed()
{
    if(key == 32){ // spacebar
      gifExport.finish();
      output.flush();
      output.close();
      exit();
    }
}
class Photon
{
    int age=0;
    double x,y,vx,vy;
    Photon(double x,double y,double vx,double vy){
        this.x=x;
        this.y=y;
        this.vx=vx;
        this.vy=vy;
    }
    void move(){
        age++;
        x+=vx;
        y+=vy;
        /*
        if(x<0) {vx=-vx; x=-x;}
        if(x>width) {vx=-vx; x=2*width-x;}
        if(y<0) {vy=-vy; y=-y;}
        if(y>height) {vy=-vy; y=2*height-y;}
        */
    }
}
class Orbiter                                                                                              //Everything about particle's movement
{
    float x, y, xVel, yVel, mass,dist;
    Orbiter(float x, float y, float mass, float xVel, float yVel)
    {
        this.x = x;
        this.y = y;
        this.mass = mass;
        this.xVel = xVel;
        this.yVel = yVel;
    }                                                                                                    //information of each particle(location&mass)
    /*
    void merge(Orbiter [] other){
      for(int i = 0; i < other.length; i++){
          float temp = sq(other[i].x-x)+sq(other[i].y-y);
          if(temp !=0 && sqrt(temp) < (sqrt(mass) + sqrt(other[i].mass))/40.0){
            xVel = (mass * xVel + other[i].mass * other[i].xVel) / (mass + other[i].mass);
            yVel = (mass * yVel + other[i].mass * other[i].yVel) / (mass + other[i].mass);
            mass += other[i].mass;
            planet.remove(i);
          }
        }
    }
    */
    void grav(Orbiter [] other)                                                                                          //Gravity of each particles
    {
        //
        float yGrav=0.0;
        for(int i=0; i<other.length; i++){
            if(y>other[i].y){
                if(dist(other[i].x, other[i].y, x, y)<20) dist=20;
                else dist=dist(other[i].x, other[i].y, x, y);
                yGrav-=(mass * other[i].mass) / sq(dist)*abs(other[i].y-y)/dist(other[i].x, other[i].y, x, y) * G;
            }
            if(y<other[i].y){
                if(dist(other[i].x, other[i].y, x, y)<20) dist=20;
                else dist=dist(other[i].x, other[i].y, x, y);
                yGrav+=(mass * other[i].mass) / sq(dist)*abs(other[i].y-y)/dist(other[i].x, other[i].y, x, y) * G;
            }
        }
        float yAccel=yGrav/mass;
        yVel += yAccel*0.5;
        y += yVel*0.5;
        
        float xGrav=0.0;
        for(int i=0; i<other.length; i++){
            if(x>other[i].x){
                if(dist(other[i].x, other[i].y, x, y)<20) dist=20;
                else dist=dist(other[i].x, other[i].y, x, y);
                xGrav-=(mass * other[i].mass) / sq(dist)*abs(other[i].x-x)/dist(other[i].x, other[i].y, x, y) * G;
            }
            if(x<other[i].x){
                if(dist(other[i].x, other[i].y, x, y)<20) dist=20;
                else dist=dist(other[i].x, other[i].y, x, y);
                xGrav+=(mass * other[i].mass) / sq(dist)*abs(other[i].x-x)/dist(other[i].x, other[i].y, x, y) * G;
            }
        }
        float xAccel=xGrav/mass;
        xVel += xAccel*0.5;
        x += xVel*0.5;
        
        cooling();
    }
    
    void cooling(){
        float v=sqrt(kE());
        if(kE()>E){
            if(random(0,1000000)<1000000*t/dt*v){
                float theta=random(0,6.283);
                Photon pp=new Photon(x,y,c*sin(theta),c*cos(theta));
                photon.add(pp);
                kEchange(-E);
                photoncnt++;
            }
        }
    }

    float kE(){
        return (float)(xVel*xVel+yVel*yVel);}
    void kEchange(float e){
        float r=(kE()+e)/kE();
        r=sqrt(r);
        xVel*=r;
        yVel*=r;
    }
    void keepOnScreen()                                                                                             //to keep all particles on screen
    {
        if(x  > width) xVel=-xVel;
        if(y  > height) yVel=-yVel;
        if(x  < 0) xVel=-xVel;
        if(y  < 0) yVel=-yVel;
    }
    void draw(){
        ellipse(x, y, showsize*sqrt(mass), showsize*sqrt(mass));
    }
}

