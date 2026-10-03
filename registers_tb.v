`timescale 1ns/1ps

module registers_tb;

reg clock;
reg write_enable;

reg [1:0] read_addr_a;
reg [1:0] read_addr_b;

reg [1:0] write_addr;
reg [7:0] write_data;

wire [7:0] read_data_a;
wire [7:0] read_data_b;

registers uut (
    .clock(clock),
    .write_enable(write_enable),

    .read_addr_a(read_addr_a),
    .read_addr_b(read_addr_b),

    .write_addr(write_addr),
    .write_data(write_data),

    .read_data_a(read_data_a),
    .read_data_b(read_data_b)
);

/* Generate clock */
always #5 clock = ~clock;

initial begin

    clock = 0;
    write_enable = 0;

    read_addr_a = 0;
    read_addr_b = 0;

    write_addr = 0;
    write_data = 0;

    /*
     * Write 25 into R1.
     */
    write_addr = 2'b01;
    write_data = 8'd25;
    write_enable = 1;

    #10;

    /*
     * Write 40 into R2.
     */
    write_addr = 2'b10;
    write_data = 8'd40;

    #10;

    /*
     * Stop writing.
     */
    write_enable = 0;

    /*
     * Read R1 through port A
     * and R2 through port B.
     */
    read_addr_a = 2'b01;
    read_addr_b = 2'b10;

    #1;

    $display("R1 = %d", read_data_a);
    $display("R2 = %d", read_data_b);

    /*
     * Change the read addresses.
     * No clock is required for this.
     */
    read_addr_a = 2'b10;
    read_addr_b = 2'b01;

    #1;

    $display("After swapping read addresses:");
    $display("A = %d", read_data_a);
    $display("B = %d", read_data_b);

    $finish;

end

endmodule