local bit = loadstring(game:HttpGet("https://raw.githubusercontent.com/bitsplode/WeightV3/main/bit"))();

local private = {};
local public = {};
local aeslua = {}
aeslua.gf = public;

private.n = 0x100;
private.ord = 0xff;
private.irrPolynom = 0x11b;
private.exp = {};
private.log = {};

function public.add(operand1, operand2) 
	return bit.bxor(operand1,operand2);
end

function public.sub(operand1, operand2) 
	return bit.bxor(operand1,operand2);
end

function public.invert(operand)
	if (operand == 1) then
		return 1;
	end;
	local exponent = private.ord - private.log[operand];
	return private.exp[exponent];
end

function public.mul(operand1, operand2)
    if (operand1 == 0 or operand2 == 0) then
        return 0;
    end
	
    local exponent = private.log[operand1] + private.log[operand2];
	if (exponent >= private.ord) then
		exponent = exponent - private.ord;
	end
	return  private.exp[exponent];
end

function public.div(operand1, operand2)
    if (operand1 == 0)  then
        return 0;
    end
	local exponent = private.log[operand1] - private.log[operand2];
	if (exponent < 0) then
		exponent = exponent + private.ord;
	end
	return private.exp[exponent];
end

function public.printLog()
	for i = 1, private.n do
		print("log(", i-1, ")=", private.log[i-1]);
	end
end

function public.printExp()
	for i = 1, private.n do
		print("exp(", i-1, ")=", private.exp[i-1]);
	end
end

function private.initMulTable()
	local a = 1;

	for i = 0,private.ord-1 do
    	private.exp[i] = a;
		private.log[a] = i;

		a = bit.bxor(bit.lshift(a, 1), a);

		if a > private.ord then
			a = public.sub(a, private.irrPolynom);
		end
	end
end

private.initMulTable();

return public;
