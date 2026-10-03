module instruction_register (
    input        clock,
    input        load,
    input  [7:0] data_in,
    output reg [7:0] value
);

always @(posedge clock) begin

    if (load)
        value <= data_in;

end

endmodule