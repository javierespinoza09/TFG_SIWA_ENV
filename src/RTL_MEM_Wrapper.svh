//////////////////////////////////////////
//	RTL_MEM_Wrapper						//
//	Modulo donde se unifica el codigo	//
//	RTL de SIWA y IP de memoria			//
//	Programador: Javier Espinoza Rivera	//
// 	Supervisor: Roberto Molina 			//
//////////////////////////////////////////

`include "../../Verificacion_RISCV_TEC/TEC_RISCV/TOP/topcore_tecriscv.sv"
`include "../../Verificacion_RISCV_TEC/test_env/core_spi_uart/IS25WP032D.v"

module RTL_MEM_Wrapper (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	
);

endmodule : RTL_MEM_Wrapper