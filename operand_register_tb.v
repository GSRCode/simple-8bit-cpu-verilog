`timescale 1ns/1ps

module operand_register_tb;

reg clock;
reg load;
reg [7:0] data_in;

wire [7:0] value;


operand_register uut (
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
     * Load 25.
     */

    data_in = 8'd25;
    load = 1;

    #10;

    load = 0;

    $display("Operand = %d", value);


    /*
     * Change input without loading.
     */

    data_in = 8'd100;

    #10;

    $display("Operand with load disabled = %d", value);


    /*
     * Now load 100.
     */

    load = 1;

    #10;

    load = 0;

    $display("Operand after load = %d", value);


    $finish;

end

endmodule