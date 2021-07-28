//////////////////////////////////////////////////////
//
//  Definitions
//
//////////////////////////////////////////////////////

//`default_nettype none

`define delayslot
`define mdu_wait_until_finish

`define wire32		wire[31:0]
`define reg32		reg[31:0]
`define b32			[31:0]

`define IM_size	4096
`define DM_size	4096

`define RF_gp		5'd28
`define RF_sp		5'd29
`define RF_ra		5'd31

`define NPCOp_len	2
`define NPCOp		[`NPCOp_len-1:0]
`define NPC_PC4	'h0
`define NPC_B		'h1
`define NPC_J		'h2
`define NPC_JR		'h3

`define ALUOp_len	5
`define ALUOp		[`ALUOp_len-1:0]
`define ALU_add	'h00
`define ALU_sub	'h01
`define ALU_and	'h02
`define ALU_or		'h03
`define ALU_xor	'h04
`define ALU_nor	'h05
`define ALU_slt	'h06
`define ALU_sltu	'h07
`define ALU_sll	'h08
`define ALU_srl	'h09
`define ALU_sra	'h0A
`define ALU_clo	'h0B
`define ALU_clz	'h0C
`define ALU_ext	'h0D
`define ALU_ins	'h0E
`define ALU_mov	'h0F
`define ALU_rot	'h10
`define ALU_wsbh	'h11
`define ALU_seb	'h12
`define ALU_seh	'h13

`define BJOp_len	3
`define BJOp		[`BJOp_len-1:0]
`define BJ_beq		'h0
`define BJ_bne		'h1
`define BJ_bgtz	'h2 // unused
`define BJ_bltz	'h3 // unused
`define BJ_bgez	'h4 // unused
`define BJ_blez	'h5 // unused
`define BJ_movz	'h6
`define BJ_movn	'h7

`define EXTOp_len	2
`define EXTOp		[`EXTOp_len-1:0]
`define EXT_zero	'h0
`define EXT_sign	'h1
`define EXT_high	'h2
`define EXT_shift	'h3

