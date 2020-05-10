/*
ToDo:
  1. Burn this code to the Arduino Micro Controlled
  2. Run the processing code to send input to the Arduino Serial Port
  3. Arduino inturn forward the command to 27MHz transmitter

*/
int inByte = 0;         // Incoming Byte From Processing

int Left = 13;
int Right = 12;
int Forward = 2; 
int Backward = 4;

/*
    'L' = LEFT
    'R' = RIGHT
    'F' = FORWARD
    'B' = BACKWARD

    '1' = FORWARD-LEFT
    '2' = FORWARD-RIGHT
    '3' = BACKWARD-LEFT
    '4' = BACKWARD-RIGHT
*/

void setup()
{
    // start serial port at 9600 bps:
    Serial.begin(9600);
    
    pinMode(Left, INPUT); 
    pinMode(Right, INPUT); 
    pinMode(Forward, INPUT); 
    pinMode(Backward, INPUT); 

    while (!Serial) {
        // wait for serial port to connect.
    }
}

void loop()
{
    if (Serial.available() > 0) {
        pinMode(Left, INPUT); 
        pinMode(Right, INPUT); 
        pinMode(Forward, INPUT); 
        pinMode(Backward, INPUT); 
        // get incoming byte for steering control:
        inByte = Serial.read();
        if(inByte == 'F'){
            pinMode(Forward, OUTPUT); 
            digitalWrite(Forward, LOW);
        }else if(inByte == 'B'){
            pinMode(Backward, OUTPUT); 
            digitalWrite(Backward, LOW);
        }else if(inByte == 'L'){
            pinMode(Left, OUTPUT); 
            digitalWrite(Left, LOW);
        }else if(inByte == 'R'){
            pinMode(Right, OUTPUT); 
            digitalWrite(Right, LOW);
        }else if(inByte == '1'){ //FORWARD-LEFT
            pinMode(Forward, OUTPUT); 
            pinMode(Left, OUTPUT); 
            digitalWrite(Forward, LOW);      
            digitalWrite(Left, LOW);      
        }else if(inByte == '2'){ //FORWARD-RIGHT
            pinMode(Forward, OUTPUT); 
            pinMode(Right, OUTPUT); 
            digitalWrite(Forward, LOW);      
            digitalWrite(Right, LOW);      
        }else if(inByte == '3'){ //BACKWARD-LEFT
            pinMode(Backward, OUTPUT); 
            pinMode(Left, OUTPUT); 
            digitalWrite(Backward, LOW);      
            digitalWrite(Left, LOW);      
        }else if(inByte == '4'){ //BACKWARD-RIGHT
            pinMode(Backward, OUTPUT); 
            pinMode(Right, OUTPUT); 
            digitalWrite(Backward, LOW);      
            digitalWrite(Right, LOW);      
        }
    } 
}


