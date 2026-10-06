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


    /*
     * Generate clock.
     */

    initial begin
        clock = 0;

        forever #5 clock = ~clock;
    end


    /*
     * Test.
     */

    initial begin

        /*
         * Start with reset active.
         */

        reset = 1;
        instruction = 8'h00;

        #10;

        reset = 0;


        /*
         * Test LDI.
         *
         * Opcode = 0101
         */

        instruction = 8'b0101_00_00;

        #40;


        /*
         * Test ADD.
         *
         * Opcode = 0110
         *
         * Destination = R1
         * Source      = R2
         *
         * 0110 01 10
         */

        instruction = 8'b0110_01_10;

        #30;


        $finish;

    end


    /*
     * Display control signals.
     */

    initial begin

        $monitor(
            "time=%0t state=%b reset=%b instruction=%b pc_inc=%b ir_load=%b operand_load=%b reg_write=%b",
            $time,
            uut.state,
            reset,
            instruction,
            pc_increment,
            ir_load,
            operand_load,
            register_write
        );

    end

endmodule