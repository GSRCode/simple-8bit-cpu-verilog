`timescale 1ns/1ps

module pc_tb;

reg clock;
reg reset;
reg increment;
reg load;
reg [7:0] load_value;

wire [7:0] value;

pc uut (
    .clock(clock),
    .reset(reset),
    .increment(increment),
    .load(load),
    .load_value(load_value),
    .value(value)
);


/* Generate clock */

always #5 clock = ~clock;


initial begin

    clock = 0;
    reset = 0;
    increment = 0;
    load = 0;
    load_value = 0;


    /*
     * Reset PC.
     */

    reset = 1;

    #10;

    reset = 0;

    $display("After reset: PC = %d", value);


    /*
     * Increment PC.
     */

    increment = 1;

    #10;
    $display("After increment: PC = %d", value);

    #10;
    $display("After increment: PC = %d", value);

    #10;
    $display("After increment: PC = %d", value);


    /*
     * Stop incrementing.
     */

    increment = 0;

    #10;
    $display("Increment disabled: PC = %d", value);


    /*
     * Load address 100 into PC.
     */

    load_value = 8'd100;
    load = 1;

    #10;

    load = 0;

    $display("After load: PC = %d", value);


    /*
     * Increment again.
     */

    increment = 1;

    #10;

    $display("After increment: PC = %d", value);


    $finish;

end

endmodule