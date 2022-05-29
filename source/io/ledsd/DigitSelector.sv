module DigitSelector (
    input logic[47:0] digit_n,
    input logic[5:0] sel,
    output logic[7:0] out
);

    always_comb begin
        case (sel)
            6'b000_001: out = digit_n[7:0];
            6'b000_010: out = digit_n[15:8];
            6'b000_100: out = digit_n[23:16];
            6'b001_000: out = digit_n[31:24];
            6'b010_000: out = digit_n[39:32];
            6'b100_000: out = digit_n[47:40];
            default:    out = 8'bxxxx_xxxx;
        endcase
    end

endmodule
