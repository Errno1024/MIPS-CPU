`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:08 11/12/2019 
// Design Name: 
// Module Name:    Hazard 
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
`include "def.v"
module Hazard(
	 input [`TUselen-1:0]TUseRsD,
	 input [`TUselen-1:0]TUseRtD,
	 input [`TNewlen-1:0]TNewE,
	 input [`TNewlen-1:0]TNewM,
	 
	 input [`NPCOp_len-1:0] NPCOpD,
	 input BEn,
	 
	 input [4:0]rsD,
	 input [4:0]rtD,
	 input [4:0]rsE,
	 input [4:0]rtE,
	 input [4:0]rtM,
	 
	 input [4:0]DstE,
	 input [4:0]DstM,
	 input [4:0]DstW,
	 input RFWrE,
	 input RFWrM,
	 input RFWrW,
	 input [`WDSlen-1:0]WDSelE,
	 input [`WDSlen-1:0]WDSelM,
	 
	 output reg PCWr,
	 output reg FDEn,
	 output reg FDFlush,
	 output reg DEFlush,
	 output `FWS ForwardRsD,
	 output `FWS ForwardRtD,
	 output `FWS ForwardRsE,
	 output `FWS ForwardRtE,
	 output `FWS ForwardRtM,
	 
	 input `TIndex TIndexE,
	 input `TIndex TIndexM,
	 input MDUDpD,
	 input MDUBusy,
	 input MDUReady,
	 input MDUToBusy,
	 input RFWrMDU,
	 input [4:0]DstMDU,
	 input [4:0]DstD,
	 input `TIndex TIndexD,
	 input LikelyD,
	 
	 input kernel,
	 input eretD,
	 input CP0WrE,
	 input CP0WrM,
	 output reg GeneralFlush
    );

assign
ForwardRsD=
	(rsD!=0 && rsD==DstE && RFWrE==1 && WDSelE==`WDS_NPC && TIndexE==0)?`FW_EPC8:
	(rsD!=0 && rsD==DstM && RFWrM==1 && WDSelM==`WDS_ALU && TIndexM==0)?`FW_MALU:
	(rsD!=0 && rsD==DstM && RFWrM==1 && WDSelM==`WDS_MDU && TIndexM==0)?`FW_MMDU:
	(rsD!=0 && rsD==DstM && RFWrM==1 && WDSelM==`WDS_NPC && TIndexM==0)?`FW_MPC8:
	(rsD!=0 && rsD==DstW && RFWrW==1)?`FW_W:
	`FW_orig,
ForwardRtD=
	(rtD!=0 && rtD==DstE && RFWrE==1 && WDSelE==`WDS_NPC && TIndexE==0)?`FW_EPC8:
	(rtD!=0 && rtD==DstM && RFWrM==1 && WDSelM==`WDS_ALU && TIndexM==0)?`FW_MALU:
	(rtD!=0 && rtD==DstM && RFWrM==1 && WDSelM==`WDS_MDU && TIndexM==0)?`FW_MMDU:
	(rtD!=0 && rtD==DstM && RFWrM==1 && WDSelM==`WDS_NPC && TIndexM==0)?`FW_MPC8:
	(rtD!=0 && rtD==DstW && RFWrW==1)?`FW_W:
	`FW_orig,
ForwardRsE=
	(rsE!=0 && rsE==DstM && RFWrM==1 && WDSelM==`WDS_ALU && TIndexM==0)?`FW_MALU:
	(rsE!=0 && rsE==DstM && RFWrM==1 && WDSelM==`WDS_MDU && TIndexM==0)?`FW_MMDU:
	(rsE!=0 && rsE==DstM && RFWrM==1 && WDSelM==`WDS_NPC && TIndexM==0)?`FW_MPC8:
	(rsE!=0 && rsE==DstW && RFWrW==1)?`FW_W:
	`FW_orig,
ForwardRtE=
	(rtE!=0 && rtE==DstM && RFWrM==1 && WDSelM==`WDS_ALU && TIndexM==0)?`FW_MALU:
	(rtE!=0 && rtE==DstM && RFWrM==1 && WDSelM==`WDS_MDU && TIndexM==0)?`FW_MMDU:
	(rtE!=0 && rtE==DstM && RFWrM==1 && WDSelM==`WDS_NPC && TIndexM==0)?`FW_MPC8:
	(rtE!=0 && rtE==DstW && RFWrW==1)?`FW_W:
	`FW_orig,
ForwardRtM=
	(rtM!=0 && rtM==DstW && RFWrW==1)?`FW_W:
	`FW_orig;


always@(*)begin
	PCWr=1;
	FDEn=1;
	FDFlush=0;
	DEFlush=0;
	GeneralFlush=0;
	if(kernel)begin
		GeneralFlush=1;
	end
	else if(
		(
			((rsD!=0 && rsD==DstE&&(TNewE>TUseRsD))||(rtD!=0 && rtD==DstE&&(TNewE>TUseRtD)))&&RFWrE
		)
		||(
			((rsD!=0 && rsD==DstM&&(TNewM>TUseRsD))||(rtD!=0 && rtD==DstM&&(TNewM>TUseRtD)))&&RFWrM
		)
		||(
			((rsD!=0 && (TIndexE>TUseRsD))||(rtD!=0 && (TIndexE>TUseRtD)))&&RFWrE
		)
		||(
			((rsD!=0 && (TIndexM>TUseRsD))||(rtD!=0 && (TIndexM>TUseRtD)))&&RFWrM
		)
		||(
			((MDUBusy && !MDUReady) || MDUToBusy) && MDUDpD
		)
		||(
			eretD && (CP0WrE || CP0WrM)
		)
		//mul
	`ifndef mdu_wait_until_finish
		||(
			MDUBusy && RFWrMDU && ( MDUReady || (rsD!=0 && rsD==DstMDU) || (rtD!=0 && rtD==DstMDU) || (DstD!=0 && DstD==DstMDU) || TIndexD!=0)
		)
		||(
			MDUToBusy && RFWrMDU && ( (rsD!=0 && rsD==DstE) || (rtD!=0 && rtD==DstE) || (DstD!=0 && DstD==DstE) || TIndexD!=0)
		)
	`else
		||(
			(MDUBusy || MDUToBusy) && RFWrMDU
		)//�ָ�mul��tnew!
	`endif
	)begin
		//stall
		PCWr=0;
		FDEn=0;
		DEFlush=1;
		
	end
	else if(eretD)begin
		FDFlush=1;
	end
	else if(NPCOpD==`NPC_B && !BEn && LikelyD)begin
		FDFlush=1;
	end
	else if(NPCOpD==`NPC_J || NPCOpD==`NPC_JR || NPCOpD==`NPC_B && BEn)begin
		`ifndef delayslot
			//Erase the delay slot
			FDFlush=1;
		`endif
	end
end
endmodule
