`timescale 1ns / 1ps

module cpu_tb;

    reg clock;
    reg reset;

    /*
     * CPU instance
     */
    cpu uut (
        .clock(clock),
        .reset(reset)
    );


    /*
     * Clock generation
     *
     * Clock period = 10 ns
     */
    always #5 clock = ~clock;


    /*
     * Initialize CPU and load program
     */
    initial begin

        clock = 0;
        reset = 1;


        /*
         * Program:
         *
         * R1 = 5
         * RAM[100] = R1
         *
         * R2 = 1
         *
         * loop:
         *     R1 = RAM[100]
         *     R1 = R1 - R2
         *     RAM[100] = R1
         *
         *     if R1 == 0
         *         goto done
         *
         *     goto loop
         *
         * done:
         *     HLT
         */


        /*
         * Address 0
         *
         * LDI R1, 5
         */
        uut.memory_unit.mem[0] = 8'h54;
        uut.memory_unit.mem[1] = 8'd5;


        /*
         * Address 2
         *
         * STORE R1, [100]
         */
        uut.memory_unit.mem[2] = 8'hE4;
        uut.memory_unit.mem[3] = 8'd100;


        /*
         * Address 4
         *
         * LDI R2, 1
         */
        uut.memory_unit.mem[4] = 8'h58;
        uut.memory_unit.mem[5] = 8'd1;


        /*
         * Address 6
         *
         * loop:
         *
         * LOAD R1, [100]
         */
        uut.memory_unit.mem[6] = 8'hD4;
        uut.memory_unit.mem[7] = 8'd100;


        /*
         * Address 8
         *
         * SUB R1, R2
         */
        uut.memory_unit.mem[8] = 8'h76;


        /*
         * Address 9
         *
         * STORE R1, [100]
         */
        uut.memory_unit.mem[9]  = 8'hE4;
        uut.memory_unit.mem[10] = 8'd100;


        /*
         * Address 11
         *
         * JZ done
         */
        uut.memory_unit.mem[11] = 8'hB0;
        uut.memory_unit.mem[12] = 8'd15;


        /*
         * Address 13
         *
         * JMP loop
         */
        uut.memory_unit.mem[13] = 8'hA0;
        uut.memory_unit.mem[14] = 8'd6;


        /*
         * Address 15
         *
         * done:
         *
         * HLT
         */
        uut.memory_unit.mem[15] = 8'hC0;


        /*
         * Keep reset active initially.
         */
        #12;

        reset = 0;

    end


    /*
     * Display CPU state after every rising clock edge.
     *
     * #1 allows non-blocking assignments from the
     * rising edge to complete before displaying values.
     */
    always @(posedge clock) begin

        #1;

        $display(
            "time=%0t state=%b PC=%0d IR=%h Operand=%0d R1=%0d R2=%0d RAM[100]=%0d pc_inc=%b ir_load=%b op_load=%b reg_write=%b pc_load=%b cond_jump=%b",
            $time,
            uut.control_unit.state,
            uut.pc_value,
            uut.ir_value,
            uut.operand_value,
            uut.registers_unit.r1,
            uut.registers_unit.r2,
            uut.memory_unit.mem[100],
            uut.pc_increment,
            uut.ir_load,
            uut.operand_load,
            uut.register_write,
            uut.pc_load,
            uut.conditional_jump
        );

    end


    /*
     * Stop simulation and display final values.
     */
    initial begin

        #1000;

        $display("");
        $display("Final values:");
        $display("R1       = %0d", uut.registers_unit.r1);
        $display("R2       = %0d", uut.registers_unit.r2);
        $display("RAM[100] = %0d", uut.memory_unit.mem[100]);

        $finish;

    end

endmodule