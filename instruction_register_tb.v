`timescale 1ns/1ps

module instruction_register_tb;

reg clock;
reg load;
reg [7:0] data_in;

wire [7:0] value;


instruction_register uut (
    .clock(clock),
    .load(load),
    .data_in(data_in),
    .value(value)
);


always #5 clock = ~clock;


initial begin

    clock = 0;
    load = 0;
    data_in = 0;


    /*
     * Load 42 into IR.
     */

    data_in = 8'd42;
    load = 1;

    #10;

    load = 0;

    $display("IR = %d", value);


    /*
     * Change data_in, but don't load it.
     */

    data_in = 8'd100;

    #10;

    $display("IR with load disabled = %d", value);


    /*
     * Now load 100.
     */

    load = 1;

    #10;

    load = 0;

    $display("IR after load = %d", value);


    $finish;

end

endmodule