module PulseKey (
    input logic clk,
    input logic reset_n,
    input logic key_n,
    output logic pos_pulse
);

    logic debounce_key;

    logic input_buffer;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == '0)
            input_buffer <= '0;
        else
            input_buffer <= !key_n;

    Debounce debounce(
        .clk(clk),
        .reset_n(reset_n),
        .in(input_buffer),
        .out(debounce_key)
    );

    Pulse pulse(
        .clk(clk),
        .reset_n(reset_n),
        .in(debounce_key),
        .pos_pulse(pos_pulse)
    );

endmodule
