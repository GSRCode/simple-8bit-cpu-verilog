`timescale 1ns/1ps

module memory_tb;

reg clock;
reg write_enable;

reg [7:0] address;
reg [7:0] write_data;

wire [7:0] read_data;


memory uut (
    .clock(clock),
    .write_enable(write_enable),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);


/*
 * Generate clock.
 */

always #5 clock = ~clock;


initial begin

    clock = 0;
    write_enable = 0;
    address = 0;
    write_data = 0;


    /*
     * Write 25 to memory address 10.
     */

    address = 8'd10;
    write_data = 8'd25;
    write_enable = 1;

    #10;


    /*
     * Write 40 to memory address 20.
     */

    address = 8'd20;
    write_data = 8'd40;

    #10;


    /*
     * Write 100 to memory address 30.
     */

    address = 8'd30;
    write_data = 8'd100;

    #10;


    /*
     * Stop writing.
     */

    write_enable = 0;


    /*
     * Read address 10.
     */

    address = 8'd10;

    #1;

    $display("Memory[10] = %d", read_data);


    /*
     * Read address 20.
     */

    address = 8'd20;

    #1;

    $display("Memory[20] = %d", read_data);


    /*
     * Read address 30.
     */

    address = 8'd30;

    #1;

    $display("Memory[30] = %d", read_data);


    $finish;

end

endmodule