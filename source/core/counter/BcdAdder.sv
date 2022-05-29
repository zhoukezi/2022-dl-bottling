// 4位BCD加法器
module BcdAdder(
	input logic[3:0] lhs,
	input logic[3:0] rhs,
	input logic carry_in,
	output logic[3:0] sum,
	output logic carry_out
);

	logic[4:0] binary_sum;

	always_comb begin
		binary_sum = lhs + rhs + {4'd0, carry_in};
		if (binary_sum >= 5'd10)
			{carry_out, sum} = binary_sum + 5'd6;
		else
			{carry_out, sum} = binary_sum;
	end
endmodule
