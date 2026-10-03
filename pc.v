module pc (
    input        clock,
    input        reset,
    input        increment,
    input        load,
    input  [7:0] load_value,
    output reg [7:0] value
);

always @(posedge clock) begin

    if (reset)
        value <= 8'd0;

    else if (load)
        value <= load_value;

    else if (increment)
        value <= value + 8'd1;

end

endmodule