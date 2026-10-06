`timescale 1ns/1ps

module alu_tb;

reg  [7:0] a;
reg  [7:0] b;
reg  [1:0] operation;

wire [7:0] result;
wire zero;

alu uut (
    .a(a),
    .b(b),
    .operation(operation),
    .result(result),
    .zero(zero)
);

initial begin

    // ADD: 5 + 3 = 8
    a = 8'd5;
    b = 8'd3;
    operation = 2'b00;
    #10;
    $display("ADD: %d + %d = %d, zero = %b",
             a, b, result, zero);

    // SUB: 5 - 3 = 2
    operation = 2'b01;
    #10;
    $display("SUB: %d - %d = %d, zero = %b",
             a, b, result, zero);

    // SUB: 5 - 5 = 0
    a = 8'd5;
    b = 8'd5;
    #10;
    $display("SUB: %d - %d = %d, zero = %b",
             a, b, result, zero);

    // AND
    a = 8'b11001100;
    b = 8'b10101010;
    operation = 2'b10;
    #10;
    $display("AND: %b AND %b = %b",
             a, b, result);

    // OR
    operation = 2'b11;
    #10;
    $display("OR : %b OR  %b = %b",
             a, b, result);

    $finish;

end

endmodule