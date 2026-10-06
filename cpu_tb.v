
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
     * Initialize CPU
     *
     * Program is loaded automatically
     * by memory.v using $readmemh.
     */
    initial begin

        clock = 0;
        reset = 1;

        /*
         * Keep reset active initially.
         */
        #12;

        reset = 0;

    end

    /*
     * Display CPU state after every rising edge.
     *
     * #1 allows non-blocking assignments
     * to complete before displaying values.
     */
    always @(posedge clock) begin

        #1;

        if (!reset) begin

            $display(
                "time=%0t state=%b PC=%0d IR=%h Operand=%0d R0=%0d R1=%0d R2=%0d R3=%0d",
                $time,
                uut.control_unit.state,
                uut.pc_value,
                uut.ir_value,
                uut.operand_value,
                uut.registers_unit.r0,
                uut.registers_unit.r1,
                uut.registers_unit.r2,
                uut.registers_unit.r3
            );

        end

    end

    /*
     * Stop simulation and display final values.
     */
    initial begin

        #1000;

        $display("");
        $display("Final program results:");

        $display("R0 = %0d", uut.registers_unit.r0);
        $display("R1 = %0d", uut.registers_unit.r1);
        $display("R2 = %0d", uut.registers_unit.r2);
        $display("R3 = %0d", uut.registers_unit.r3);

        $display("PC = %0d", uut.pc_value);

        $finish;

    end

endmodule
