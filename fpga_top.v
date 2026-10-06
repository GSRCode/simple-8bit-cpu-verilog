module fpga_top (
    input wire clock,
    input wire reset,
    output wire [7:0] debug_pc,
    output wire [7:0] debug_ir,
    output wire [7:0] debug_alu_result
);

    cpu cpu_unit (
        .clock(clock),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_ir(debug_ir),
        .debug_alu_result(debug_alu_result)
    );

endmodule