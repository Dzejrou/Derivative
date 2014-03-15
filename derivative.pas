program derivative;
{$R+} {$Q+} {$I+}
{Derivative calculating program.
 Created by Jaroslav Jindrak for the subject NPRG030 Programovani I
 in winter semester 2013/2014 at Faculty of Mathematics and Physics
 (Charles' University in Prague, Czech Republic).}

uses sysutils,                             {For function DateTimeToStr() and time(), used in the log.}
     checkFunctions,                       {checkFunction.pas, boolean functions.}
     analyzingFunctions,                   {analyzingFunctions.pas, string checking/modifying functions.}
     derivativeFunctions,                  {derivativeFunctions.pas, functions used to calculate derivative form of a function.}
     ioFunctions,                          {ioFunction.pas, procedures for input/output.}
     log,                                  {Creates and manages log.txt used for debugging and/or checking of the program's progress.}
     crt,                                  {For function clrscr, which clears the console.}
     menuFunctions;                        {menuFunctions.pas, text and prompts for the program's menu.}

var choice : integer;  {Variable for users choice in the menu.}
    choiceStr : string;  {String variable used to avoid errors from char/string input.}
    errorTemp : integer;  {Error variable for Val() function.}

procedure initialize;
{Initialization of loop variable and creation of the log.}
begin
 loop:= FALSE;
 createLog;
 if not FileExists('log.txt') then rewrite(f);
 logStr:= 'Starting program, creating log at time ' + TimeToStr(time());
 addRecord(logStr);  {LOG}
end;

procedure getDerivative;
{Calculates and outputs the derivative.}
var temp : string;
begin
 clrscr;
 intro;
 getInput;
 temp:= findDerivative(input);
 getOutput(temp);
end;

begin
{Main program part.}
 initialize;
 while not loop do
  begin
   clrscr;
   intro;
   menu;
   write('> ');
   readln(choiceStr);

   if (choiceStr = '1') OR (choiceStr = '2') OR
      (choiceStr = '3') OR (choiceStr = '3') OR
      (choiceStr = '4') OR (choiceStr = '5') then
      begin
       Val(choiceStr,choice,errorTemp);
       case choice of
        1 : getDerivative;
        2 : help;
        3 : useLog;
        4 : about;
        5 : exampleSet;
      end
     end
   else
    begin
     writeln('Invalit input, press enter to try again.');
     readln;
    end;

   promptEnding;
  end;
 logStr:= 'Ending the program.';
 addRecord(logStr);

 logStr:= '';
 addRecord(logStr);
 addRecord(logStr);
 addRecord(logStr);
 writeln('Good bye!');
end.
