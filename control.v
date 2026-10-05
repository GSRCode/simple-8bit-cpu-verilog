module control (
    input        clock,
    input        reset,
    input  [7:0] instruction,

    output reg   pc_increment,
    output reg   ir_load,
    output reg   operand_load,
    output reg   register_write,
    output reg   pc_load,
    output reg   conditional_jump,
    output reg   memory_write
);


/*
 * CPU states
 */

localparam FETCH         = 3'b000;
localparam DECODE        = 3'b001;
localparam FETCH_OPERAND = 3'b010;
localparam EXECUTE       = 3'b011;
localparam HALT          = 3'b100;



reg [2:0] state;
reg [2:0] next_state;

/*
 * Opcodes
 */

localparam LDI = 4'b0101;
localparam ADD = 4'b0110;
localparam SUB = 4'b0111;
localparam AND = 4'b1000;
localparam OR  = 4'b1001;
localparam JZ  = 4'b1011;
localparam JMP = 4'b1010;
localparam HLT = 4'b1100;
localparam LOAD  = 4'b1101;
localparam STORE = 4'b1110;

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
    pc_load        = 1'b0;
    conditional_jump = 1'b0;
    memory_write = 1'b0;

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
            else if (instruction[7:4] == JMP)
                next_state = FETCH_OPERAND;
            else if (instruction[7:4] == JZ)
                next_state = FETCH_OPERAND;
            else if (instruction[7:4] == ADD)
                next_state = EXECUTE;
            else if (instruction[7:4] == SUB)
                next_state = EXECUTE;
            else if (instruction[7:4] == AND)
                next_state = EXECUTE;
            else if (instruction[7:4] == OR)
                next_state = EXECUTE;
            else if (instruction[7:4] == HLT)
                next_state = EXECUTE;
            else if (instruction[7:4] == LOAD)
                next_state = FETCH_OPERAND;
            else if (instruction[7:4] == STORE)
                next_state = FETCH_OPERAND;
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
            else if (instruction[7:4] == AND)
                register_write = 1'b1;
            else if (instruction[7:4] == OR)
                register_write = 1'b1;
            else if (instruction[7:4] == JMP)
                pc_load = 1'b1;
            else if (instruction[7:4] == JZ)
                conditional_jump = 1'b1;
            else if (instruction[7:4] == LOAD)
                register_write = 1'b1;
            else if (instruction[7:4] == STORE)
                memory_write = 1'b1;
             
            if (instruction[7:4] == HLT)
                next_state = HALT;
            else
                next_state = FETCH;
        end

        HALT: begin
            next_state = HALT;
        end

    endcase

end

endmodule