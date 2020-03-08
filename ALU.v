`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:45 01/25/2020 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(a,b,zero,o_p,signal,shiftamt,flag,signctl);
input signctl;
input [31:0]a;// The first input is a 32 bit register.
input [31:0]b;// The second input is a 32 bit register.
input [4:0]shiftamt;// The shift amount is at max 32 bits, thus only 5 bits are needed to represent it.
input [4:0]signal;// This is the ALU Control. My ALU can support a maximum of 32 operations at present. However, This can be updated according to the need.
output reg [31:0] o_p;// The output is 32 bits as well.
output reg zero,flag;// The zero flag is used to control the IFU for branch instructions. The flag is used for overflow detection.
always @(*)
	begin
	o_p = 0;// The next 3 lines are setting the default values
	zero=0;
	flag=0;
	if (signal == 0)// add
	begin
		{flag,o_p} = a+b;
	end
	else if(signal == 1)// sub
	begin
		o_p = a-b;
		  if (o_p == 0)
		begin
			zero=1;
		end
	end
	else if(signal == 2)// and
	begin
		o_p = a & b;
	end
	else if(signal == 3)// or
	begin
		o_p = a | b;
	end
	else if(signal == 4)// nor
	begin
		o_p = ~a & ~b;
	end
	else if(signal == 5)// srl
	begin
		o_p = b>>shiftamt;
	end
	else if(signal == 6)//slt
	begin
	if(signctl==0)
	begin
		if(a<b)
		begin
		o_p = 1;
		end
    end
    else if(signctl ==1)
    begin
    if($signed(a) < $signed(b))
    begin
    o_p=1;
    end
    end
	end
	else if(signal == 7)
	begin
		if(a>b)
		begin
			o_p = 1;
		end
	end
	else if(signal == 8)// xor
	begin
	o_p = a ^ b;
	end
	else if(signal == 9) // sra
    begin
    o_p= b>>>shiftamt;
    end
    else if(signal ==10)// bgtz
    begin
    if($signed(a)>0)
    begin
    zero=1;
    end
    end
    else if(signal ==11)// blez
        begin
        if($signed(a)<=0)
        begin
        zero=1;
        end
        end
    else if(signal ==12) // bne
            begin
            if(a!=b)
            begin
            zero=1;
            end
            end
   else if(signal ==13) // sll
   begin
   o_p = b<<shiftamt;
   end
end
endmodule
