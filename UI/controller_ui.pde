/*
ToDo:
1. Burn the arduino RC CAR Code to the controller, 
2. Check for the connectivity of the 27MHz RC Controller
3. Now Run this Processing program to send Driving/Steering Command to the Arduino Micro controller
 */

/*
   'L' = LEFT      X = 0   to 225; Y = 250  to 250
   'R' = RIGHT     X = 275 to 500; Y = 250  to 250
   'F' = FORWARD   X = 250 to 250; Y = 0    to 225
   'B' = BACKWARD  X = 250 to 250; Y = 275  to 500

   '1' = FORWARD-LEFT      X = 0   to 225; Y = 0    to 225
   '2' = FORWARD-RIGHT     X = 275 to 500; Y = 0    to 225
   '3' = BACKWARD-LEFT     X = 0   to 225; Y = 275  to 500
   '4' = BACKWARD-RIGHT    X = 275 to 500; Y = 275  to 500
 */

/*
   if((x >= 0 && x <= 225) && (y == 250 ))       //Left
   if((x >= 275 && x <= 500) && (y == 250))     //Right
   if((x == 250) && (y >= 0 && y <= 225))      //Forward
   if((x == 250) && (y >= 275 && y <= 500))    //Backward

   if((x >=0 && x <= 225) && (y >= 0 && y <= 225))    //Forward-Left
   if((x >=275 && x <= 500) && (y >= 0 && y <= 225))    //Forward-Right
   if((x >=0 && x <= 225) && (y >= 275 && y <= 500))    //Backward-Left
   if((x >=275 && x <= 500) && (y >= 275 && y <= 500))    //Backward-Right
 */

import processing.serial.*;

import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent; 

Serial port; 
Robot robot;
int window_length = 525,     //actual size = 525
    window_breadth = 525,    //actual size = 525
    square_side = 15;

int mouse_update_count = 0;
int x = -1, y = -1;//mouse coordinates

int DIRECTION = -1;// 1 - FORWARD, 0 - BACKWARD
int FORWARD = 1;
int BACKWARD = 0;


int MODE,
    TOUCH=1,
    KEYBOARD=2,
    LOOP_CAR=3;

boolean left_key = false,
        right_key = false, 
        up_key = false, 
        down_key = false;

void setup() {
    MODE = KEYBOARD; // Change The mode for Mouse Touchpad based control
    size(window_length, window_breadth);
    //List all serial ports connected to the computer
    println(Serial.list()); 

    port = new Serial(this, Serial.list()[1], 9600);  //Serial.list[1] is the serial port where my arduino is connected

}

int keyboard_steer()
{
    if(keyPressed && (key == CODED)){ //Check which key is pressed
        if(keyCode == LEFT){
            left_key = true;  
        }
        else if(keyCode == RIGHT){
            right_key = true;  
        }
        else if(keyCode == UP){
            up_key = true;  
        }
        else if(keyCode == DOWN){
            down_key = true;  
        }
    }

    if(up_key && down_key){      //Invalid DO NOTHING
        port.write('I');       
        println("NO MOTION");   
    }else if(left_key && right_key){ //Invalid DO NOTHING
        port.write('I');       
        println("NO MOTION");   
    }else if(up_key && !down_key && !left_key && !right_key){
        port.write('F');       
        println("FORWARD");
    }else if(down_key && !up_key && !left_key && !right_key){
        port.write('B');       
        println("BACKWARD");
    }else if(left_key && !up_key && !down_key && !right_key){
        port.write('L');       
        println("LEFT");
    }else if(right_key && !up_key && !down_key && !left_key){
        port.write('R');       
        println("RIGHT");
    }else if(up_key && right_key && !down_key && !left_key){
        port.write('2');       
        println("FORWARD - RIGHT");
    }else if(up_key && left_key && !down_key && !right_key){
        port.write('1');       
        println("FORWARD - LEFT");
    }else if(down_key && right_key && !up_key && !left_key){
        port.write('4');       
        println("BACKWARD - RIGHT");
    }else if(down_key && left_key && !up_key && !right_key){
        port.write('3');       
        println("BACKWARD - LEFT");
    }else{
        port.write('I');       
        println("NO MOTION");   
    } 
    return 0;

}

