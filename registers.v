module registers (
    input        clock,
    input        write_enable,

    input  [1:0] read_addr_a,
    input  [1:0] read_addr_b,

    input  [1:0] write_addr,
    input  [7:0] write_data,

    output [7:0] read_data_a,
    output [7:0] read_data_b
);

reg [7:0] r0;
reg [7:0] r1;
reg [7:0] r2;
reg [7:0] r3;

assign read_data_a =
    (read_addr_a == 2'b00) ? r0 :
    (read_addr_a == 2'b01) ? r1 :
    (read_addr_a == 2'b10) ? r2 :
                             r3;

assign read_data_b =
    (read_addr_b == 2'b00) ? r0 :
    (read_addr_b == 2'b01) ? r1 :
    (read_addr_b == 2'b10) ? r2 :
                             r3;

always @(posedge clock) begin
    if (write_enable) begin
        case (write_addr)
            2'b00: r0 <= write_data;
            2'b01: r1 <= write_data;
            2'b10: r2 <= write_data;
            2'b11: r3 <= write_data;
        endcase
    end
end

endmodule