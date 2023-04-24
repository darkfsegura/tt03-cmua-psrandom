/*######################################################################
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
module SC_PSRANDOM #(parameter RegGENERAL_DATAWIDTH=8)(
	//////////// OUTPUTS //////////
	SC_PSRANDOM_data_OutBUS,
	//////////// INPUTS //////////
	SC_PSRANDOM_CLOCK_50,
	SC_PSRANDOM_RESET_InHigh,
	SC_PSRANDOM_LOAD_InHigh,
	SC_PSRANDOM_data_InBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output		[RegGENERAL_DATAWIDTH-1:0]	SC_PSRANDOM_data_OutBUS;
input		SC_PSRANDOM_CLOCK_50;
input		SC_PSRANDOM_RESET_InHigh;
input		SC_PSRANDOM_LOAD_InHigh;
input		[RegGENERAL_DATAWIDTH-5:0]	SC_PSRANDOM_data_InBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegGENERAL_DATAWIDTH-1:0] PSRANDOM_Register;
reg [RegGENERAL_DATAWIDTH-1:0] PSRANDOM_Signal;
wire feedback;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_PSRANDOM_LOAD_InHigh == 1'b0)
		PSRANDOM_Signal = {4'b1000,SC_PSRANDOM_data_InBUS[RegGENERAL_DATAWIDTH-5:0]};
	else
		PSRANDOM_Signal = {PSRANDOM_Register[RegGENERAL_DATAWIDTH-2:0], feedback}; //shift left the xor'd every posedge clock;;
end	

//STATE REGISTER: SEQUENTIAL
always @(posedge SC_PSRANDOM_CLOCK_50, posedge SC_PSRANDOM_RESET_InHigh)
begin
	if (SC_PSRANDOM_RESET_InHigh == 1'b1)
		PSRANDOM_Register <= 0;
	else
		PSRANDOM_Register <= PSRANDOM_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign feedback = PSRANDOM_Register[7] ^ PSRANDOM_Register[5] ^ PSRANDOM_Register[3] ^ PSRANDOM_Register[0];  
assign SC_PSRANDOM_data_OutBUS = PSRANDOM_Register;

endmodule
