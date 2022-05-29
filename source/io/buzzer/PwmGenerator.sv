module PwmGenerator #(parameter N = 20) (
    input logic clk,
    input logic reset_n,
    input logic[N - 1:0] duty_cycle,
    input logic[N - 1:0] full_cycle,
    output logic pwm_pulse
);

    logic[N - 1:0] counter;
    logic[N - 1:0] counter_next;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == '0)
            counter <= '0;
        else
            counter <= counter_next;

    assign counter_next = (counter < full_cycle) ? counter + 1'b1 : '0;
    assign pwm_pulse = (counter < duty_cycle) ? '1 : '0;

endmodule
