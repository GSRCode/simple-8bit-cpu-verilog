`timescale 1ns/1ps

module cpu_tb;

reg clock;
reg reset;


cpu uut (
    .clock(clock),
    .reset(reset)
);


/*
 * Generate clock.
 */

always #5 clock = ~clock;


/*
 * Test program.
 */

initial begin

    clock = 0;
    reset = 0;


    /*
     * Program:
     *
     * Address 0:
     * LDI R1
     *
     * 0101 01 00 = 0x54
     *
     * Address 1:
     * 25 = 0x19
     */

    uut.memory_unit.mem[0] = 8'h54;
    uut.memory_unit.mem[1] = 8'h19;


    /*
     * Address 2:
     * LDI R2
     *
     * 0101 10 00 = 0x58
     *
     * Address 3:
     * 10 = 0x0A
     */

    uut.memory_unit.mem[2] = 8'h58;
    uut.memory_unit.mem[3] = 8'h0A;


    /*
     * Address 4:
     *
     * ADD R1, R2
     *
     * 0110 01 10
     *
     * = 0x66
     */

    uut.memory_unit.mem[4] = 8'h66;

    /*
    * Address 5:
    *
    * SUB R1, R2
    *
    * 0111 01 10
    *
    * = 0x76
    */

    uut.memory_unit.mem[5] = 8'h76;


    /*
     * Reset CPU.
     */

    reset = 1;

    #10;

    reset = 0;


    /*
     * Allow program to execute.
     */

    #160;


    /*
     * Final result.
     */

    $display("");
    $display("Final register values:");
    $display("R0 = %0d", uut.registers_unit.r0);
    $display("R1 = %0d", uut.registers_unit.r1);
    $display("R2 = %0d", uut.registers_unit.r2);
    $display("R3 = %0d", uut.registers_unit.r3);

    $finish;

end


/*
 * Display CPU state only at rising clock edges.
 */

always @(posedge clock) begin

    #3;

    $display(
        "time=%0t state=%b PC=%0d IR=%h Operand=%0d A=%0d B=%0d ALU=%0d R0=%0d R1=%0d R2=%0d R3=%0d pc_inc=%b ir_load=%b op_load=%b reg_write=%b",
        $time,
        uut.control_unit.state,
        uut.pc_value,
        uut.ir_value,
        uut.operand_value,
        uut.register_read_a,
        uut.register_read_b,
        uut.alu_result,
        uut.registers_unit.r0,
        uut.registers_unit.r1,
        uut.registers_unit.r2,
        uut.registers_unit.r3,
        uut.pc_increment,
        uut.ir_load,
        uut.operand_load,
        uut.register_write
    );

end

endmodule