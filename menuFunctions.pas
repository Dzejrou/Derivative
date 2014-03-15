unit menuFunctions;
{Unit containing menu related procedures.}

interface
 var loop : boolean;  {Variable directing the main loop.}

 procedure intro;
 procedure menu;
 procedure ending(answer : char);
 procedure promptEnding;
 procedure help;
 procedure about;
 procedure exampleSet;
 
implementation
 uses derivativeFunctions,
      ioFunctions;

 procedure intro;
 {Displays the header.}
 begin
  writeln(' _______________________________ ');
  writeln('|Welcome to derivative v1.0     |');
  writeln('|      created by dzejrou.      |');
  writeln('|_______________________________|');
 end;
 
 procedure menu;
 {Displays the main menu.}
 begin
  writeln('|_______________________________|');
  writeln('|Choose from the menu below:    |');
  writeln('|1: Derivative calculation      |');
  writeln('|2: Help                        |');
  writeln('|3: Log                         |');
  writeln('|4: About                       |');
  writeln('|5: Example set                 |');
  writeln('|_______________________________|'); 
 end;
 
 procedure ending(answer : char);
 {Changes loop variable based on the user's input.}
 begin
  if (answer = 'Y') OR (answer = 'y') then
   loop:= FALSE
  else if (answer = 'N') OR (answer = 'n') then
        loop:= TRUE
       else begin
             writeln('Wrong input, assuming "Y" as input.');
             loop:= FALSE;
            end;
 end;
 
 procedure promptEnding;
 {Asks the user if he wants to continue and calls
  the ending procedure to change the loop variable
  if necessary.}
 var temp : char;
 begin
  writeln('Do you wish to try another function? Y/N');
  readln(temp);
  ending(temp);
 end;
 
 procedure help;
 {Displays brief in-program help text.}
 begin
  writeln('Menu options:');
  writeln('1: Main part of this program, calculates a derivative of your function.');
  writeln('   (Note: You can use both pow(a,b) and a^b for a to the power of b function.');
  writeln('          For square root, use pow(x,0.5).)');
  writeln('2: Contains the help you can find yourself in now.');
  writeln('3: Shows log of your previous operations, it is saved inside the file');
  writeln('   called log.txt until its erased.');
  writeln('4: Brief info about the program and its creator.');
  writeln('5: Small set of example functions you can use.');
 end;
 
 procedure about;
 {Displays brief info about the program and it's creator.}
 begin
  writeln('This program was created by dzejrou (Jaroslav Jindrak) in February 2014');
  writeln('as semestral work for the course NPRG030 at MFF UK in Prague.');
  writeln('Main purpose of this program is to calculate the derivative form of');
  writeln('an input function.');
 end;
 
 procedure exampleSet;
 {Displays few pre-written functions for the user
  to choose from.}
 var temp1,temp2 : string;
 begin
  writeln('Choose one of the functions below:');
  writeln('1: sin(x)');
  writeln('2: tanh(x)');
  writeln('3: lg(3)');
  writeln('4: cos(x) + sin(x)');
  writeln('5: x^4 * cos(x)');
  writeln('6: exp(cos(sin(x))) + sin(x^2)/exp(x)');
  writeln('7: sinh(x)/exp(x)');
  writeln('8: x^4 + x^3 + x^2 + x + 1');
  writeln('9: (x^cos(x) - sin(x))/cosh(x)');
  write('> ');
  readln(temp1);
  
  case temp1 of
   '1' : temp2:= 'sin(x)';
   '2' : temp2:= 'tanh(x)';
   '3' : temp2:= 'lg(3)';
   '4' : temp2:= 'cos(x)+sin(x)';
   '5' : temp2:= 'pow(x,4)*cos(x)';
   '6' : temp2:= 'exp(cos(sin(x)))+sin(pow(x,2))/exp(x)';
   '7' : temp2:= 'sinh(x)/exp(x)';
   '8' : temp2:= 'pow(x,4)+pow(x,3)+pow(x,2)+pow(x,1)';
   '9' : temp2:= '(x^cos(x)-sin(x))/cosh(x)';
  end;
  temp1:= findDerivative(temp2);
  getOutput(temp1);
 end;
 
end.
