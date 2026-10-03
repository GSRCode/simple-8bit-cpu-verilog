module cpu (
    input clock,
    input reset
);

/*
 * Control signals
 */

wire pc_increment;
wire ir_load;
wire operand_load;
wire register_write;


/*
 * Datapath signals
 */

wire [7:0] pc_value;
wire [7:0] memory_read_data;
wire [7:0] ir_value;
wire [7:0] operand_value;

wire [7:0] register_read_a;
wire [7:0] register_read_b;


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
    .register_write(register_write)
);


/*
 * Program Counter
 */

pc pc_unit (
    .clock(clock),
    .reset(reset),
    .increment(pc_increment),
    .load(1'b0),
    .load_value(8'd0),
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
 * For LDI:
 *
 * destination register = instruction bits [3:2]
 * write data           = operand
 */

registers registers_unit (
    .clock(clock),
    .write_enable(register_write),

    .read_addr_a(2'b00),
    .read_addr_b(2'b00),

    .write_addr(ir_value[3:2]),
    .write_data(operand_value),

    .read_data_a(register_read_a),
    .read_data_b(register_read_b)
);

endmodule