`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2020 23:15:57
// Design Name: 
// Module Name: Dec_exe
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


module Dec_exe(
input [31:0]inst,
output reg signctl,regdst, shiftctl,savepc, regwr, extop, 
output reg [4:0]signal,
output reg alusrc, memwr, memtoreg, jump, branch,
output reg [4:0] rs,rt,rd,
output reg [15:0] beq_offset,
output reg [25:0] jump_offset);
  
      always@(inst)
      begin
      rs = inst[25:21];
      rt = inst[20:16];
      rd = inst[15:11];
							regdst=1'bz;
                     regwr=0;
                     extop=1'bz;
                     signal=0;
                     alusrc=1'bz;
                     memwr=0;
                     memtoreg=1'bz;
                     jump=0;
                     branch=0;
                     beq_offset =0;
                     jump_offset=0;
                     shiftctl=1'bz;
                     signctl=1'bz;
							savepc=1'bz;
        if(inst[31:26]== 6'b000000)
            begin
             regdst=1;
                   regwr=1;
                   extop=1'bz;
                   alusrc=0;
                   memwr=0;
                   memtoreg=0;
                   jump=0;
                   branch=0;
            if(inst[5:0] == 6'b100000) // add
                begin
                signal=0;
                end
            else if(inst[5:0] == 6'b100010) // sub
                begin
                signal=1;
                end
             else if(inst[5:0] == 6'b100100) // and
                begin
                signal=2;
                end
             else if(inst[5:0] == 6'b100101) // or
                begin
                signal=3;
                end
             else if(inst[5:0] == 6'b101010) // slt
                begin
                signal=6;
                signctl=1;
                end
            else if(inst[5:0] == 6'b101011) // sltu
            begin
            signal=6;
            signctl=0;
            end
            else if(inst[5:0] == 6'b100111) // nor
            begin
            signal=4;
            end
            else if(inst[5:0] == 6'b000011) // arithmetic right shift (sra)
            begin
            signal=9;
            shiftctl=0;
            end
            else if(inst[5:0] == 6'b000111) // arithmetic right shift (srav)
            begin
            signal=9;
            shiftctl=1;
            end
            else if(inst[5:0] == 6'b000010 ) // logical right shift ( srl )
            begin
            signal = 5;
            shiftctl=0;
            end
            else if(inst[5:0] == 6'b000110) // logical right shift (srlv)
           begin
           signal = 5;
           shiftctl=1;
           end
           else if(inst[5:0] == 6'b000000 ) // logical left shift ( sll )
           begin
           signal = 13;
           shiftctl=0;
           end
           else if(inst[5:0] == 6'b000100) // logical left shift (sllv)
           begin
           signal = 13;
           shiftctl=1;
           end
           else if(inst[5:0] == 6'b100110) // xor
           begin
           signal = 8;
           end
			  end
        else if(inst[31:26]==6'b001000)//ADDI
            begin
            regdst=0;
            regwr=1;
            extop=1;
            signal=0;
            alusrc=1;
            memwr=0;
            memtoreg=0;
            jump=0;
            branch=0;
            end   
        else if(inst[31:26]==6'b001100)//ANDI
            begin
            regdst=0;
            regwr=1;
            extop=0;
            signal=2;
            alusrc=1;
            memwr=0;
            jump=0;
            branch=0;
            end 
       else if(inst[31:26]==6'b001101)//ORI
            begin
            regdst=0;
            regwr=1;
            extop=0;
            signal=3;
            alusrc=1;
            memwr=0;
            memtoreg=0;
            jump=0;
            branch=0;
            end  
             else if(inst[31:26]==6'b001101)//XORI
                       begin
                       regdst=0;
                       regwr=1;
                       extop=0;
                       signal=8;
                       alusrc=1;
                       memwr=0;
                       memtoreg=0;
                       jump=0;
                       branch=0;
                       end  
         else if(inst[31:26]==6'b001010)//SLTI
            begin
            regdst=0;
            regwr=1;
            extop=1;
            signal=6;
            alusrc=1;
            memwr=0;
            memtoreg=0;
            jump=0;
            branch=0;
            signctl = 1;
            end 
             else if(inst[31:26]==6'b001011)//SLTIU
                       begin
                       regdst=0;
                       regwr=1;
                       extop=1;
                       signal=6;
                       alusrc=1;
                       memwr=0;
                       memtoreg=0;
                       jump=0;
                       branch=0;
                       signctl = 0;
                       end   
            else if(inst[31:26]==6'b100011)//LW
                 begin
                 regdst=0;
                 regwr=1;
                 extop=1;
                 signal=0;
                 alusrc=1;
                 memwr=0;
                 memtoreg=1;
                 jump=0;
                 branch=0;
                 end 
           else if(inst[31:26]==6'b101011)// SW
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1;
                  signal=0;
                  alusrc=1;
                  memwr=1;
                  memtoreg=1'bz;
                  jump=0;
                  branch=0;
                  end   
          else if(inst[31:26]==6'b001010)//BEQ
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                  signal=1;
                  alusrc=0;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=0;
                  branch=1;
                  beq_offset =inst[15:0] ;
                  end
          else if(inst[31:26]==6'b000111)//BGTZ
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                   signal=10;
                  alusrc=0;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=0;
                  branch=1;
                  beq_offset =inst[15:0] ;
                  end
          else if(inst[31:26]==6'b000110)//BLEZ
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                  signal=11;
                  alusrc=0;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=0;
                  branch=1;
                  beq_offset =inst[15:0] ;
                  end   
          else if(inst[31:26]==6'b000101)//BNE
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                  signal=12;
                  alusrc=0;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=0;
                  branch=1;
                  beq_offset =inst[15:0] ;
                  end
          else if(inst[31:26]==6'b001010)//JUMP
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                  signal=1'bz;
                  alusrc=1'bz;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=1;
                  branch=0;
                  jump_offset = inst[25:0];
                  end   
			 else if(inst[31:26]==6'b000011)//JAL
                  begin
                  regdst=1'bz;
                  regwr=0;
                  extop=1'bz;
                  signal=1'bz;
                  alusrc=1'bz;
                  memwr=0;
                  memtoreg=1'bz;
                  jump=1;
                  branch=0;
                  jump_offset = inst[25:0];
						savepc=1;
                  end 		
          end 
endmodule
