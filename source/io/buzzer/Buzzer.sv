module Buzzer (
    input logic clk,
    input logic reset_n,
    input logic en,
    output buzzer
);

    logic[19:0] tone_cycle;
    logic pulse;

    PwmGenerator #(20) pwm_generator(
        .clk(clk),
        .reset_n(reset_n),
        .duty_cycle({3'b0, tone_cycle[19:3]}), // tone_cycle / 8
        .full_cycle(tone_cycle),
        .pwm_pulse(pulse)
    );

    assign tone_cycle = 20'd191_110;
    assign buzzer = (en) ? pulse : '0;

endmodule
