module fpga_top (
    input  wire clock,
    output wire led
);

    wire [7:0] debug_pc;
    wire [7:0] debug_ir;
    wire [7:0] debug_alu_result;
    wire [7:0] debug_r0;

    reg [3:0] reset_counter = 4'b0000;

    wire reset;

    /*
     * Generate reset automatically after FPGA configuration.
     *
     * Keep reset high for the first few clock cycles,
     * then release the CPU.
     */

    always @(posedge clock) begin
        if (reset_counter != 4'b1111)
            reset_counter <= reset_counter + 1'b1;
    end

    assign reset = (reset_counter != 4'b1111);


    /*
     * 8-bit CPU
     */

    cpu cpu_unit (
        .clock(clock),
        .reset(reset),

        .debug_pc(debug_pc),
        .debug_ir(debug_ir),
        .debug_alu_result(debug_alu_result),
        .debug_r0(debug_r0)
    );


    /*
     * PASS LED
     *
     * LED indicates that the CPU calculated
     * 5 + 3 = 8.
     */

    assign led = (debug_r0 == 8'd8);

endmodule