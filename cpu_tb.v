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


    uut.memory_unit.mem[0] = 8'h54; // LDI R1
    uut.memory_unit.mem[1] = 8'h0C; // 12

    uut.memory_unit.mem[2] = 8'h58; // LDI R2
    uut.memory_unit.mem[3] = 8'h0A; // 10

    uut.memory_unit.mem[4] = 8'hA0; // JMP
    uut.memory_unit.mem[5] = 8'h00; // address 0

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
        "time=%0t state=%b PC=%0d IR=%h Operand=%0d A=%0d B=%0d ALU=%0d R0=%0d R1=%0d R2=%0d R3=%0d pc_inc=%b ir_load=%b op_load=%b reg_write=%b pc_load=%b",
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
        uut.register_write,
        uut.pc_load
    );

end

endmodule