`define MDUOp_len	4
`define MDUOp		[`MDUOp_len-1:0]
`define MDU_mult	'h0
`define MDU_div	'h1
`define MDU_hi		'h2
`define MDU_lo		'h3
`define MDU_multu	'h4
`define MDU_divu	'h5
`define MDU_madd	'h6
`define MDU_maddu	'h7
`define MDU_msub	'h8
`define MDU_msubu	'h9
`define MDU_mul	'hA

`define A3Slen		2
`define A3S			[`A3Slen-1:0]
`define A3S_rd		'h0
`define A3S_rt		'h1
`define A3S_ra		'h2

`define WDSlen		3
`define WDS			[`WDSlen-1:0]
`define WDS_ALU	'h0
`define WDS_MEM	'h1
`define WDS_NPC	'h2
`define WDS_MDU	'h3
`define WDS_CP0	'h4

`define SHSlen		1
`define SHS			[`SHSlen-1:0]
`define SHS_rs		'h0
`define SHS_sh		'h1

`define ALUSlen	1
`define ALUS		[`ALUSlen-1:0]
`define ALUS_rt	'h0
`define ALUS_imm	'h1

`define DMASlen	2
`define DMAS		[`DMASlen-1:0]
`define DMAS_res	'h0
`define DMAS_rt	'h1
`define DMAS_mdu	'h2

`define DMWSlen	2
`define DMWS		[`DMWSlen-1:0]
`define DMWS_rt	'h0
`define DMWS_res	'h1
`define DMWS_mdu	'h2

`define DMOp_len	3
`define DMOp		[`DMOp_len-1:0]
`define DM_w		'b000
`define DM_h		'b001
`define DM_b		'b010
`define DM_hu		'b101
`define DM_bu		'b110
`define DM_l		'b011
`define DM_r		'b111

`define ins_addu		'b000000_100001
`define ins_subu		'b000000_100011
`define ins_ori		'b001101_zzzzzz
`define ins_lw			'b100011_zzzzzz
`define ins_sw			'b101011_zzzzzz
`define ins_beq		'b000100_zzzzzz
`define ins_lui		'b001111_zzzzzz
`define ins_j			'b000010_zzzzzz
`define ins_jal		'b000011_zzzzzz
`define ins_jr			'b000000_001000

`define ins_add		'b000000_100000
`define ins_addi		'b001000_zzzzzz
`define ins_addiu		'b001001_zzzzzz
`define ins_sub		'b000000_100010
`define ins_and		'b000000_100100
`define ins_andi		'b001100_zzzzzz
`define ins_or			'b000000_100101
`define ins_nor		'b000000_100111
`define ins_xor		'b000000_100110
`define ins_xori		'b001110_zzzzzz

`define ins_sll		'b000000_000000
`define ins_srl		'b000000_000010 //rotr rs==5'b00001
`define ins_sra		'b000000_000011
`define ins_sllv		'b000000_000100
`define ins_srlv		'b000000_000110 //rotrv sa==5'b00001
`define ins_srav		'b000000_000111
`define ins_lh			'b100001_zzzzzz
`define ins_lb			'b100000_zzzzzz
`define ins_lhu		'b100101_zzzzzz
`define ins_lbu		'b100100_zzzzzz
`define ins_sh			'b101001_zzzzzz
`define ins_sb			'b101000_zzzzzz
`define ins_bne		'b000101_zzzzzz
`define ins_jalr		'b000000_001001
`define ins_slt		'b000000_101010
`define ins_sltu		'b000000_101011
`define ins_slti		'b001010_zzzzzz
`define ins_sltiu		'b001011_zzzzzz
`define ins_clo		'b011100_100001
`define ins_clz		'b011100_100000
`define ins_lwl		'b100010_zzzzzz
`define ins_lwr		'b100110_zzzzzz
`define ins_swl		'b101010_zzzzzz
`define ins_swr		'b101110_zzzzzz
`define ins_bgtz		'b000111_zzzzzz
`define ins_blez		'b000110_zzzzzz
`define ins_ext		'b011111_000000
`define ins_ins		'b011111_000100
`define ins_movn		'b000000_001011
`define ins_movz		'b000000_001010
`define ins_mult		'b000000_011000
`define ins_multu		'b000000_011001
`define ins_div		'b000000_011010
`define ins_divu		'b000000_011011
`define ins_mul		'b011100_000010
`define ins_mfhi		'b000000_010000
`define ins_mflo		'b000000_010010
`define ins_mthi		'b000000_010001
`define ins_mtlo		'b000000_010011
`define ins_madd		'b011100_000000
`define ins_maddu		'b011100_000001
`define ins_msub		'b011100_000100
`define ins_msubu		'b011100_000101
`define ins_beql		'b010100_zzzzzz
`define ins_bnel		'b010101_zzzzzz
`define ins_bgtzl		'b010111_zzzzzz
`define ins_blezl		'b010110_zzzzzz

`define ins_bshfl		'b011111_100000
	`define bshfl_seb			'b10000
	`define bshfl_seh			'b11000
	`define bshfl_wsbh		'b00010
`define ins_regimm	'b000001_zzzzzz
	`define regimm_bltz		'b00000
	`define regimm_bltzal	'b10000
	`define regimm_bgez		'b00001
	`define regimm_bgezal	'b10001
	`define regimm_bltzl		'b00010
	`define regimm_bltzall	'b10010
	`define regimm_bgezl		'b00011
	`define regimm_bgezall	'b10011
`define ins_cop0		'b010000_zzzzzz
	`define cop0_mf			'b00000_zzzzzz
	`define cop0_mt			'b00100_zzzzzz
	`define cop0_eret			'b1zzzz_011000

`define TUselen	2
`define TUse		[`TUselen-1:0]
`define TUse_D		'h0
`define TUse_E		'h1
`define TUse_M		'h2
`define TUse_N		'h3 //TUse_N indicates that the register is not used.

`define TNewlen	2
`define TNew		[`TNewlen-1:0]
`define TNew_E		'h0
`define TNew_M		'h1
`define TNew_W		'h2

`define TIndexlen	2
`define TIndex		[`TIndexlen-1:0]
`define TIndex_D	'h0
`define TIndex_E	'h1
`define TIndex_M	'h2
`define TIndex_W	'h3

`define CP0Dplen	2
`define CP0Dp		[`CP0Dplen-1:0]
`define CP0Dp_N	'h0
`define CP0Dp_R	'h1
`define CP0Dp_W	'h2

`define FWSlen		3
`define FWS			[`FWSlen-1:0]
`define FW_orig	'h0
`define FW_W		'h1
`define FW_MALU	'h2
`define FW_MMDU	'h3
`define FW_MPC8	'h4
`define FW_EPC8	'h5

`define PC_init	32'h00003000
`define EX_init	32'h00004180

`define HW_Err		'hDEAD_CAFE

`define exc			[5]
`define EXC_NONE	'b0_00000
`define EXC_INTR	'b1_00000
`define EXC_PCAD	'b1_00100
`define EXC_ILOP	'b1_01010
`define EXC_OVER	'b1_01100
`define EXC_DRAD	'b1_00100
`define EXC_DWAD	'b1_00101

`define EXC_DIVZ	'b1_00000//

`define ETypelen	2
`define EType		[`ETypelen-1:0]
`define ET_NONE	'h0
`define ET_ARIT	'h1
`define ET_LOAD	'h2
`define ET_SAVE	'h3

`define CSlen	3 //Chip Selector
`define CS		[`CSlen-1:0]
`define CS_DM	'h0
`define CS_IM	'h1
`define CS_H0	'h2
`define CS_H1	'h3
`define CS_H2	'h4
`define CS_H3	'h5
`define CS_H4	'h6
`define CS_H5	'h7

`define cp0_demo

`define gp_init	'h0000//32'h1800
`define sp_init	'h0000//32'h2ffc
`define PrID_init		'h00000000

`ifdef cp0_demo
	`define SR_init		'h00000000
`else
	`define SR_init		'h0000ff11
`endif

`define CAUSE_init	'h00000000
`define EPC_init		'h00000000
`define VADDR_init	'h00000000


//`define regard_div0_as_exception