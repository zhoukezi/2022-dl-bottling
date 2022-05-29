module SettingCounters (
	input logic clk,
	input logic reset_n,
    input logic en,
    input logic[1:0] selection,
    input logic add_pulse,
    input logic reset_pulse,
    output logic[7:0] bottle_setting,
    output logic[7:0] pill_setting
);

    BcdCounterN #(2) bottle_counter(
        .clk(clk),
        .reset_n(reset_n & !(reset_pulse & selection[1])),
        .en(en & selection[1] & add_pulse),
        .modulus('1),
        .d(bottle_setting),
        .carry_out()
    );

    BcdCounterN #(2) pill_counter(
        .clk(clk),
        .reset_n(reset_n & !(reset_pulse & selection[0])),
        .en(en & selection[0] & add_pulse),
        .modulus('1),
        .d(pill_setting),
        .carry_out()
    );

endmodule
