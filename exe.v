`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2020 19:21:21
// Design Name: 
// Module Name: exe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//  
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module exe(output [31:0] inst,input clk,output reg [31:0] reg_out,output reg [31:0] main_out,output regdst,output regwr,output savepc,output extop,output [4:0]signal,output alusrc,output memwr,output memtoreg,output jump,output branch,output signctl,output [31:0]o_p,output reg [31:0] nextinst,output shiftctl,output reg[31:0]final_write,output reg [31:0] b, output [31:0]a,output [4:0]rs,output [4:0]rt,output [4:0]rd);
reg[31:0] imm;
wire [15:0] beq_offset;
wire [25:0] jump_offset;
reg [31:0] final_write_add;
reg [ 4:0] shiftamt;
wire zero,flag;
reg [31:0]register_file[0:31];
reg [31:0]memory_file[0:255];
reg [7:0] inst_file[0:255];
reg [31:0] PC;
wire [31:0] b_temp,mem_val;
wire [29:0] PC_jump,PC_next1,beq_ibw;
reg [29:0] PC_next2,PC_next_final;
initial begin
register_file[0] = 0; // Here, I am initialising the top 5 register file values.
register_file[1] = 1;
register_file[2] = 2;
register_file[3] = 3;
register_file[4] = 4;
register_file[5] = 5;
register_file[6] = 6; 
register_file[7] = 7;
register_file[8] = 8;
register_file[9] = 9;
register_file[10] = 10;
register_file[11] = 11;
register_file[12] = 12;
register_file[13] = 13;
register_file[14] = 14;
register_file[15] = 15;
register_file[16] = 16;
register_file[17] = 17; 
register_file[18] = 18;
register_file[19] = 19;
register_file[20] = 20;
register_file[21] = 21;
register_file[22] = 22;
memory_file[0] = 0; // Here, I am initialising the top 5 memory file values.
memory_file[1] = 10;
memory_file[2] = 20;
memory_file[3] = 30;
memory_file[4] = 40;
memory_file[5] = 50;
//add
inst_file[0] = 8'b00100000;
inst_file[1] = 8'b00100000;
inst_file[2] = 8'b01000011;
inst_file[3] = 8'b00000000;
//sub
inst_file[4] = 8'b00100010;
inst_file[5] = 8'b00100000;
inst_file[6] = 8'b01000011;    
inst_file[7] = 8'b00000000;
//and
inst_file[8] = 8'b00100100;
inst_file[9] = 8'b00100000;
inst_file[10] = 8'b01000011;
inst_file[11] = 8'b00000000;
//or
inst_file[12] = 8'b00100101;
inst_file[13] = 8'b00100000;
inst_file[14] = 8'b01000011;
inst_file[15] = 8'b00000000;
//slt
inst_file[16] = 8'b00101010;
inst_file[17] = 8'b00100000;
inst_file[18] = 8'b01000011;
inst_file[19] = 8'b00000000;
//addi
inst_file[20] = 8'b00111110;
inst_file[21] = 8'b00000000;
inst_file[22] = 8'b01000011;
inst_file[23] = 8'b00100000;
//slti
inst_file[24] = 8'b00111110;
inst_file[25] = 8'b00000000;
inst_file[26] = 8'b01000011;
inst_file[27] = 8'b00101000;			
//lw
inst_file[28] = 8'b00000001;
inst_file[29] = 8'b00000000;
inst_file[30] = 8'b01000011;
inst_file[31] = 8'b10001100;	
		
//sw
inst_file[32] = 8'b00000001;
inst_file[33] = 8'b00000000;
inst_file[34] = 8'b01000011;
inst_file[35] = 8'b10101100;	
//slti

inst_file[37] = 8'b00000000;
inst_file[38] = 8'b01000011;
inst_file[39] = 8'b00101000;				
		
//beq
inst_file[40] = 8'b00111110;
inst_file[41] = 8'b00000000;
inst_file[42] = 8'b01000011;
inst_file[43] = 8'b00010000;
//jump
inst_file[44] = 8'b00111110;
inst_file[45] = 8'b00000000;
inst_file[46] = 8'b01000011;
inst_file[47] = 8'b00001000;

PC = 0;

end

// IFU begins here
assign PC_jump = {PC[31:28],jump_offset[25:0]};
assign PC_next1 = PC[31:2]+30'd1;
assign beq_ibw = {{14{beq_offset[15]}},beq_offset[15:0]}+PC_next1;


always @(beq_ibw or PC_next1 or zero or branch)
begin
if(branch == 1 & zero == 1)
begin
PC_next2 = beq_ibw;
end
else
begin
PC_next2 = PC_next1;
end
end


always @(jump or PC_next2 or PC_jump)
begin
if(jump==1)
begin
PC_next_final=PC_jump;
end
else
begin
PC_next_final=  PC_next2;
end
end

always@(negedge clk)
begin
nextinst = {inst_file[PC+3],inst_file[PC+2],inst_file[PC+1],inst_file[PC]};
PC[31:0] = {PC_next_final,{2{1'b0}}};
end

assign inst = nextinst;
// Decode and Execute begins here
// Decode and Execute begins here
// Decode and Execute begins here
Dec_exe D1(inst,signctl,regdst,shiftctl,savepc,regwr,extop,signal,alusrc,memwr,memtoreg,jump,branch,rs,rt,rd,beq_offset,jump_offset); // calling the decode module
// The next few lines of code are for initialising the immediate value

always @(extop or inst[15:0])
begin
imm[31:0] = 32'bz;
if(extop==1)
begin
imm[31:0]={{16{inst[15]}},inst[15:0]};// sign -extending
end
else if (extop==0)
begin
imm[31:0]={{16{1'b0}},inst[15:0]}; // zero extending
end
end 
// assigning the value of a
assign a = register_file[rs]; 
// one of the two possible values of b
assign b_temp = register_file[rt];
// here, based on the value of alusrc, we are selecting the value of b
always @(alusrc or b_temp or imm) 
begin
if(alusrc==0)
begin
b = b_temp;
end
else
begin
b = imm;
end
end
// Here we will set the shift amount value
always @(shiftctl or a or inst)
begin
if(shiftctl==0)
begin
shiftamt= inst[10:6];
end
else if(shiftctl==1)
begin
shiftamt=a;
end
end
// here, we are calling the ALU
ALU A1(a,b,zero,o_p,signal,shiftamt,flag,signctl);

assign mem_val= memory_file[o_p];
always @ (memtoreg or o_p or mem_val)  // here, based on the value of memtoreg, we are deciding whether to write the ALU value or the output from the memory to the register file
begin
final_write = 32'bz;
if(memtoreg==0)
begin
final_write = o_p;
end
else if(memtoreg==1)
begin
final_write = mem_val;
end
end

always @(rd or rt or regdst) // here, are deciding whether to write the final output to rd or rt based on the value of regdst
begin
final_write_add = 32'bz;
if(regdst==1)
begin
final_write_add = rd;
end
else if(regdst==0)
begin
final_write_add = rt;
end
end
always @(negedge clk) // writing to register file
begin
if(regwr==1)
begin
register_file[final_write_add] = final_write;
reg_out = final_write;
end
if(savepc==1)
begin
register_file[31]=PC+8;
end
end
always @(negedge clk)// writing to memory file
begin
if((memwr==1))
begin
memory_file[b] = o_p;
main_out=o_p;
end
end
endmodule
