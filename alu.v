module alu (
    input  [7:0] a,
    input  [7:0] b,
    input  [1:0] operation,
    output reg [7:0] result,
    output zero
);

always @(*) begin
    case (operation)
        2'b00: result = a + b;   // ADD
        2'b01: result = a - b;   // SUB
        2'b10: result = a & b;   // AND
        2'b11: result = a | b;   // OR
    endcase
end

assign zero = (result == 8'b00000000);

endmodule