void loop_car(int count)
{
    port.write('2');
    delay(100);
    port.write('R');
    delay(500);
    port.write('F');
    delay(100);
    port.write('R');
    delay(500);
    port.write('I');
}

int mouse_steer()
{
    rect(x, y, square_side, square_side);
    try {
      robot = new Robot();
    } 
    catch (Exception e) {
      println("Can't Initialize the Robot");
    }
    
    if(x==mouseX && y==mouseY){ //No Update in Mouse Acton
      println("NO MOUSE ACTION");
      delay(500);
      port.write('I');
      return -1;
    }  
  
    x=mouseX;
    y=mouseY;

    if (mousePressed) {
            println("BRAKE - MOUSE PRESSED");
            mouseX=254;
            mouseY=254;
            if(DIRECTION == BACKWARD){
                port.write('F');       
            }else {
                port.write('B');       
            }
            delay(500);
            port.write('I');       
            
        }else{
            println("MOUSE RELEASED");    
            if((x >= 0 && x <= 225) && (y > 250 && y < 275)){       //Left
                port.write('L');       
                println("LEFT");
            }else if((x >= 275 && x <= 500) && (y > 250 && y < 275)){     //Right
                port.write('R');       
                println("RIGHT");
            }else if((x > 250 && x < 275) && (y >= 0 && y <= 225)){      //Forward
                port.write('F');       
                println("FORWARD");
                DIRECTION = FORWARD;
            }else if((x > 250 && x < 275) && (y >= 275 && y <= 500)){   //Backward
                port.write('B');       
                println("BACKWARD");
                DIRECTION = BACKWARD;
            }else if((x >=0 && x <= 225) && (y >= 0 && y <= 225)){    //Forward-Left
                port.write('1');       
                println("FORWARD - LEFT");
                DIRECTION = FORWARD;
            }else if((x >=275 && x <= 500) && (y >= 0 && y <= 225)){    //Forward-Right
                port.write('2');       
                println("FORWARD - RIGHT");
                DIRECTION = FORWARD;
            }else if((x >=0 && x <= 225) && (y >= 275 && y <= 500)){    //Backward-Left
                port.write('3');       
                println("BACKWARD - LEFT");
                DIRECTION = BACKWARD;
            }else if((x >=275 && x <= 500) && (y >= 275 && y <= 500)){    //Backward-Right
                port.write('4');       
                println("BACKWARD - RIGHT");
                DIRECTION = BACKWARD;
            }else{
                port.write('I');       
                println("NO MOTION");   
            }      
        }
      
      
       //Mouse Boundary detection
       if(x<=10 || y<=10 || x >= 450 || y >= 450){
         robot.mouseMove(254,274);
         mouseX = 254;
         mouseY = 254;
       }
        return 0;
}


void draw() {
    background(200);//Fill Background with Color Grey
    fill(0); //Fill Color Black
    rect(0, 250, window_length, 25); //rect(column,row,length,bredth) --> Horizantal Line
    rect(250, 0, 25, window_breadth); //rect(column,row,length,bredth) --> Vertical Line
    fill(255); //Fill Color White

    //println("X = "+mouseX+"   Y = "+mouseY); //Print X and Y Coordinates of the mouse

    //Uncomment this and comment keypressed function, if you need mouse based driving control
    if(MODE == TOUCH){
         mouse_steer();
    }else if(MODE == KEYBOARD){
        keyboard_steer();
    }else if(MODE == LOOP_CAR){
      loop_car(20);
    }  
}
      
      
void keyReleased(){
    if(keyCode == LEFT){
        left_key = false;  
    }
    else if(keyCode == RIGHT){
        right_key = false;  
    }
    else if(keyCode == UP){
        up_key = false;  
    }
    else if(keyCode == DOWN){
        down_key = false;  
    }
}

