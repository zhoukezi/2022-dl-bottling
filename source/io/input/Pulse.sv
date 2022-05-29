module Pulse (
    input logic clk,
    input logic reset_n,
    input logic in,
    output logic pos_pulse
);

    logic front, back, buffer;
    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == '0) begin
            front <= '0;
            back <= '0;
            buffer <= '0;
        end
        else begin
            front <= in;
            back <= front;
            buffer <= (front == '1 && back == '0);
        end

    assign pos_pulse = buffer;

endmodule
