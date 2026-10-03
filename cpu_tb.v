`timescale 1ns/1ps

module cpu_tb;

reg clock;
reg reset;


cpu uut (
    .clock(clock),
    .reset(reset)
);


always #5 clock = ~clock;


initial begin

    clock = 0;
    reset = 0;


    /*
     * Program:
     *
     * LDI R1, 25
     *
     * 0x54 = 0101 01 00
     *        LDI  R1
     *
     * 0x19 = decimal 25
     */

    uut.memory_unit.mem[0] = 8'h54;
    uut.memory_unit.mem[1] = 8'h19;


    /*
     * Reset CPU.
     */

    reset = 1;

    #10;

    reset = 0;


    /*
     * Allow CPU to execute LDI.
     */

    #40;


    /*
     * Display CPU state.
     */

    $display("PC      = %d", uut.pc_value);
    $display("IR      = %h", uut.ir_value);
    $display("Operand = %d", uut.operand_value);

    $display("R0 = %d", uut.registers_unit.r0);
    $display("R1 = %d", uut.registers_unit.r1);
    $display("R2 = %d", uut.registers_unit.r2);
    $display("R3 = %d", uut.registers_unit.r3);


    $finish;

end

endmodule