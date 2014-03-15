unit derivativeFunctions;
{Unit containing functions used to calculate derivatives.}

interface
 uses sysutils,
      analyzingFunctions,
      checkFunctions,
      ioFunctions,
      log;

 function unaryDerivative(str : string) : string;
 function binaryDerivative(str : string) : string;
 function elementaryDerivative(str : string) : string;
 function findDerivative(var str : string) : string;

implementation

 function unaryDerivative(str : string) : string;
 {Returns derivative of an unary function.
  (One that takes only one argument.)}
 var arg1,temp,tempDer : string;  {Arg1 is used to prevent multiple calls of getArg() functions, other variables are temporary strings.}
 begin
  arg1:= getArg(str).first;
  temp:= getFunction(str);
  
  logStr:= 'Calculating derivative of ' + temp + ' with argument ' + arg1 + '.';
  addRecord(logStr);  {LOG}

  if isNumeric(arg1) OR isConst(arg1) then
  begin
   unaryDerivative:= '0';
   exit;
  end;
   
  case temp of
   'cos' : tempDer:= '-sin(' + arg1 + ')';
   'sin' : tempDer:= 'cos(' + arg1 + ')';
   'tan' : tempDer:= 'pow(sec(' + arg1 + '),2)';
   'cot' : tempDer:= '-pow(csc(' + arg1 + '),2)';
   'sec' : tempDer:= 'sec(' + arg1 + ')*tan(' + arg1 + ')';
   'csc' : tempDer:= '-csc(' + arg1 + ')*cot(' + arg1 + ')';
   'arcsin' : tempDer:= '1/pow(' + '1-pow(' + arg1 + ',2)' + ',0.5)';
   'arccos' : tempDer:= '-1/pow(' + '1-pow(' + arg1 + ',2)' + ',0.5)';
   'atctan' : tempDer:= '1/(1+' + 'pow(' + arg1 + ',2))';
   'arccot' : tempDer:= '-1/(1+' + 'pow(' + arg1 + ',2))';
   'sinh' : tempDer:= 'cosh(' + arg1 + ')';
   'cosh' : tempDer:= 'sinh(' + arg1 + ')';
   'tanh' : tempDer:= '(1-pow(tanh(' + arg1 + ',2)))';
   'coth' : tempDer:= '(1-pow(coth(' + arg1 + ',2)))';
   'sech' : tempDer:= '-tanh(' + arg1 + ')*sech(' + arg1 + ')';
   'csch' : tempDer:= '-coth(' + arg1 + ')*csch(' + arg1 + ')';
   'exp' : tempDer:= 'exp(' + arg1 + ')';
   'ln' : tempDer:= '1/(' + arg1 + ')';
  else tempDer:= 'NaF';
  end;
  
  if arg1 <> 'x' then tempDer:= tempDer + '*' + '(' + findDerivative(arg1) + ')'; {Brackets in case the argument is sum of functions.}
  
  unaryDerivative:= tempDer; 
  
  logStr:= 'Derivative of ' + temp + ' with argument ' + arg1 + ' = ' + tempDer + '.';
  addRecord(logStr);  {LOG} 
 end;
 
 function binaryDerivative(str : string) : string;
 {Returns derivative of a binary function. (pow(a,b))}
 var arg1, arg2 : string;  {Used to prevent multiple calls of getArg() function.}
     temp, tempError : integer;  {Temportary integers.}
 begin
  arg1:= getArg(str).first;
  arg2:= getArg(str).second;
  
  logStr:= 'Calculating derivative of power functions with arguments ARG #1 = ' + arg1 + ' and ARG #2 = ' + arg2 + '.';
  addRecord(logStr);  {LOG}
  
  if isNumeric(arg1) OR isConst(arg1) then
   if isNumeric(arg2) OR isConst(arg2) then {(a^b)' = 0}
    binaryDerivative:= '0'
   else binaryDerivative:= 'pow(' + arg1 + ',' + arg2 + ')' + '*' + elementaryDerivative(arg2) + '*ln(' + arg1 + ')'   {(a^x)' = a^x * x' * ln(a)}
  else if isNumeric(arg2) then {(x^const)' = const*x^(const-1)}
        begin
         Val(arg2, temp, tempError);
         binaryDerivative:= arg2 + '*pow(' + arg1 + ',' + IntToStr(temp - 1) + ')';
		 if (arg1 <> 'x') then binaryDerivative:= binaryDerivative + '*' + findDerivative(arg1)
        end
       else if isConst(arg2) then 
             binaryDerivative:= arg2 + '*pow(' + arg1 + ',' + arg2 + '-1)'
            else binaryDerivative:= '(NaF)';
            
  logStr:= 'Derivative of pow(' + arg1 + ',' + arg2 + ') =  ' + binaryDerivative + '.';
  addRecord(logStr);  {LOG}
 end;

 function elementaryDerivative(str : string) : string;
 {Function that determines if to use unary or binary
  derivative function.}
 begin
  if isBinary(str) then elementaryDerivative:= binaryDerivative(str)
  else elementaryDerivative:= unaryDerivative(str);
 end; 


 function findDerivative(var str : string) : string; 
 {Returns derivative of the input function.}
 var bracketsDeleted : boolean;  {Used to detect if bracket addition is needed at the end.}
     tempLeft, tempRight : string;  {Used to prevent unnecessary calling of separate() function.}
     tempStr : string;  {Used for better code readability.}
     tempOper : char;  {Used to prevent unnecessary calling of separate() function.}
 begin
  logStr:= 'Finding derivative of ' + str + '.';
  addRecord(logStr);  {LOG}
  
  bracketsDeleted:= delBrackets(str);  {To re-add deleted brackets.}
  tempLeft:= separate(str).left;
  tempRight:= separate(str).right;
  tempOper:= separate(str).oper;
  tempStr:= '';
  
 if isElementary(str) then
  tempStr:= elementaryDerivative(str)
 else if containsOperator(str) then
       case tempOper of
        '+' : tempStr:= findDerivative(tempLeft) + '+' + findDerivative(tempRight);
        '-' : tempStr:= findDerivative(tempLeft) + '-' + findDerivative(tempRight);
        '*' : begin
			   tempStr:= findDerivative(tempLeft) + '*';
			   if containsOperator(tempRight) then  {Adding brackets if needed.}
                tempStr:= tempStr + '(' + tempRight + ')'
               else tempStr:= tempStr + tempRight;
               
               tempStr:= tempStr + '+';
               if containsOperator(tempLeft) then  {Adding brackets if needed.}
                tempStr:= tempStr + '(' + tempLeft + ')'
               else tempStr:= tempStr + tempLeft;
               tempStr:= tempStr + '*' + findDerivative(tempRight);               
		      end;
        '/' : tempStr:= '(' + findDerivative(tempLeft) + '*' + tempRight + '-' +
                               tempLeft + '*' + findDerivative(tempRight) + ')/pow(' +
                               tempRight + ',2)';
       end
      else if isNumeric(str) OR isConst(str) then tempStr:= '0'
           else if (str = 'x') then tempStr:= '1'
                else tempStr:= 'NaF';  {Not a function.} 
  
  findDerivative:= tempStr;
  if bracketsDeleted then findDerivative:= '(' + findDerivative + ')'; 
 end;

end.
