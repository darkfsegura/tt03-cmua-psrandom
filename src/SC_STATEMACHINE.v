///*######################################################################
//#	G0B1T: HDL EXAMPLES. 2023.
//######################################################################
//# Copyright (C) 2023. F.E.Segura-Quijano (FES) fsegura@uniandes.edu.co
//# 
//# This program is free software: you can redistribute it and/or modify
//# it under the terms of the GNU General Public License as published by
//# the Free Software Foundation, version 3 of the License.
//#
//# This program is distributed in the hope that it will be useful,
//# but WITHOUT ANY WARRANTY; without even the implied warranty of
//# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//# GNU General Public License for more details.
//#
//# You should have received a copy of the GNU General Public License
//# along with this program.  If not, see <http://www.gnu.org/licenses/>
//####################################################################*/
//=======================================================
//  MODULE Definition
//=======================================================
module SC_STATEMACHINE (
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_loadseed_OutLow,
	SC_STATEMACHINE_loadrand_OutLow,
	//////////// INPUTS //////////
	SC_STATEMACHINE_CLOCK_50,
	SC_STATEMACHINE_RESET_InHigh,
	SC_STATEMACHINE_loadseed_InLow,
	SC_STATEMACHINE_loadrand_InLow
);	
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam STATE_RESET_0									= 0;
localparam STATE_START_0									= 1;
localparam STATE_CHECK_0									= 2;
localparam STATE_LOADSEED_0									= 3; 
localparam STATE_LOADSEED_1									= 4; 
localparam STATE_LOADRAND_0									= 5; 
localparam STATE_LOADRAND_1									= 6; 
//=======================================================
//  PORT declarations
//=======================================================
output reg		SC_STATEMACHINE_loadseed_OutLow;
output reg		SC_STATEMACHINE_loadrand_OutLow;
input			SC_STATEMACHINE_CLOCK_50;
input 			SC_STATEMACHINE_RESET_InHigh;
input			SC_STATEMACHINE_loadseed_InLow;
input			SC_STATEMACHINE_loadrand_InLow;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [3:0] STATE_Register;
reg [3:0] STATE_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
begin
	case (STATE_Register)
		STATE_RESET_0: STATE_Signal = STATE_START_0;
		STATE_START_0: STATE_Signal = STATE_CHECK_0;
		STATE_CHECK_0: if (SC_STATEMACHINE_loadseed_InLow == 1'b0) STATE_Signal = STATE_LOADSEED_0;
							else if (SC_STATEMACHINE_loadrand_InLow == 1'b0) STATE_Signal = STATE_LOADRAND_0;
							else STATE_Signal = STATE_CHECK_0;
		STATE_LOADSEED_0: 	STATE_Signal = STATE_LOADSEED_1;
		STATE_LOADSEED_1: 	if (SC_STATEMACHINE_loadseed_InLow == 1'b0) STATE_Signal = STATE_LOADSEED_1;
							else STATE_Signal = STATE_CHECK_0;		
		STATE_LOADRAND_0: if (SC_STATEMACHINE_loadrand_InLow == 1'b0) STATE_Signal = STATE_LOADRAND_1;
							else STATE_Signal = STATE_CHECK_0;
		STATE_LOADRAND_1: 	if (SC_STATEMACHINE_loadrand_InLow == 1'b0) STATE_Signal = STATE_LOADRAND_1;
							else STATE_Signal = STATE_CHECK_0;		
		default : 		STATE_Signal = STATE_CHECK_0;
	endcase
end
// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINE_CLOCK_50 , posedge SC_STATEMACHINE_RESET_InHigh)
begin
	if (SC_STATEMACHINE_RESET_InHigh == 1'b1)
		STATE_Register <= STATE_RESET_0;
	else
		STATE_Register <= STATE_Signal;
end
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
begin
	case (STATE_Register)
//=========================================================
// STATE_RESET
//=========================================================
	STATE_RESET_0 :	
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1;
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
//=========================================================
// STATE_START
//=========================================================
	STATE_START_0 :	
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1;
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
//=========================================================
// STATE_CHECK
//=========================================================
	STATE_CHECK_0 :
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1;
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
//=========================================================
// STATE_LOADSEED_0
//=========================================================
	STATE_LOADSEED_0 :
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b0; //-  
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
//=========================================================
// STATE_LOADSEED_1
//=========================================================
	STATE_LOADSEED_1 :
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1; 
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
//=========================================================
// STATE_LOADRAND_0
//=========================================================
	STATE_LOADRAND_0 :	
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1;
			SC_STATEMACHINE_loadrand_OutLow = 1'b0;  //-
		end
//=========================================================
// STATE_LOADRAND_1
//=========================================================
	STATE_LOADRAND_1 :	
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1;
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;  //-
		end
//=========================================================
// DEFAULT
//=========================================================
	default :
		begin
			SC_STATEMACHINE_loadseed_OutLow = 1'b1; 
			SC_STATEMACHINE_loadrand_OutLow = 1'b1;
		end
	endcase
end
endmodule
