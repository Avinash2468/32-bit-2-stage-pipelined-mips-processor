`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2020 12:27:05
// Design Name: 
// Module Name: IFU
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


module IFU(clk,jump,branch,add,inst);
reg [31:0] inst_file[0:255];
initial begin
inst_file[0] = 32'b00000000001000100001100000100000; // add // reg[1] + reg[2] = reg [3]
inst_file[1] = 32'b00000000001000100001100000100010;// sub // reg[1] - reg[2] = reg [3]
inst_file[2] = 32'b00000000001000100001100000100100; // and // reg[1] & reg[2] = reg [3]
end
input clk;
input branch, jump;
input add;
output reg [31:0]inst;
reg [29:0] imm;
always@(posedge clk)
begin
inst = inst_file[add];
imm[29:0]={{14{inst[15]}},inst[15:0]};

end
endmodule
