module BcdCounterN #(parameter N = 2) (
	input logic clk,
	input logic reset_n,
    input logic en,
    input logic[4 * N - 1:0] modulus,
	output logic[4 * N - 1:0] d,
	output logic carry_out
);

	logic[4 * N - 1:0] d_next;
    logic internal_carry[N - 1:-1];

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_adder
            BcdAdder adder_i(
                .lhs(d[4 * i + 3:4 * i]),
                .rhs('0),
                .carry_in(internal_carry[i - 1]),
                .sum(d_next[4 * i + 3:4 * i]),
                .carry_out(internal_carry[i])
            );
        end
    endgenerate

    assign internal_carry[-1] = en;
    assign carry_out = internal_carry[N - 1] | d_next == modulus;

	always_ff@(posedge clk, negedge reset_n)
		if (reset_n == '0)
			d <= '0;
		else if (d_next == modulus)
            d <= '0;
        else
			d <= d_next;

endmodule
