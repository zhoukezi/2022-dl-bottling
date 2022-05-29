module WorkingCounters (
	input logic clk,
	input logic reset_n,
    input logic en,
    input logic pill_pulse,
    input logic[7:0] bottle_setting,
    input logic[7:0] pill_setting,
    output logic[11:0] total,
    output logic[7:0] bottle,
    output logic[7:0] pill,
    output logic finished
);

    logic internal_carry;

    BcdCounterN #(3) total_counter(
        .clk(clk),
        .reset_n(reset_n),
        .en(en & !finished & pill_pulse),
        .modulus('1),
        .d(total),
        .carry_out()
    );

    BcdCounterN #(2) bottle_counter(
        .clk(clk),
        .reset_n(reset_n),
        .en(en & !finished & pill_pulse & internal_carry),
        .modulus('1),
        .d(bottle),
        .carry_out()
    );

    BcdCounterN #(2) pill_counter(
        .clk(clk),
        .reset_n(reset_n),
        .en(en & !finished & pill_pulse),
        .modulus(pill_setting),
        .d(pill),
        .carry_out(internal_carry)
    );

    assign finished = en ? (bottle == bottle_setting && pill == '0) : 1'b0;

endmodule
