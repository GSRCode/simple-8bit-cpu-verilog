`timescale 1ns/1ps

module control_tb;

reg clock;
reg reset;

reg [7:0] instruction;

wire pc_increment;
wire ir_load;
wire operand_load;
wire register_write;


control uut (
    .clock(clock),
    .reset(reset),
    .instruction(instruction),

    .pc_increment(pc_increment),
    .ir_load(ir_load),
    .operand_load(operand_load),
    .register_write(register_write)
);


always #5 clock = ~clock;


initial begin

    clock = 0;
    reset = 0;

    /*
     * LDI R1
     *
     * opcode = 0101
     * R1     = 01
     *
     * 0101 01 00 = 0x54
     */

    instruction = 8'h54;


    /*
     * Reset control unit.
     */

    reset = 1;

    #10;

    reset = 0;


    /*
     * Display control signals as states advance.
     */

    #1;

    $display(
        "state=%b  pc_inc=%b  ir_load=%b  operand_load=%b  reg_write=%b",
        uut.state,
        pc_increment,
        ir_load,
        operand_load,
        register_write
    );


    #10;

    $display(
        "state=%b  pc_inc=%b  ir_load=%b  operand_load=%b  reg_write=%b",
        uut.state,
        pc_increment,
        ir_load,
        operand_load,
        register_write
    );


    #10;

    $display(
        "state=%b  pc_inc=%b  ir_load=%b  operand_load=%b  reg_write=%b",
        uut.state,
        pc_increment,
        ir_load,
        operand_load,
        register_write
    );


    #10;

    $display(
        "state=%b  pc_inc=%b  ir_load=%b  operand_load=%b  reg_write=%b",
        uut.state,
        pc_increment,
        ir_load,
        operand_load,
        register_write
    );


    #10;

    $display(
        "state=%b  pc_inc=%b  ir_load=%b  operand_load=%b  reg_write=%b",
        uut.state,
        pc_increment,
        ir_load,
        operand_load,
        register_write
    );


    $finish;

end

endmodule