module cpu (
    input clock,
    input reset
);

/*
 * Opcodes
 */

localparam LDI = 4'b0101;
localparam ADD = 4'b0110;
localparam SUB = 4'b0111;
localparam AND = 4'b1000;
localparam OR  = 4'b1001;

/*
 * Control signals
 */

wire pc_increment;
wire ir_load;
wire operand_load;
wire register_write;

wire pc_load;


/*
 * Datapath signals
 */

wire [7:0] pc_value;
wire [7:0] memory_read_data;
wire [7:0] ir_value;
wire [7:0] operand_value;

wire [7:0] register_read_a;
wire [7:0] register_read_b;

wire [7:0] alu_result;
wire       alu_zero;

wire [7:0] register_write_data;

wire [1:0] alu_operation;


/*
 * Register write data selection.
 *
 * LDI writes the operand register.
 * ADD writes the ALU result.
 */

assign register_write_data =
    (ir_value[7:4] == LDI) ? operand_value :
                             alu_result;

assign alu_operation =
    (ir_value[7:4] == SUB) ? 2'b01 :
    (ir_value[7:4] == AND) ? 2'b10 :
    (ir_value[7:4] == OR)  ? 2'b11 :
                             2'b00;


/*
 * Control Unit
 */

control control_unit (
    .clock(clock),
    .reset(reset),
    .instruction(ir_value),

    .pc_increment(pc_increment),
    .ir_load(ir_load),
    .operand_load(operand_load),
    .register_write(register_write),
    .pc_load(pc_load)
);


/*
 * Program Counter
 */

pc pc_unit (
    .clock(clock),
    .reset(reset),
    .increment(pc_increment),
    .load(pc_load),
    .load_value(operand_value),
    .value(pc_value)
);


/*
 * Memory
 */

memory memory_unit (
    .clock(clock),
    .write_enable(1'b0),
    .address(pc_value),
    .write_data(8'd0),
    .read_data(memory_read_data)
);


/*
 * Instruction Register
 */

instruction_register ir_unit (
    .clock(clock),
    .load(ir_load),
    .data_in(memory_read_data),
    .value(ir_value)
);


/*
 * Operand Register
 */

operand_register operand_unit (
    .clock(clock),
    .load(operand_load),
    .data_in(memory_read_data),
    .value(operand_value)
);


/*
 * General Purpose Registers
 *
 * instruction[3:2] = destination register
 * instruction[1:0] = source register
 */

registers registers_unit (
    .clock(clock),
    .write_enable(register_write),

    .read_addr_a(ir_value[3:2]),
    .read_addr_b(ir_value[1:0]),

    .write_addr(ir_value[3:2]),
    .write_data(register_write_data),

    .read_data_a(register_read_a),
    .read_data_b(register_read_b)
);


/*
 * ALU
 *
 * A = destination register
 * B = source register
 */

alu alu_unit (
    .a(register_read_a),
    .b(register_read_b),
    .operation(alu_operation),
    .result(alu_result),
    .zero(alu_zero)
);

endmodule