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
module exe(input clk,input [31:0]inst,output reg [31:0] reg_out,output reg [31:0] main_out);
wire regdst;
reg[31:0] imm;
wire regwr;
wire extop;
wire[2:0]signal;
wire alusrc;
wire memwr;
wire memtoreg;
wire jump;
wire branch;
wire [31:0] o_p;
wire [15:0] beq_offset;
wire [25:0] jump_offset;
reg [31:0] b,final_write,final_write_add,nextinst;
wire [4:0] rs,rt,rd;
wire zero,flag;
reg [31:0]register_file[0:31];
reg [31:0]memory_file[0:255];
reg [31:0] inst_file[0:255];
reg [31:0] PC;
wire [31:0] a,b_temp,mem_val;
wire [29:0] PC_jump,PC_next1,beq_ibw;
reg [29:0] PC_next2,PC_next_final;
initial begin
register_file[0] = 0; // Here, I am initialising the top 5 register file values.
register_file[1] = 1;
register_file[2] = 2;
register_file[3] = 3;
register_file[4] = 4;
register_file[5] = 5;
memory_file[0] = 0; // Here, I am initialising the top 5 memory file values.
memory_file[1] = 10;
memory_file[2] = 20;
memory_file[3] = 30;
memory_file[4] = 40;
memory_file[5] = 50;
inst_file[0] = 32'b00000000001000100001100000100000; // add // reg[1] + reg[2] = reg [3]
inst_file[1] = 32'b00000000001000100001100000100010;// sub // reg[1] - reg[2] = reg [3]
inst_file[2] = 32'b00000000001000100001100000100100; // and // reg[1] & reg[2] = reg [3]
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
Dec_exe D1(inst,regdst,regwr,extop,signal,alusrc,memwr,memtoreg,jump,branch,rs,rt,rd,beq_offset,jump_offset); // calling the decode module
always @(extop or inst[15:0])// The next few lines of code are for initialising the immediate value
begin
imm[31:0] = 32'bz;
if(extop==1)
begin
imm[31:0]={{16{inst[15]}},inst[15:0]};
end
else if (extop==0)
begin
imm[31:0]={{16{1'b0}},inst[15:0]};
end
end 
assign a = register_file[rs]; // assigning the value of a
assign b_temp = register_file[rt];
always @(alusrc or b_temp or imm) // here, based on the value of alusrc, we are selecting the value of b
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
ALU A1(a,b,zero,o_p,signal,5'd0,flag); // here, we are calling the ALU
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
end
always @(negedge clk)// writing to memory file
begin
if(memwr==1)
begin
memory_file[b] = o_p;
main_out=o_p;
end
end
endmodule