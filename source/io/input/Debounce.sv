module Debounce (
    input logic clk,
    input logic reset_n,
    input logic in,
    output logic out
);

    logic[19:0] counter;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == '0)
            counter <= '0;
        else if (in == '0)
            counter <= '0;
        else if (in == '1 && counter != '1)
            counter <= counter + 1'd1;

    assign out = (reset_n == '0) ? '0 : counter == '1;

endmodule
