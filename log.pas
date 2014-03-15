unit log;
{Unit cointaing log related procedures.}

interface
 var f : text;  {Variable assigned to 'log.txt' file.}
     logStr : string;  {Used as temportary variable for the addRecord() parameter.}
 
 procedure createLog;
 procedure addRecord(str : string);
 procedure eraseLog;
 procedure readLog;
 procedure useLog;

implementation
 uses crt,
      menuFunctions;
 
 procedure createLog;
 {Assigns the log file to the f variable.}
 begin
  assign(f,'log.txt');
 end;

 procedure addRecord(str : string);
 {Appends (adds to the end of file) str to the log file f.}
 begin
  append(f);
  writeln(f,str);
  close(f);
 end;

 procedure eraseLog;
 {Erases all data from 'log.txt'.}
 begin
  rewrite(f);
  close(f);
 end;
 
 procedure readLog;
 {Prints all the lines cointained in 'log.txt'.}
 var temp : string;
 begin
  reset(f);
  while not EOF(f) do
   begin
    readln(f,temp);
    writeln(temp);
   end;
  close(f);
 end;

 procedure useLog;
 {Prints log submenu and promts user's choice.}
 var temp : string;
 begin
  clrscr;
  intro;
  menu;
  writeln('1: Show log');
  writeln('2: Erase log');
  write('> ');
  readln(temp);
  if (temp = '2') then eraseLog
  else readLog;
 end;
 
end.
