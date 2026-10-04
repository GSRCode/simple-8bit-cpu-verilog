module control (
    input        clock,
    input        reset,
    input  [7:0] instruction,

    output reg   pc_increment,
    output reg   ir_load,
    output reg   operand_load,
    output reg   register_write
);


/*
 * CPU states
 */

localparam FETCH         = 2'b00;
localparam DECODE        = 2'b01;
localparam FETCH_OPERAND = 2'b10;
localparam EXECUTE       = 2'b11;


reg [1:0] state;
reg [1:0] next_state;


/*
 * Opcodes
 */

localparam LDI = 4'b0101;
localparam ADD = 4'b0110;
localparam SUB = 4'b0111;


/*
 * State register.
 */

always @(posedge clock) begin

    if (reset)
        state <= FETCH;
    else
        state <= next_state;

end


/*
 * Combinational control logic.
 */

always @(*) begin

    /*
     * Default values.
     */

    pc_increment   = 1'b0;
    ir_load        = 1'b0;
    operand_load   = 1'b0;
    register_write = 1'b0;

    next_state = state;


    case (state)

        FETCH: begin

            ir_load      = 1'b1;
            pc_increment = 1'b1;

            next_state = DECODE;

        end


        DECODE: begin

            if (instruction[7:4] == LDI)
                next_state = FETCH_OPERAND;
            else if (instruction[7:4] == ADD)
                next_state = EXECUTE;
            else if (instruction[7:4] == SUB)
                next_state = EXECUTE;
            else
                next_state = FETCH;

        end


        FETCH_OPERAND: begin

            operand_load = 1'b1;
            pc_increment = 1'b1;

            next_state = EXECUTE;

        end


        EXECUTE: begin

            if (instruction[7:4] == LDI)
                register_write = 1'b1;
            else if (instruction[7:4] == ADD)
                register_write = 1'b1;
            else if (instruction[7:4] == SUB)
                register_write = 1'b1;

            next_state = FETCH;

        end

    endcase

end

endmodule