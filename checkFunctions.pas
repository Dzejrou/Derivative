unit checkFunctions;
{Unit containing boolean functions.}

interface
 uses analyzingFunctions,
      log;

 function isNumeric(str : string) : boolean;
 function isConst(str : string) : boolean;
 function isOperator(str : char) : boolean;
 function isElementary(str : string) : boolean;
 function isBinary(str : string) : boolean;
 function containsOperator(str : string) : boolean;
 function isEncapsulated(str : string; index : integer) : boolean;


implementation

 function isNumeric(str : string) : boolean;
 {Checks if str is a number.}
 var temp1, tempErr : integer;  {tempError is used in Val() function for errors.}
     temp2 : real;
     tempResult : boolean;
 begin
  {Is it an integer?}
  Val(str, temp1, tempErr); 
  tempResult:= (tempErr = 0);
  
  if not tempResult then
  {Is it floating point value?}
   begin
    Val(str, temp2, tempErr);
    tempResult:= (tempErr = 0);
   end;
  isNumeric:= tempResult;
 end;
 
 function isConst(str : string) : boolean;  
 {Checks if str is constant (=does not contain the x variable).}
 begin
  if (Pos('x',str) = 0) then isConst:= TRUE
  else isConst:= FALSE;
 end;
 
 function isOperator(str : char) : boolean;  
 {Checks if str is an operator.}
 begin
  if (str = '+') OR (str = '-') OR (str = '*') OR (str = '/') then isOperator:= TRUE
  else isOperator:= FALSE;
 end;
 
 function isElementary(str : string) : boolean;
 {Checks if str is elementary function.}
 var temp : string;
 begin
  temp:= getFunction(str);
  if not containsOperator(str) OR (containsOperator(str) AND isEncapsulated(str,leastSignificantOperator(str))) then
   begin
    if (temp = 'cos') OR (temp = 'exp') OR
       (temp = 'sin') OR (temp = 'ln') OR
       (temp = 'tan') OR (temp = 'pow') OR
       (temp = 'cot') OR (temp = 'arcsin') OR
       (temp = 'sec') OR (temp = 'arccos') OR
       (temp = 'csc') OR (temp = 'arctan') OR
       (temp = 'sinh') OR (temp = 'arccot') OR
       (temp = 'cosh') OR (temp = 'sech') OR
       (temp = 'tanh') OR (temp = 'csch') OR
       (temp = 'coth') OR (temp = 'arctan')
    then isElementary:= TRUE else isElementary:= FALSE;
   end else isElementary:= FALSE;
 end; 
 
 function isBinary(str : string) : boolean;
 {Checks if a function is binary (has two arguments).}
 begin
  if (getFunction(str) = 'pow') then isBinary:= TRUE  {Power is the only binary function in this program at the moment.}
  else isBinary:= FALSE;
 end;
 
 function containsOperator(str : string) : boolean;
 {Checks for an operator inside the string.}
 begin
  if (Pos('+',str) = 0) AND (Pos('-',str) = 0) AND (Pos('*',str) = 0) AND (Pos('/',str) = 0) then
   containsOperator:= FALSE
  else
   containsOperator:= TRUE;
 end;
 
 function isEncapsulated(str : string; index : integer) : boolean;
 {Checks if str[i] is encapsulated by brackets for operator priority decisions.}
 var bracketCount,i : integer;
     temp : boolean;
 begin
  bracketCount:= 0;
  temp:= FALSE;
  
  for i:= index + 1 to length(str) do
   begin
    if (str[i] = '(') then
     Inc(bracketCount)
    else if (str[i] = ')') AND (bracketCount = 0) then
          begin  {Found a not-paired bracket, so the second one has to be before str[i].}
           temp:= TRUE;
           break;
          end
         else if (str[i] = ')') then
               Dec(bracketCount);
   end;
   
  isEncapsulated:= temp;   
 end;
 
 end.
