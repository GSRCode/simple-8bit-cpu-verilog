module memory (
    input        clock,
    input        write_enable,
    input  [7:0] address,
    input  [7:0] write_data,
    output [7:0] read_data
);

reg [7:0] mem [0:255];

// Initialize RAM with our program

integer i;

initial begin
    for (i = 0; i < 256; i = i + 1)
        mem[i] = 8'h00;

    $readmemh("program.hex", mem, 0, 5);
end



/*
 * Read from memory.
 * Reading is combinational.
 */

assign read_data = mem[address];


/*
 * Write to memory.
 * Writing happens on the positive clock edge.
 */

always @(posedge clock) begin

    if (write_enable)
        mem[address] <= write_data;

end

endmodule